import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';

class RefundRequestScreen extends StatefulWidget {
  final String? orderId;
  const RefundRequestScreen({super.key, required this.orderId});

  @override
  State<RefundRequestScreen> createState() => _RefundRequestScreenState();
}

class _RefundRequestScreenState extends State<RefundRequestScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<OrderController>().pickRefundImage(true);
    Get.find<OrderController>().getRefundReasons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'refund_request'.tr),
      body: SafeArea(
        child: GetBuilder<OrderController>(builder: (orderController) {
          return Center(
            child: orderController.refundReasons != null ? Container(
              width: context.width > 700 ? 700 : context.width,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              alignment: Alignment.center,
              child: Column(children: [

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text('select_refund_reason'.tr, style: robotoBold),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          orderController.refundReasons!.isNotEmpty ? ListView.builder(
                            itemCount: orderController.refundReasons?.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                                child: InkWell(
                                  onTap: () {
                                    orderController.selectReason(index);
                                  },
                                  child: SelectedCardWidget(title: orderController.refundReasons?[index] ?? '', isSelect: orderController.selectedReasonIndex == index),
                                ),
                              );
                            },
                          ) : Center(child: Text('no_data_found'.tr)),
                          SizedBox(height: Dimensions.paddingSizeLarge),

                          Text('comments'.tr, style: robotoBold),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          CustomTextField(
                            controller: _noteController,
                            titleText: 'type_here_your_refund_reason'.tr,
                            showLabelText: false,
                            maxLines: 3,
                            inputType: TextInputType.multiline,
                            inputAction: TextInputAction.newline,
                            capitalization: TextCapitalization.sentences,
                          ),

                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Container(
                        width: context.width,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text('add_image'.tr, style: robotoBold),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Center(
                            child: SizedBox(
                              width: context.width * 0.5,
                              child: DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
                                  strokeWidth: 1,
                                  strokeCap: StrokeCap.butt,
                                  dashPattern: const [8, 5],
                                  padding: const EdgeInsets.all(0),
                                  radius: const Radius.circular(Dimensions.radiusDefault),
                                ),
                                child: Stack(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    child: orderController.refundImage != null ? GetPlatform.isWeb ? Image.network(
                                      orderController.refundImage!.path, width: context.width, height: 120, fit: BoxFit.cover,
                                    ) : Image.file(
                                      File(orderController.refundImage!.path), width: context.width, height: 120, fit: BoxFit.cover,
                                    ) : InkWell(
                                      onTap: () => orderController.pickRefundImage(false),
                                      child: Container(
                                        width: context.width, height: 120, alignment: Alignment.center,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                          Icon(CupertinoIcons.camera_fill, size: 34, color: Theme.of(context).disabledColor.withValues(alpha: 0.3)),
                                          const SizedBox(height: Dimensions.paddingSizeSmall),

                                          Text('upload_image'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor.withValues(alpha: 0.6))),
                                        ]),
                                      ),
                                    ),
                                  ),
                                  orderController.refundImage != null ? Positioned(
                                    bottom: 0, right: 0, top: 0, left: 0,
                                    child: InkWell(
                                      onTap: () => orderController.pickRefundImage(false),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.all(25),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 2, color: Theme.of(context).disabledColor),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.camera_alt, color: Theme.of(context).disabledColor),
                                        ),
                                      ),
                                    ),
                                  ) : const SizedBox(),
                                ]),
                              ),
                            ),
                          ),

                        ]),
                      ),

                    ]),
                  ),
                ),

                CustomButton(
                  buttonText: 'submit_refund_request'.tr,
                  isLoading: orderController.isLoading,
                  onPressed: () => orderController.submitRefundRequest(_noteController.text.trim(), widget.orderId),
                ),

              ]),
            ) : const Center(child: CircularProgressIndicator()),
          );
        }),
      ),
    );
  }
}

class SelectedCardWidget extends StatelessWidget {
  final bool isSelect;
  final String title;
  const SelectedCardWidget({super.key, required this.isSelect, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(children: [

      Expanded(child: Text(title, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor), maxLines: 2, overflow: TextOverflow.ellipsis)),
      const SizedBox(width: Dimensions.paddingSizeLarge),

      Icon(isSelect ? Icons.check_box : Icons.check_box_outline_blank, color: isSelect ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, size: 25, ),

    ]);
  }
}
