import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/features/search/widgets/custom_check_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterWidget extends StatelessWidget {
  final double? maxValue;
  const FilterWidget({super.key, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    bool isFood = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.food;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        width: ResponsiveHelper.isDesktop(context) ? 400 : 600,
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: GetBuilder<StoreController>(builder: (storeController) {

          double lowerValue = storeController.lowerValue.clamp(0, maxValue!);
          double upperValue = storeController.upperValue.clamp(0, maxValue!);

          return SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('filter_by'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close),
                ),
              ]),
              const SizedBox(height: 20),

              isFood ? CustomCheckBoxWidget(
                title: 'currently_available_items'.tr,
                value: storeController.isAvailableItems,
                onClick: () {
                  storeController.toggleAvailableItems();
                },
              ) : const SizedBox.shrink(),

              CustomCheckBoxWidget(
                title: 'discounted_items'.tr,
                value: storeController.isDiscountedItems,
                onClick: () {
                  storeController.toggleDiscountedItems();
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('price'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                RangeSlider(
                  values: RangeValues(lowerValue, upperValue),
                  min: 0,
                  max: maxValue!.toDouble(),
                  divisions: maxValue!.toInt(),
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  labels: RangeLabels(lowerValue.toString(), upperValue.toString()),
                  onChanged: (RangeValues rangeValues) {
                    storeController.setLowerAndUpperValue(rangeValues.start, rangeValues.end);
                  },
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
              ]),

              Align(
                alignment: Alignment.center,
                child: Text('ratings'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
              ),

              Container(
                height: 30, alignment: Alignment.center,
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => storeController.setRating(index + 1),
                      child: Icon(
                        (storeController.rating < (index + 1)) ? Icons.star_border_rounded : Icons.star_rounded,
                        size: 22,
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 50),

              Row(children: [
                Expanded(
                  child: CustomButton(
                    buttonText: 'clear_filter'.tr,
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                    textColor: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                    onPressed: () {
                      storeController.resetFilter();
                    },
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: CustomButton(
                    buttonText: 'filter'.tr,
                    onPressed: () {
                      storeController.getStoreItemList(storeController.store!.id, 1, storeController.type, true);
                      Get.back();
                    },
                  ),
                ),
              ]),

            ]),
          );
        }),
      ),
    );
  }
}
