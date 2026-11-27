# Module

Operations on classes and modules

Operations on classes and modules (Module), with a class as the receiver, as in
`Object.const_defined?(:X)`. Implemented in mruby's own src/class.c
(const_defined?) and mruby-metaprog (remove_method).

## Instance methods

### Module#const_defined?

<pre class="fmrb-sig"><code>const_defined?(<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a> name, ?bool inherit) -&gt; bool</code></pre>

Whether a constant is defined

true when name is a constant. **It returns false, not an exception, when the
constant is not there** (use it to see whether a gem is built in). NameError
when name is not shaped like a constant name (it starts with a lowercase letter, ...).

`inherit` (true when left out): true also counts the constants of the parent
classes and of Object; false counts only the ones the receiver holds itself.
```ruby
if Object.const_defined?(:Digest)
  # Digest is there
end
```

### Module#remove_method

<pre class="fmrb-sig"><code>remove_method(*<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a> names) -&gt; self</code></pre>

Remove methods defined in this class

Removes **only methods defined directly in this receiver**. One inherited from the
parent cannot be removed: NameError ("method 'x' not defined in ...").
Once it is removed, a method of the same name in the parent is called instead.

Names are Symbols or Strings (anything else is a TypeError); several can be
given at once. Returns the receiver (self). FrozenError on a frozen class.
```ruby
self.class.remove_method(:draw_title)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@095a863f.*
