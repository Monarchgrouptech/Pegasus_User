import 'package:get/get.dart';
import 'package:sixam_mart/features/rental_module/rental_favourite/domain/services/taxi_favourite_service_interface.dart';

class TaxiFavouriteController extends GetxController implements GetxService {
  final TaxiFavouriteServiceInterface taxiFavouriteServiceInterface;

  TaxiFavouriteController({required this.taxiFavouriteServiceInterface});

  Future<void> getFavouriteTaxiList() async {}
}