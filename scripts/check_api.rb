#!/usr/bin/env ruby
# Check the API pages against the firmware they document.
#
#   ruby scripts/check_api.rb [path to fmruby-core]
#
# Three things drift, and all three have bitten this site:
#
#   methods    a page loses touch with a class -- FmrbApp had timers, extra
#              canvases and idle_gc that no page mentioned
#   constants  a page names one that does not exist -- MOD_GUI raised
#              NameError for anyone who copied it, and every MOD_* value was
#              the USB HID layout rather than this firmware's
#   paths      an app moves and the page still points at where it was
#
# It reads the firmware sources, not a generated list, so it stays true
# without anything to regenerate. It is deliberately NOT in the deploy
# workflow: the site can legitimately describe an API that is on develop and
# not yet on main, and this needs a person to tell that from a gap.
#
# Adding a target: name the page, its sources, and -- when the page should not
# list something -- put it in `internal:` with a reason. Anything this prints
# is then a real gap.

require "set"

CORE = ARGV[0] || ENV["FMRUBY_CORE"] ||
       ["../fmruby-core", "../../fmruby-core", "#{ENV["HOME"]}/fmrb/family-mruby/fmruby-core"]
       .find { |d| Dir.exist?(d) }

abort "cannot find fmruby-core; pass its path" unless CORE && Dir.exist?(CORE)

APP  = "lib/add/picoruby-fmrb-app"
DOCS = "docs/api"

# page => sources, plus the names it is right not to list.
TARGETS = [
  { page: "fmrb_app.md",
    src: ["#{APP}/mrblib/fmrb-app.rb", "#{APP}/ports/esp32/app.c"],
    internal: %w[initialize main_loop
                 attach_ui detach_ui
                 ps_gen pool_usage ble_start ble_state rd_stream_state
                 hid_raw_subscribe hid_raw_unsubscribe],
    internal_why: "the app loop itself; FmrbUI attaches itself; the rest is the desktop, the monitor and the HID inspector" },
  { page: "fmrb_gfx.md",
    src: ["#{APP}/mrblib/fmrb-gfx.rb", "#{APP}/ports/esp32/gfx.c"],
    internal: %w[initialize font_key resolve_font destroy
                 draw_free_iram draw_wallclock
                 play pause stop rewind status playing? finished? width height],
    internal_why: "canvas lifecycle the app base owns, menu-bar helpers, and FmrbVideo's own methods (documented on the video section)" },
  { page: "sprite.md",
    src: ["#{APP}/mrblib/fmrb-sprite.rb", "#{APP}/mrblib/gfx_block.rb"],
    internal: %w[initialize to_i intern_string destroyed? extract_regs exec_updates],
    internal_why: "GfxBlock's bytecode plumbing" },
  { page: "audio.md",
    src: ["#{APP}/mrblib/fmrb-audio.rb"],
    internal: %w[initialize sync_needed? wav_cache_path],
    internal_why: "where play_wav stages a clip" },
  { page: "p5.md",
    src: ["#{APP}/mrblib/p5.rb"],
    internal: %w[initialize transform translate_only? matrix_multiply draw_edge fill_rect_blended],
    internal_why: "the matrix and the triangle decomposition behind the shapes" },
  { page: "tilemap.md",
    src: ["#{APP}/mrblib/fmrb-tilemap.rb"],
    internal: %w[initialize packed? u16 sub_bytes load_packed load_json
                 build_walkable_mask ensure_view],
    internal_why: "the two loaders and their helpers" },
  { page: "ui.md",
    src: ["#{APP}/mrblib/fmrb-ui.rb"],
    internal: %w[initialize add draw_widget option_text field_text paint_bg_rect
                 relayout press release activate fires_on_press? direction group
                 on? set_on value set_value set_range set_field_text focus type_key
                 hit? place text_h text_size measure center_text set_text
                 arrow_w draw_arrow clamp build_text active? max_scroll
                 track_y track_h thumb_h thumb_y press_dir focused? find focused
                 type_into_focus set_focus apply_group],
    internal_why: "Widget's own protocol -- an app drives the box, not a widget" },
]

