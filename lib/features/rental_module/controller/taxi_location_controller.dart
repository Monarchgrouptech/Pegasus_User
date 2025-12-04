
import 'package:get/get.dart';
import 'package:sixam_mart/features/rental_module/domain/services/taxi_location_service_interface.dart';

class TaxiLocationController extends GetxController implements GetxService {
  final TaxiLocationServiceInterface taxiLocationServiceInterface;

  TaxiLocationController({required this.taxiLocationServiceInterface});

}