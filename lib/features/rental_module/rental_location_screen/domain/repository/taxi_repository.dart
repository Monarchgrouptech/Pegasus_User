import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/rental_module/rental_location_screen/domain/repository/taxi_repository_interface.dart';

class TaxiRepository implements TaxiRepositoryInterface{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  TaxiRepository({required this.sharedPreferences, required this.apiClient});

}