import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/features/order/widgets/parcel_cancelation/custom_check_box_widget.dart';
import 'package:sixam_mart/features/order/widgets/parcel_cancelation/parcel_cancel_confirm_bottom_sheet.dart';
import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class CancellationReasonBottomSheet extends StatefulWidget {
  final bool isBeforePickup;
  final int? orderId;
  final String? contactNumber;
  final bool chargePayerSender;
  final double orderAmount;
  final double dmTips;
  const CancellationReasonBottomSheet({super.key, required this.isBeforePickup, this.orderId, this.contactNumber, required this.chargePayerSender, required this.orderAmount, required this.dmTips});

  @override
  State<CancellationReasonBottomSheet> createState() => _CancellationReasonBottomSheetState();
}

class _CancellationReasonBottomSheetState extends State<CancellationReasonBottomSheet> {

  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<OrderController>().clearSelectedParcelCancelReason();
    Get.find<ParcelController>().getParcelCancellationReasons(isBeforePickup: widget.isBeforePickup);
  }

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return GetBuilder<ParcelController>(builder: (parcelController) {
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

                parcelController.parcelCancellationReasons != null && parcelController.parcelCancellationReasons!.isNotEmpty ? Text('please_select_cancellation_reason'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)) : SizedBox(),

                parcelController.parcelCancellationReasons != null ? parcelController.parcelCancellationReasons!.isNotEmpty ? Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    shrinkWrap: true,
                    itemCount: parcelController.parcelCancellationReasons?.length,
                    itemBuilder: (context, index) {
                      final reason = parcelController.parcelCancellationReasons?[index];
                      return CustomCheckBoxWidget(
                        title: reason?.reason ?? '',
                        value: orderController.isReasonSelected(reason?.reason ?? ''),
                        onClick: (bool? selected) {
                          orderController.toggleParcelCancelReason(reason!.reason!, selected ?? false);
                        },
                      );
                    },
                  ),
                ) : SizedBox() : const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault), child: CircularProgressIndicator())),

                Text(
                  'comments'.tr,
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                CustomTextField(
                  controller: commentController,
                  titleText: 'type_here_your_cancel_reason'.tr,
                  showLabelText: false,
                  maxLines: 2,
                  inputType: TextInputType.multiline,
                  inputAction: TextInputAction.done,
                  capitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                CustomButton(
                  isLoading: orderController.isLoading,
                  buttonText: widget.isBeforePickup ? 'submit'.tr : 'next'.tr,
                  onPressed: () {
                    if(widget.isBeforePickup){
                      if((orderController.selectedParcelCancelReason != null && orderController.selectedParcelCancelReason!.isNotEmpty) || commentController.text.isNotEmpty) {

                        orderController.cancelOrder(orderID: widget.orderId!, reasons: orderController.selectedParcelCancelReason, comment: commentController.text.trim(), isParcel: true).then((success) {
                          if(success){
                            orderController.trackOrder(widget.orderId.toString(), null, true, contactNumber: widget.contactNumber);
                          }
                        });

                      }else{
                        if(orderController.selectedParcelCancelReason != null && orderController.selectedParcelCancelReason!.isNotEmpty){
                          showCustomSnackBar('you_did_not_select_any_reason'.tr);
                        }else if(commentController.text.isNotEmpty){
                          showCustomSnackBar('you_did_not_write_any_comment'.tr);
                        }
                      }
                    }else{
                      if((orderController.selectedParcelCancelReason != null && orderController.selectedParcelCancelReason!.isNotEmpty) || commentController.text.isNotEmpty) {
                        if(isDesktop){
                          Get.back();
                          Get.dialog(
                            Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                              insetPadding: const EdgeInsets.all(20),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: ParcelCancelConfirmBottomSheet(
                                isBeforePickup: widget.isBeforePickup,
                                orderId: widget.orderId,
                                contactNumber: widget.contactNumber,
                                comment: commentController.text.trim(),
                                chargePayerSender: widget.chargePayerSender,
                                orderAmount: widget.orderAmount,
                                dmTips: widget.dmTips,
                              ),
                            ),
                          );
                        }else{
                          Get.back();
                          showCustomBottomSheet(child: ParcelCancelConfirmBottomSheet(
                            isBeforePickup: widget.isBeforePickup,
                            orderId: widget.orderId,
                            contactNumber: widget.contactNumber,
                            comment: commentController.text.trim(),
                            chargePayerSender: widget.chargePayerSender,
                            orderAmount: widget.orderAmount,
                            dmTips: widget.dmTips,
                          ));
                        }
                      }else{
                        if(orderController.selectedParcelCancelReason != null && orderController.selectedParcelCancelReason!.isNotEmpty){
                          showCustomSnackBar('you_did_not_select_any_reason'.tr);
                        }else if(commentController.text.isNotEmpty){
                          showCustomSnackBar('you_did_not_write_any_comment'.tr);
                        }
                      }
                    }
                  }
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
    });
  }
}
