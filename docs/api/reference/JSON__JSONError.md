# JSON::JSONError

Parent of the JSON errors

How to use it: [Utilities](../utilities.md).

Inherits from: [`StandardError`](StandardError.md)

When `JSON.parse` expects a `,` or `:` and does not find it, it raises this `JSONError`
itself, not a `ParserError`. To catch everything from JSON, `rescue JSON::JSONError`.

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@521eb2e7.*
