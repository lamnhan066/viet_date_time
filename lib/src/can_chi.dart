import 'base.dart';
import 'models/can_chi.dart';

// String getCanChiYear(int year) {
//   final String can = canYear[year % 10];
//   final String chi = chiYear[year % 12];
//   return '$can $chi';
// }

String getCanChiMonth(int month, int year) {
  final String chi = chiMonth[month - 1];
  final String can = canYear[year % 10];
  int indexCan = 0;

  if (can == "Giáp" || can == "Kỉ") {
    indexCan = 6;
  }
  if (can == "Ất" || can == "Canh") {
    indexCan = 8;
  }
  if (can == "Bính" || can == "Tân") {
    indexCan = 0;
  }
  if (can == "Đinh" || can == "Nhâm") {
    indexCan = 2;
  }
  if (can == "Mậu" || can == "Quý") {
    indexCan = 4;
  }
  return '${canYear[(indexCan + month - 1) % 10]} $chi';
}

// getDayName(lunarDate) {
//  if (lunarDate.day == 0) {
//    return "";
//  }
//  var cc = getCanChi(lunarDate);
//  var s = "Ngày " + cc[0] +", tháng "+cc[1] + ", năm " + cc[2];
//  return s;
//}

String getCanChiOfYear(int year) {
  return "${can[(year + 6) % 10]} ${chi[(year + 8) % 12]}";
}

String getCanOfHour(int jdn) {
  return can[(jdn - 1) * 2 % 10];
}

String getCanChiOfDay(int jdn) {
  return "${can[(jdn + 9) % 10]} ${chi[(jdn + 1) % 12]}";
}

/// Giờ hoàng đạo
String getLuckyHour(int jd) {
  final int chiOfDay = (jd + 1) % 12;
  // same values for Ty' (1) and Ngo. (6), for Suu and Mui etc.
  final String gioHD = luckyHour[chiOfDay % 6];
  String ret = "";
  int count = 0;
  for (int i = 0; i < 12; i++) {
    if (gioHD.substring(i, i + 1) == '1') {
      ret += chi[i];
      ret += ' (${(i * 2 + 23) % 24}-${(i * 2 + 1) % 24})';
      if (count++ < 5) ret += ', ';
      if (count == 3) ret += '\n';
    }
  }
  return ret;
}

/// Tiết khí
String getSolarTerms(int jd) {
  return solarTerms[getSunLongitude(jd + 1, 7.0)];
}

String getCanChiOfStartHour(int jdn) {
  return '${can[(jdn - 1) * 2 % 10]} ${chi[0]}';
}
