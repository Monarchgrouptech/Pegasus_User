import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';

class CancellationDialogueWidget extends StatefulWidget {
  final int? orderId;
  final String? contactNumber;
  const CancellationDialogueWidget({super.key, required this.orderId, this.contactNumber});

  @override
  State<CancellationDialogueWidget> createState() => _CancellationDialogueWidgetState();
}

class _CancellationDialogueWidgetState extends State<CancellationDialogueWidget> {

  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<OrderController>().getOrderCancelReasons();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GetBuilder<OrderController>(builder: (orderController) {
        return SizedBox(
          width: 500,
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Container(
              width: 500,
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
              ),
              child: Column(children: [
                Text('select_cancellation_reasons'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              ]),
            ),

            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

                  orderController.orderCancelReasons != null ? orderController.orderCancelReasons!.isNotEmpty ? Flexible(
                    child: ListView.builder(
                      itemCount: orderController.orderCancelReasons!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: (){
                            orderController.setOrderCancelReason(orderController.orderCancelReasons![index].reason);
                          },
                          title: Row(
                            children: [
                              Icon(orderController.orderCancelReasons![index].reason == orderController.cancelReason ? Icons.radio_button_checked : Icons.radio_button_off, color: Theme.of(context).primaryColor, size: 18),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Flexible(child: Text(orderController.orderCancelReasons![index].reason!, style: robotoRegular, maxLines: 3, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        );
                      },
                    ),
                  ) : SizedBox() : const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault), child: CircularProgressIndicator())),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(
                    'comments'.tr,
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
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

                ]),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: !orderController.isLoading ? Row(children: [
                Expanded(child: CustomButton(
                  buttonText: 'cancel'.tr, color: Theme.of(context).disabledColor, radius: 50,
                  onPressed: () => Get.back(),
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: CustomButton(
                  buttonText: 'submit'.tr,  radius: 50,
                  onPressed: () {
                    if((orderController.cancelReason != '' && orderController.cancelReason != null) || commentController.text.isNotEmpty){

                      orderController.cancelOrder(orderID: widget.orderId!, reason: orderController.cancelReason, isParcel: false, comment: commentController.text.trim()).then((success) {
                        if(success){
                          orderController.trackOrder(widget.orderId.toString(), null, true, contactNumber: widget.contactNumber);
                        }
                      });

                    }else{
                      if(orderController.cancelReason != '' && orderController.cancelReason != null){
                        showCustomSnackBar('you_did_not_select_any_reason'.tr);
                      }else if(commentController.text.isNotEmpty){
                        showCustomSnackBar('you_did_not_write_any_comment'.tr);
                      }
                    }
                  },
                )),
              ]) : const Center(child: CircularProgressIndicator()),
            ),
          ]),
        );
      }),
    );
  }
}
