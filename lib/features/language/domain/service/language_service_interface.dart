import 'package:flutter/material.dart';
import 'package:sixam_mart/features/language/domain/models/language_model.dart';

abstract class LanguageServiceInterface {
  bool setLTR(Locale locale);
  void updateHeader(Locale locale, int? moduleId);
  Locale getLocaleFromSharedPref();
  int setSelectedIndex(List<LanguageModel> languages, Locale locale);
  void saveLanguage(Locale locale);
  void saveCacheLanguage(Locale locale);
  Locale getCacheLocaleFromSharedPref();
}
