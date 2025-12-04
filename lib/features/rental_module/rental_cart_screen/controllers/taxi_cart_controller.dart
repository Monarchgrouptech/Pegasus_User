
import 'package:get/get.dart';
import 'package:sixam_mart/features/rental_module/rental_cart_screen/domain/models/car_cart_model.dart';
import 'package:sixam_mart/features/rental_module/rental_cart_screen/domain/services/taxi_cart_service_interface.dart';

class TaxiCartController extends GetxController implements GetxService {
  final TaxiCartServiceInterface taxiCartServiceInterface;

  TaxiCartController({required this.taxiCartServiceInterface});

  final List<Carts> _cartList = [];
  List<Carts> get cartList => _cartList;

  Future<bool> getCarCartList() async {
    return true;
  }

  Future<bool> clearTaxiCart({int? vehicleId, int? quantity, String? pickupTime, String? rentalType}) async {
    return true;
  }

}