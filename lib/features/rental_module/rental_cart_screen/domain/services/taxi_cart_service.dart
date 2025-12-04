
import 'package:sixam_mart/features/rental_module/rental_cart_screen/domain/repository/taxi_cart_repository_interface.dart';
import 'package:sixam_mart/features/rental_module/rental_cart_screen/domain/services/taxi_cart_service_interface.dart';

class TaxiCartService implements TaxiCartServiceInterface {
  TaxiCartRepositoryInterface taxiCartRepositoryInterface;

  TaxiCartService({required this.taxiCartRepositoryInterface});

}