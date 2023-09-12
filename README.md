# Viet Date Time

Hỗ trợ trong việc chuyển đổi và tính toán ngày tháng, thời gian và can chi theo lịch Việt Nam.

## Sử Dụng

``` dart
final vietDateTime = VietDateTime.fromSolar(DateTime.now());
```

Hoặc sử dụng extension

``` dart
final vietDateTime = dateTime.toLunar;
```

Kiểm tra tháng hiện tại có phải tháng nhuần hay không

``` dart
final isLeapMonth = vietDateTime.isLeapMonth;
```

Bạn có thể sử dụng các phép tính như `DateTime` và có thể sử dụng thay thế cho `DateTime`

``` dart
vietDateTime.add(Duration(days: 3));
vietDateTime.compareTo(VietDateTime.fromSolar(DateTime.now()));
```

Thông tin các ngày lễ trong năm:

``` dart
// Các ngày lễ theo âm lịch
VietDateTime.lunarEvents;

// Các ngày lễ theo dương lịch
VietDateTime.solarEvents;
```
