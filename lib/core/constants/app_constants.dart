import 'package:catalogat_app/core/dependencies.dart';

final GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

class AppConstants {
  static const String fontFamilyName = 'Tajawal';
  static const String supabaseUrl = 'https://lfkejvgkvxintiurcfcx.supabase.co/rest/v1/rpc/';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxma2VqdmdrdnhpbnRpdXJjZmN4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM2OTg0NzQsImV4cCI6MjA1OTI3NDQ3NH0.JOVt2jYollW5EbpIAAj2sVFURI4Uyr9vuuU7NFPuYk0';

  static const String arabicLanguageCode = 'ar';
  static const String englishLanguageCode = 'en';
}

class ApiConstants {
  static const String apikey = 'apikey';
}