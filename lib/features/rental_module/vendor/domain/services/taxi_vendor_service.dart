
import 'package:sixam_mart/features/rental_module/vendor/domain/repositories/taxi_vendor_repository_interface.dart';
import 'package:sixam_mart/features/rental_module/vendor/domain/services/taxi_vendor_service_interface.dart';

class TaxiVendorService implements TaxiVendorServiceInterface {
  final TaxiVendorRepositoryInterface taxiVendorRepositoryInterface;

  TaxiVendorService({required this.taxiVendorRepositoryInterface});


}
