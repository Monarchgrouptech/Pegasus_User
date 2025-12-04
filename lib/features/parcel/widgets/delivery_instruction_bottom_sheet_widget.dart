import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/parcel/controllers/parcel_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';

class DeliveryInstructionBottomSheetWidget extends StatefulWidget {
  const DeliveryInstructionBottomSheetWidget({super.key});

  @override
  State<DeliveryInstructionBottomSheetWidget> createState() => _DeliveryInstructionBottomSheetWidgetState();
}

class _DeliveryInstructionBottomSheetWidgetState extends State<DeliveryInstructionBottomSheetWidget> {

  @override
  void initState() {
    Get.find<ParcelController>().getParcelInstruction();
    Get.find<ParcelController>().setCustomNoteController(Get.find<ParcelController>().customNote ?? '', notify: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController) {
      return Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8, minHeight: 250, maxWidth: 500),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge),
            topRight: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: parcelController.parcelInstructionList != null ? SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

            Align(
              alignment: Alignment.center,
              child: Container(
                height: 5, width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: (){
                  Get.back();
                },
                child: Icon(Icons.close, color: Theme.of(context).disabledColor, size: 20),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            parcelController.parcelInstructionList!.isNotEmpty ? Text("choose_delivery_instructions".tr, style: robotoSemiBold) : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            parcelController.parcelInstructionList!.isNotEmpty ? ListView.builder(
              itemCount: parcelController.parcelInstructionList!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                  child: InkWell(
                    onTap: () {
                      parcelController.setInstructionSelectedIndex(index);
                    },
                    child: SelectedCardWidget(title: parcelController.parcelInstructionList![index].instruction!, isSelect: parcelController.instructionSelectedIndex == index),
                  ),
                );
              },
            ) : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Row(
              children: [
                parcelController.parcelInstructionList!.isNotEmpty ? Text("or".tr, style: robotoSemiBold) : const SizedBox(),
                SizedBox(width: parcelController.parcelInstructionList!.isNotEmpty ? Dimensions.paddingSizeExtraSmall : 0),

                Text("add_custom_note".tr, style: robotoSemiBold),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            CustomTextField(
              titleText: "type_here_your_note".tr,
              showLabelText: false,
              maxLines: 3,
              controller: parcelController.customNoteController,
              onChanged: (value) {
                parcelController.setCustomNoteController(value);
              }
            ),
            const SizedBox(height: 50),

            CustomButton(
              onPressed: (parcelController.instructionSelectedIndex != -1 || parcelController.customNoteController.text.isNotEmpty) ? () {

                parcelController.setSelectedIndex(null);
                parcelController.setCustomNote(null);
                Get.back();

              } : null,
              buttonText: 'apply'.tr,
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          ]),
        ) : const Center(child: CircularProgressIndicator()),

      );
    });
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
