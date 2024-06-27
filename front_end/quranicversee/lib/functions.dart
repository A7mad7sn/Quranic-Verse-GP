import 'dart:async';
import 'dart:convert';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

String toEnglishNumbers(String value) {
  return value
      .replaceAll('٠', '0')
      .replaceAll('١', '1')
      .replaceAll('٢', '2')
      .replaceAll('٣', '3')
      .replaceAll('٤', '4')
      .replaceAll('٥', '5')
      .replaceAll('٦', '6')
      .replaceAll('٧', '7')
      .replaceAll('٨', '8')
      .replaceAll('٩', '9');
}


String toArabicNumbers(String value) {
  return value
      .replaceAll('0', '٠')
      .replaceAll('1', '١')
      .replaceAll('2', '٢')
      .replaceAll('3', '٣')
      .replaceAll('4', '٤')
      .replaceAll('5', '٥')
      .replaceAll('6', '٦')
      .replaceAll('7', '٧')
      .replaceAll('8', '٨')
      .replaceAll('9', '٩');
}

String getHijriMonthName(int monthNumber) {
  switch (monthNumber) {
    case 1:
      return 'مُحَرَّم';
    case 2:
      return 'صَفَر';
    case 3:
      return 'رَبِيع الأوَّل';
    case 4:
      return 'رَبِيع الثانِي';
    case 5:
      return 'جُمادى الأوَّل';
    case 6:
      return 'جُمادى الثانِيَة';
    case 7:
      return 'رَجَب';
    case 8:
      return 'شَعْبَان';
    case 9:
      return 'رَمَضان';
    case 10:
      return 'شَوَّال';
    case 11:
      return 'ذُو الْقَعْدَة';
    case 12:
      return 'ذُو الْحِجَّة';
    default:
      return '';
  }
}

String getArabicMonthName(String monthNumber) {
  switch (monthNumber) {
    case '01':
      return 'يناير';
    case '02':
      return 'فبراير';
    case '03':
      return 'مارس';
    case '04':
      return 'أبريل';
    case '05':
      return 'مايو';
    case '06':
      return 'يونيو';
    case '07':
      return 'يوليو';
    case '08':
      return 'أغسطس';
    case '09':
      return 'سبتمبر';
    case '10':
      return 'أكتوبر';
    case '11':
      return 'نوفمبر';
    case '12':
      return 'ديسمبر';
    default:
      return '';
  }
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw 'Location services are disabled. Please enable location services.';
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'Location permissions are denied. Please allow location permissions.';
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw 'Location permissions are permanently denied. Please enable them from settings.';
  }

  return await Geolocator.getCurrentPosition();
}

String handleLocationError(Object error) {
  if (error is String) {
    return error;
  } else {
    return 'An unexpected error occurred. Please try again.';
  }
}