# FmrbConst / FmrbHw: names, checked both ways.
CONST_SRC  = "#{APP.sub("fmrb-app", "fmrb-const")}/ports/esp32/const.c"
CONST_PAGE = "const.md"
# Ranges the page writes out rather than listing every member.
CONST_COVERED = /\A(KEY_[0-9A-Z]|KEY_F\d+|PROC_ID_USER_APP[1-4])\z/

def read(*paths) = paths.map { |f| File.exist?(f) ? File.read(f) : "" }.join("\n")

def methods_in(files)
  files.flat_map do |f|
    body = File.exist?(f) ? File.read(f) : ""
    if f.end_with?(".rb")
      body.scan(/^\s*def (?:self\.)?([a-z_0-9]+[?=!]?)/).flatten
    else
      body.scan(/mrb_define_(?:class_)?method\(mrb, [a-z_0-9]+, "([a-z_0-9?=!]+)"/).flatten
    end
  end.uniq.reject { |n| n.start_with?("_") }
end

# A setter is written "suffix = \"%\"" on a page, not "suffix=".
def mentioned?(doc, name)
  needle = name.end_with?("=") ? "#{name[0..-2]}\s*=" : Regexp.escape(name)
  doc =~ /(?<![a-z_])#{needle}(?![a-z_])/
end

problems = 0

TARGETS.each do |t|
  page = File.join(DOCS, t[:page])
  next warn("#{page}: no such page") unless File.exist?(page)
  doc = File.read(page)
  names = methods_in(t[:src].map { |f| File.join(CORE, f) })
  missing = names.reject { |n| t[:internal].include?(n) || mentioned?(doc, n) }
  next if missing.empty?
  problems += missing.size
  puts "#{t[:page]}: #{missing.size} method(s) the page does not mention"
  missing.each { |m| puts "    #{m}" }
end

# Constants, both ways.
const_body = read(File.join(CORE, CONST_SRC))
defined_names = (const_body.scan(/mrb_define_const\(mrb, [a-z_0-9]+, "([A-Z_0-9]+)"/) +
                 const_body.scan(/define_(?:int|str)_const\(mrb, [a-z_0-9]+, *"([A-Z_0-9]+)"/))
                .flatten.uniq.to_set
doc = File.read(File.join(DOCS, CONST_PAGE))
missing = defined_names.reject { |n| n =~ CONST_COVERED || mentioned?(doc, n) }
unless missing.empty?
  problems += missing.size
  puts "#{CONST_PAGE}: #{missing.size} constant(s) the page does not mention"
  missing.sort.each { |m| puts "    #{m}" }
end
invented = doc.scan(/`(?:FmrbConst::|FmrbHw::)?((?:KEY|MOD|GP|PROC_STATE|PROC_ID|APP_CTRL|MSG_TYPE|THEME|LED_ERR|PIN)_[A-Z_0-9]+)/)
              .flatten.uniq.reject { |n| defined_names.include?(n) }
unless invented.empty?
  problems += invented.size
  puts "#{CONST_PAGE}: #{invented.size} constant(s) the page names that do not exist"
  invented.sort.each { |m| puts "    #{m}" }
end

# Device paths the pages point at.
paths = Dir.glob("docs/**/*.md").flat_map { |f| File.read(f).scan(%r{(?<!cache)/(?:app|usr/share)/[A-Za-z0-9_./-]+}) }
           .map { |p| p.sub(/[.,)`]+\z/, "") }.uniq
# Names a reader is meant to create, and the remote desktop's endpoints.
PLACEHOLDER = /mygame|my_clock|myapp|\bhello\b|\bmy\.app\b|song\.(mid|nsf)|\/app\/(usr|launch|kill|list)\b/
gone = paths.reject { |p| p =~ PLACEHOLDER || File.exist?(File.join(CORE, "flash", p)) }
unless gone.empty?
  problems += gone.size
  puts "paths: #{gone.size} that are not in the firmware tree"
  gone.sort.each { |m| puts "    #{m}" }
end

if problems.zero?
  puts "check_api: pages agree with #{CORE}"
  exit 0
end
warn "check_api: #{problems} thing(s) to look at (each is either a gap or a name for the internal list)"
exit 1
