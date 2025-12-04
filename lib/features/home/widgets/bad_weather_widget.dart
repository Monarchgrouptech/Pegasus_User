import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/checkout/controllers/checkout_controller.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/module_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class BadWeatherWidget extends StatefulWidget {
  final bool inParcel;
  const BadWeatherWidget({super.key, this.inParcel = false});

  @override
  State<BadWeatherWidget> createState() => _BadWeatherWidgetState();
}

class _BadWeatherWidgetState extends State<BadWeatherWidget> {
  @override
  void initState() {
    super.initState();

    Get.find<CheckoutController>().getSurgePrice(
      zoneId:AddressHelper.getUserAddressFromSharedPref()!.zoneId.toString(), moduleId: ModuleHelper.getModule()?.id.toString() ?? (ModuleHelper.getCacheModule()?.id.toString() ?? '0'),
      dateTime: DateConverter.dateToDateTime(DateTime.now()), guestId: AuthHelper.getGuestId(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(builder: (checkoutController) {
      return checkoutController.surgePrice?.customerNoteStatus == 1 ? Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
        margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 : widget.inParcel ? 0 : Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
        child: Row(children: [

          Image.asset(Images.weather, height: 50, width: 50),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: Text(
              checkoutController.surgePrice?.customerNote ?? '',
              style: robotoRegular,
            ),
          ),

        ]),
      ) : const SizedBox();
    });
  }
}
