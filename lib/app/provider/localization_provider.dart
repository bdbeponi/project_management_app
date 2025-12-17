// import 'package:flutter/material.dart';

// class LocalizationProvider with ChangeNotifier {
//   Locale _locale;

//   LocalizationProvider(String? code)
//     : _locale = code != null ? Locale(code) : const Locale(kKeyEnglishLocale);

//   Locale get locale => _locale;

//   Future<void> setLocale(Locale locale) async {
//     _locale = locale;
//     appData.write(kKeyLocale, locale.languageCode);
//     notifyListeners();
//   }
// }
