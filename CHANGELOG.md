## [Unreleased]

- Update `httparty` to use `0.20.0` or a higher version

## [0.1.0] - 2022-07-20

- Initial release

## [0.1.1] - 2022-07-22

- Wraps endpoints response in a `Prest::Response` object for easier access to the response data

## [0.1.2] - 2022-08-05

- Change how urls are built. Underscore in the fragment building stays as an underscore. Dashes are made with `__`

## [0.1.3] - 2022-08-05

- Add `Prest::Service` object for easier rails integration with service-object pattern
