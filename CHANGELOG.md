## 0.0.1-rc.7

* Improve `VietEvent` and `VietEvenList` serializer.
* Add a few base tests.

## 0.0.1-rc.6

* Add serializers to `VietEvent` and `VietEventList`.
* Fix issue related to `timeZoneOffset`.
* `==` operator now works correctly.

## 0.0.1-rc.5

* Add the return type to `lunarEvents` and `solarEvents`.

## 0.0.1-rc.4

* Export `.toVietDateTime` extension.

## 0.0.1-rc.3

[BREAKING CHANGE]

* Rename from `.toSolar` to `.toDateTime`.
* Rename from `.fromSolar` to `.fromDateTime`.
* Rename from `judianDayNumber` to `julianDayNumber`.
* Add `VietDateTime.lunarEvents` and `VietDateTime.solarEvents`.
* Add extension `.toVietDateTime` to convert from `DateTime` to `VietDateTime`.

## 0.0.1-rc.2

* Use positioned parameters instead of named.

## 0.0.1-rc.1

* Initial release
