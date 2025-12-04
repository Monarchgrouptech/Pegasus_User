import 'package:get/get.dart';
import 'package:sixam_mart/features/rental_module/vendor/domain/services/taxi_vendor_service_interface.dart';

class TaxiVendorController extends GetxController implements GetxService {
  final TaxiVendorServiceInterface taxiVendorServiceInterface;

  TaxiVendorController({required this.taxiVendorServiceInterface});

}