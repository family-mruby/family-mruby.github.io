#!/usr/bin/env ruby
# Check every internal link in a built site: the page it names, and the
# heading it points at.
#
# A heading link is the one that rots silently. mkdocs reports a page that
# does not exist, but not a "#..." that matches no id -- and the Japanese
# pages are full of them, because their anchors are the Japanese headings and
# it is easy to copy an English one across.
#
#   ruby scripts/check_links.rb [site_dir]
#
# Exit status is 1 when something does not resolve, so it can gate a deploy.
# Paths under IGNORED are skipped: they are generated into the build (the
# console is fetched by sync-console.sh) and are simply absent locally.

require "set"
require "uri"

ROOT = ARGV[0] || "site"
IGNORED = ["/console/", "/studio/"]

abort("#{ROOT}: no such directory -- build the site first (./build.sh)") unless Dir.exist?(ROOT)

# id="..." of every heading and anchor in a page, read once per page.
ids = Hash.new do |h, path|
  h[path] = File.exist?(path) ? File.read(path).scan(/\bid="([^"]+)"/).flatten.to_set : nil
end

bad = []
pages = Dir.glob(File.join(ROOT, "**", "*.html")).sort

pages.each do |page|
  html = File.read(page)
  rel = page.sub(%r{\A#{Regexp.escape(ROOT)}/?}, "")
  html.scan(/(?:href|src)="([^"]+)"/) do |(link)|
    next if link.start_with?("http://", "https://", "mailto:", "data:", "//", "javascript:")
    next if IGNORED.any? { |prefix| link.start_with?(prefix) }

    path, frag = link.split("#", 2)
    path = path.split("?", 2).first.to_s   # cache-busting query, not part of the path
    frag = URI.decode_www_form_component(frag) if frag && !frag.empty?

    if path.nil? || path.empty?
      target = page                       # same-page anchor
    elsif path.start_with?("/")
      target = File.join(ROOT, path)
    else
      target = File.expand_path(path, File.dirname(page))
    end
    target = File.join(target, "index.html") if target.end_with?("/") || File.directory?(target)

    unless File.exist?(target)
      bad << "#{rel} -> #{link} (no such file)"
      next
    end
    next if frag.nil? || frag.empty?
    unless ids[target]&.include?(frag)
      bad << "#{rel} -> #{link} (no heading with that id)"
    end
  end
end

if bad.empty?
  puts "check_links: #{pages.size} pages, every internal link resolves"
  exit 0
end

warn "check_links: #{bad.uniq.size} broken link(s)"
bad.uniq.each { |b| warn "  #{b}" }
exit 1
