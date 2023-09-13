# Viet Date Time

Hỗ trợ trong việc chuyển đổi và tính toán ngày tháng, thời gian và can chi theo lịch Việt Nam.

## Sử Dụng

Khai báo theo ngày tháng cu thê:

``` dart
// Ngày 1 tháng 10 năm 2023 và tháng 10 không phải tháng nhuần
final vietDateTime = VietDateTime(false, 2023, 10, 1);
```

Chuyển đổi từ `DateTime`:

``` dart
final vietDateTime = VietDateTime.now();
// Or
final vietDateTime = VietDateTime.fromDateTime(DateTime.now());
// Or
final vietDateTime = DateTime.now().toVietDateTime;
```

Chuyển từ `VietDateTime` sang `DateTime`:

``` dart
final dateTime = vietDateTime.toDateTime();
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
// Kết quả sẽ là danh sách với thời gian tính theo `VietDateTime`
VietDateTime.lunarEvents;

// Các ngày lễ theo dương lịch
// Kết quả sẽ là danh sách với thời gian tính theo `DateTime`
VietDateTime.solarEvents; 
```
