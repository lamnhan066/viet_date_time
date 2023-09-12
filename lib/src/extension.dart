import 'package:viet_date_time/src/viet_date_time.dart';

/// Convert from solar (normal DateTime) to VietDateTime.
extension SolarToLunarConverter on DateTime {
  VietDateTime get toVietDateTime => VietDateTime.fromDateTime(this);
}
