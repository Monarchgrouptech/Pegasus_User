
import 'package:sixam_mart/features/rental_module/rental_order/domain/repository/taxi_order_repository_interface.dart';
import 'package:sixam_mart/features/rental_module/rental_order/domain/services/taxi_order_service_interface.dart';

class TaxiOrderService implements TaxiOrderServiceInterface {
  final TaxiOrderRepositoryInterface taxiOrderRepositoryInterface;

  TaxiOrderService({required this.taxiOrderRepositoryInterface});


}