import 'package:sixam_mart/features/rental_module/rental_location_screen/domain/repository/taxi_repository_interface.dart';
import 'package:sixam_mart/features/rental_module/rental_location_screen/domain/services/taxi_location_service_interface.dart';

class TaxiLocationService implements TaxiLocationServiceInterface{
  TaxiRepositoryInterface taxiRepositoryInterface;
  TaxiLocationService({required this.taxiRepositoryInterface});
}