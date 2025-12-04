import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParcelCancelConfirmBottomSheet extends StatelessWidget {
  final bool isBeforePickup;
  final int? orderId;
  final String? contactNumber;
  final String? comment;
  final bool chargePayerSender;
  final double orderAmount;
  final double dmTips;
  const ParcelCancelConfirmBottomSheet({super.key, required this.isBeforePickup, this.orderId, this.contactNumber, this.comment, required this.chargePayerSender, required this.orderAmount, required this.dmTips});

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return GetBuilder<OrderController>(builder: (orderController) {
      return Container(
        width: isDesktop ? 500 : context.width,
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(isDesktop ? 20 : 0)),
        ),
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge),
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              Container(
                height: 5, width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

              Text(
                'return_fare_description'.tr, textAlign: TextAlign.center,
                style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

              Get.find<SplashController>().configModel?.parcelCancellationBasicSetup?.returnFeeStatus == '1' ? Text(
                PriceConverter.convertPrice(chargePayerSender ? getReturnFee(orderAmount - dmTips) : (orderAmount + getReturnFee(orderAmount - dmTips))),
                textAlign: TextAlign.center,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge),
              ) : SizedBox(),

              Get.find<SplashController>().configModel?.parcelCancellationBasicSetup?.returnFeeStatus == '1' ? Text(
                chargePayerSender ? 'return_fare'.tr : '${'parcel_delivery_charge'.tr} + ${'return_fare'.tr}',
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeLarge),
              ) : SizedBox(),
              SizedBox(height: Get.find<SplashController>().configModel?.parcelCancellationBasicSetup?.returnFeeStatus == '1' ?  Dimensions.paddingSizeExtremeLarge : 0),

              CustomButton(
                buttonText: 'yes_cancel'.tr,
                isLoading: orderController.isLoading,
                onPressed: () {
                  orderController.cancelOrder(orderID: orderId!, reasons: orderController.selectedParcelCancelReason, comment: comment, isParcel: true).then((success) {
                    if(success){
                      orderController.trackOrder(orderId.toString(), null, true, contactNumber: contactNumber);
                    }
                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Center(
                    child: Text(
                      'continue_delivery'.tr,
                      style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ),

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
  }

  double getReturnFee(double orderAmount) {
    double returnFeePercent = double.tryParse(Get.find<SplashController>().configModel!.parcelCancellationBasicSetup!.returnFee.toString()) ?? 0.0;
    double returnFee = orderAmount * (returnFeePercent / 100);
    return returnFee;
  }

}
