# JSON::GeneratorError

JSON.generate error (NaN, infinity)

How to use it: [Utilities](../utilities.md).

Inherits from: [`JSON::JSONError`](JSON__JSONError.md)

`JSON.generate` raises it for a Float NaN or infinity (nested ones too), with a message such as
`"NaN not allowed in JSON"`. Other values it cannot write are written as strings instead.

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@76d45150.*
