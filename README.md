# Viet Date Time

Hỗ trợ trong việc chuyển đổi và tính toán ngày tháng, thời gian và can chi theo lịch Việt Nam.

## Sử Dụng

``` dart
final vietDateTime = VietDateTime.fromSolar(DateTime.now());
```

Kiểm tra tháng hiện tại có phải tháng nhuần hay không

``` dart
final isLeapMonth = vietDateTime.isLeapMonth;
```

Bạn có thể sử dụng các phép tính như `DateTime`

``` dart
vietDateTime.add(Duration(days: 3));
vietDateTime.compareTo(VietDateTime.fromSolar(DateTime.now()));
```
