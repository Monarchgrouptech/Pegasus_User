
import 'package:sixam_mart/features/rental_module/rental_favourite/domain/repositories/taxi_favourite_repository_interface.dart';
import 'package:sixam_mart/features/rental_module/rental_favourite/domain/services/taxi_favourite_service_interface.dart';

class TaxiFavouriteService implements TaxiFavouriteServiceInterface {
  final TaxiFavouriteRepositoryInterface taxiFavouriteRepositoryInterface;
  TaxiFavouriteService({required this.taxiFavouriteRepositoryInterface});

}