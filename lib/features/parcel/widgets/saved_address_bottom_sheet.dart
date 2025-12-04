import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/features/address/controllers/address_controller.dart';
import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/features/location/screens/pick_map_screen.dart';

class SavedAddressBottomSheet extends StatefulWidget {
  final bool isSender ;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController streetController;
  final TextEditingController houseController;
  final TextEditingController floorController;
  final TextEditingController? guestEmailController;
  final String? countryCode;
  final TextEditingController senderAddressController;
  final TextEditingController receiverAddressController;
  const SavedAddressBottomSheet({super.key, required this.isSender, required this.nameController, required this.phoneController,
  required this.streetController, required this.houseController, required this.floorController, required this.countryCode,
  this.guestEmailController, required this.senderAddressController, required this.receiverAddressController});

  @override
  State<SavedAddressBottomSheet> createState() => _SavedAddressBottomSheetState();
}

class _SavedAddressBottomSheetState extends State<SavedAddressBottomSheet> {
  String? _countryCode;
  String? _addressCountryCode;

  @override
  void initState() {
    super.initState();
    _addressCountryCode = null;
    _countryCode = _addressCountryCode ?? widget.countryCode;
  }

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);
    _countryCode = _addressCountryCode ?? widget.countryCode;

    return GetBuilder<ParcelController>(builder: (parcelController) {
      return GetBuilder<AddressController>(builder: (addressController) {

        return Container(
          width: isDesktop ? 500 : context.width,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(isDesktop ? 20 : 0)),
          ),
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                Center(
                  child: Container(
                    height: 5, width: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('select_your_address'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text('saved_addresses'.tr, style: robotoRegular),

                Flexible(
                  child: addressController.addressList != null ? addressController.addressList!.isNotEmpty ? ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    shrinkWrap: true,
                    itemCount: addressController.addressList?.length,
                    itemBuilder: (context, index) {
                      final address = addressController.addressList?[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                        padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: (widget.isSender && widget.senderAddressController.text == address?.address) || (!widget.isSender && widget.receiverAddressController.text == address?.address)
                              ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(
                            color: (widget.isSender && widget.senderAddressController.text == address?.address) || (!widget.isSender && widget.receiverAddressController.text == address?.address)
                                ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Theme.of(context).disabledColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: InkWell(
                          onTap: () async {
                            Get.back();
                            if(parcelController.isSender){
                              ZoneResponseModel responseModel = await Get.find<LocationController>().getZone(address.latitude.toString(), address.longitude.toString(), false);
                              AddressModel pickupAddress = AddressModel(
                                id: address.id, addressType: address.addressType, contactPersonNumber: address.contactPersonNumber, contactPersonName: address.contactPersonName,
                                address: address.address, latitude: address.latitude, longitude: address.longitude, zoneId: responseModel.isSuccess ? responseModel.zoneIds[0] : 0,
                                zoneIds: responseModel.zoneIds, method: address.method, streetNumber: address.streetNumber, house: address.house, floor: address.floor,
                                zoneData: responseModel.zoneData,
                              );
                              parcelController.setPickupAddress(pickupAddress, true);
                              widget.senderAddressController.text = address.address ?? '';
                              widget.streetController.text = address.streetNumber ?? '';
                              widget.houseController.text = address.house ?? '';
                              widget.floorController.text = address.floor ?? '';
                              widget.nameController.text = address.contactPersonName ?? '';
                              await _splitPhoneNumber(address.contactPersonNumber??'');
                              parcelController.setCountryCode(_addressCountryCode?? _countryCode!, true);
                            }else{
                              ZoneResponseModel responseModel = await Get.find<LocationController>().getZone(address.latitude.toString(), address.longitude.toString(), false);
                              AddressModel destination = AddressModel(
                                id: address.id, addressType: address.addressType, contactPersonNumber: address.contactPersonNumber, contactPersonName: address.contactPersonName,
                                address: address.address, latitude: address.latitude, longitude: address.longitude, zoneId: responseModel.isSuccess ? responseModel.zoneIds[0] : 0,
                                zoneIds: responseModel.zoneIds, method: address.method, streetNumber: address.streetNumber, house: address.house, floor: address.floor,
                                zoneData: responseModel.zoneData,
                              );
                              parcelController.setDestinationAddress(destination);
                              widget.receiverAddressController.text = address.address ?? '';
                              widget.streetController.text = address.streetNumber ?? '';
                              widget.houseController.text = address.house ?? '';
                              widget.floorController.text = address.floor ?? '';
                            }
                          },
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(mainAxisSize: MainAxisSize.min, children: [
                              Image.asset(
                                address!.addressType == 'home' ? Images.homeIcon : address.addressType == 'office' ? Images.workIcon : Images.otherIcon,
                                color: (widget.isSender && widget.senderAddressController.text == address.address) || (!widget.isSender && widget.receiverAddressController.text == address.address)
                                    ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.6),
                                height: ResponsiveHelper.isDesktop(context) ? 25 : 20, width: ResponsiveHelper.isDesktop(context) ? 25 : 20,
                              ),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Text(
                                address.addressType!.tr,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                              ),
                            ]),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Text(
                                address.address ?? '',
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ]),
                        ),
                      );
                    },
                  ) : Center(child: Text('no_data_found'.tr)) : const Center(child: CircularProgressIndicator()),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                CustomButton(
                  buttonText: 'select_from_map'.tr,
                  icon: Icons.location_on,
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                  textColor: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: Dimensions.fontSizeDefault,
                  iconColor: Theme.of(context).primaryColor,
                  isBold: false,
                  onPressed: () {
                    Get.back();
                    if(ResponsiveHelper.isDesktop(Get.context)){
                      showGeneralDialog(context: context, pageBuilder: (_,__,___) {
                        return SizedBox(
                          height: 300, width: 300,
                          child: PickMapScreen(fromSignUp: false, canRoute: false, fromAddAddress: false, route:'', onPicked: (AddressModel address) async {

                            ZoneResponseModel responseModel = await Get.find<LocationController>().getZone(address.latitude.toString(), address.longitude.toString(), false);

                            AddressModel a = AddressModel(
                              id: address.id, addressType: address.addressType, contactPersonNumber: address.contactPersonNumber, contactPersonName: address.contactPersonName,
                              address: address.address, latitude: address.latitude, longitude: address.longitude, zoneId: responseModel.isSuccess ? responseModel.zoneIds[0] : 0,
                              zoneIds: address.zoneIds, method: address.method, streetNumber: address.streetNumber, house: address.house, floor: address.floor,
                              zoneData: responseModel.zoneData,
                            );

                            if(parcelController.isPickedUp!) {
                              parcelController.setPickupAddress(a, true);
                            }else {
                              parcelController.setDestinationAddress(a);
                            }
                          }),
                        );
                      });
                    }else{
                      Get.toNamed(RouteHelper.getPickMapRoute('parcel', false), arguments: PickMapScreen(
                        fromSignUp: false, fromAddAddress: false, canRoute: false, route: '', onPicked: (AddressModel address) async {

                        if(parcelController.isPickedUp!) {
                          ZoneResponseModel responseModel = await Get.find<LocationController>().getZone(address.latitude.toString(), address.longitude.toString(), false);
                          AddressModel pickupAddress = AddressModel(
                            id: address.id, addressType: address.addressType, contactPersonNumber: address.contactPersonNumber, contactPersonName: address.contactPersonName,
                            address: address.address, latitude: address.latitude, longitude: address.longitude, zoneId: responseModel.isSuccess ? responseModel.zoneIds[0] : 0,
                            zoneIds: responseModel.zoneIds, method: address.method, streetNumber: address.streetNumber, house: address.house, floor: address.floor,
                            zoneData: responseModel.zoneData,
                          );
                          parcelController.setPickupAddress(pickupAddress, true);
                        }else {
                          ZoneResponseModel responseModel = await Get.find<LocationController>().getZone(address.latitude.toString(), address.longitude.toString(), false);
                          AddressModel destination = AddressModel(
                            id: address.id, addressType: address.addressType, contactPersonNumber: address.contactPersonNumber, contactPersonName: address.contactPersonName,
                            address: address.address, latitude: address.latitude, longitude: address.longitude, zoneId: responseModel.isSuccess ? responseModel.zoneIds[0] : 0,
                            zoneIds: responseModel.zoneIds, method: address.method, streetNumber: address.streetNumber, house: address.house, floor: address.floor,
                            zoneData: responseModel.zoneData,
                          );
                          parcelController.setDestinationAddress(destination);
                        }
                      },
                      ));
                    }
                  }
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

              ]),
            ),

            Positioned(
              top: 0, right: 0,
              child: InkWell(
                onTap: () => Get.back(),
                child: Icon(Icons.clear, color: Theme.of(context).disabledColor, size: 20),
              ),
            ),
          ]),
        );
      });
    });
  }

  Future<void> _splitPhoneNumber(String number) async {
    try {
      PhoneNumber phoneNumber = PhoneNumber.parse(number);
      _addressCountryCode = '+${phoneNumber.countryCode}';
      widget.phoneController.text = phoneNumber.international.substring(_addressCountryCode!.length);
    } catch (e) {
      debugPrint('number can\'t parse : $e');
    }
  }
}
