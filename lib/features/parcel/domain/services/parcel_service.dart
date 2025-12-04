import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/checkout/domain/models/place_order_body_model.dart';
import 'package:sixam_mart/features/checkout/domain/repositories/checkout_repository_interface.dart';
import 'package:sixam_mart/features/parcel/domain/models/parcel_cancellation_reasons_model.dart';
import 'package:sixam_mart/features/parcel/domain/models/parcel_category_model.dart';
import 'package:sixam_mart/features/parcel/domain/models/video_content_model.dart';
import 'package:sixam_mart/features/parcel/domain/models/why_choose_model.dart';
import 'package:sixam_mart/features/parcel/domain/repositories/parcel_repository_interface.dart';
import 'package:sixam_mart/features/parcel/domain/services/parcel_service_interface.dart';
import 'package:sixam_mart/features/payment/domain/models/offline_method_model.dart';

import '../models/parcel_instruction_model.dart';

class ParcelService implements ParcelServiceInterface{
  final ParcelRepositoryInterface parcelRepositoryInterface;
  final CheckoutRepositoryInterface checkoutRepositoryInterface;
  ParcelService({required this.parcelRepositoryInterface, required this.checkoutRepositoryInterface});

  @override
  Future<List<ParcelCategoryModel>?> getParcelCategory() async {
    return await parcelRepositoryInterface.getList();
  }

  @override
  Future<List<Data>?> getParcelInstruction(int offset) async {
    return await parcelRepositoryInterface.getList(offset: offset, parcelCategory: false);
  }

  @override
  Future<WhyChooseModel?> getWhyChooseDetails({required DataSourceEnum source}) async {
    return await parcelRepositoryInterface.get(null, isVideoDetails: false, source: source);
  }

  @override
  Future<VideoContentModel?> getVideoContentDetails({required DataSourceEnum source}) async {
    return await parcelRepositoryInterface.get(null, isVideoDetails: true, source: source);
  }

  @override
  Future<LatLng> getPlaceDetails(String? placeID) async {
    LatLng latLng = const LatLng(0, 0);
    Response? response = await parcelRepositoryInterface.getPlaceDetails(placeID);
    if(response.statusCode == 200) {

      final data = response.body;
      final location = data['location'];
      final double lat = location['latitude'];
      final double lng = location['longitude'];
      latLng = LatLng(lat, lng);
    }
    return latLng;
  }

  @override
  Future<List<OfflineMethodModel>?> getOfflineMethodList() async {
    return await checkoutRepositoryInterface.getList();
  }

  @override
  Future<int> getDmTipMostTapped() async {
    return await checkoutRepositoryInterface.getDmTipMostTapped();
  }

  @override
  Future<Response> placeOrder(PlaceOrderBodyModel orderBody) async {
    return await checkoutRepositoryInterface.placeOrder(orderBody, null);
  }

  @override
  Future<ParcelCancellationReasonsModel?> getParcelCancellationReasons({required bool isBeforePickup}) async {
    return parcelRepositoryInterface.getParcelCancellationReasons(isBeforePickup: isBeforePickup);
  }

}