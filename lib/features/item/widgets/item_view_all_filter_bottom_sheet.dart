import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/search/widgets/custom_check_box_widget.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class ItemViewAllFilterBottomSheet extends StatelessWidget {
  final double? maxValue;
  final bool isPopular;
  final bool isSpecial;
  final bool fromDialog;
  const ItemViewAllFilterBottomSheet({super.key, this.maxValue, required this.isPopular, required this.isSpecial, this.fromDialog = false});

  @override
  Widget build(BuildContext context) {

    bool isFood = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.food;

    return GetBuilder<ItemController>(builder: (itemController) {

      double lowerValue = itemController.selectedMinPrice.clamp(0, maxValue!);
      double upperValue = itemController.selectedMaxPrice.clamp(0, maxValue!);

      return Container(
        height: fromDialog ? 600 : null,
        width: fromDialog ? 475 : context.width > 700 ? 700 : context.width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(Dimensions.radiusExtraLarge),
            topRight: const Radius.circular(Dimensions.radiusExtraLarge),
            bottomLeft: Radius.circular(fromDialog ? Dimensions.radiusExtraLarge : 0),
            bottomRight: Radius.circular(fromDialog ? Dimensions.radiusExtraLarge : 0),
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: fromDialog ? 0 : Dimensions.paddingSizeLarge),

          ResponsiveHelper.isDesktop(context) ? Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.clear),
            ),
          ) : Align(
            alignment: Alignment.center,
            child: Container(
              height: 5, width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Align(
            alignment: Alignment.center,
            child: Text('filter_data'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          ),

          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,  mainAxisSize: MainAxisSize.min, children: [

                  Text('price'.tr, style: robotoBold),

                  RangeSlider(
                    values: RangeValues(lowerValue, upperValue),
                    min: 0,
                    max: maxValue!.toDouble(),
                    divisions: maxValue!.toInt(),
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    labels: RangeLabels(lowerValue.toString(), upperValue.toString()),
                    onChanged: (RangeValues values) {
                      itemController.setMinAndMaxPrice(values.start, values.end);
                    },
                  ),
                  const Divider(),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text('status'.tr, style: robotoBold),

                  SizedBox(
                    height: 50,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [

                        if (isFood) ...[
                          CustomCheckBoxWidget(
                            title: 'available'.tr,
                            value: itemController.isAvailableItems,
                            onClick: () {
                              itemController.toggleAvailableItems();
                            },
                          ),
                          const SizedBox(width: Dimensions.paddingSizeLarge),

                          CustomCheckBoxWidget(
                            title: 'unavailable'.tr,
                            value: itemController.isUnAvailableItems,
                            onClick: () {
                              itemController.toggleUnavailableItems();
                            },
                          ),
                          const SizedBox(width: Dimensions.paddingSizeLarge),
                        ],

                        CustomCheckBoxWidget(
                          title: 'top_rated'.tr,
                          value: itemController.isTopRated,
                          onClick: () {
                            itemController.toggleTopRated();
                          },
                        ),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        CustomCheckBoxWidget(
                          title: 'most_loved'.tr,
                          value: itemController.isMostLoved,
                          onClick: () {
                            itemController.toggleMostLoved();
                          },
                        ),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        CustomCheckBoxWidget(
                          title: 'popular'.tr,
                          value: itemController.isPopular,
                          onClick: () {
                            itemController.togglePopular();
                          },
                        ),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        CustomCheckBoxWidget(
                          title: 'latest'.tr,
                          value: itemController.isLatest,
                          onClick: () {
                            itemController.toggleLatest();
                          },
                        ),

                      ]),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text('ratings'.tr, style: robotoBold),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  ...List.generate(5, (index) {
                    int rating = 5 - index;
                    return InkWell(
                      onTap: () => itemController.setSelectedRating(rating),
                      child: Padding(
                        padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall + 2, bottom: Dimensions.paddingSizeSmall + 2, right: Dimensions.paddingSizeExtraSmall),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                          Text(
                            '${rating == 5 ? '5' : '$rating +'} ${'rating'.tr}',
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: itemController.rating == rating ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).disabledColor),
                          ),

                          Icon(
                            itemController.rating == rating ? Icons.check_circle : Icons.circle_outlined,
                            size: 22, color: itemController.rating == rating ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.5),
                          ),

                        ]),
                      ),
                    );

                  }),
                  const Divider(),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text('categories'.tr, style: robotoBold),
                  if (itemController.categoryList == null)
                    Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                  else if (itemController.categoryList!.isEmpty)
                    Center(child: Text('no_category_found'.tr))
                  else
                  ...itemController.categoryList!.map((cat) {
                    return CheckboxListTile(
                      title: Text(cat.name ?? '', style: robotoRegular),
                      contentPadding: EdgeInsets.zero,
                      side: BorderSide(
                        color: itemController.selectedCategoryIds.contains(cat.id) ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.5),
                      ),
                      value: itemController.selectedCategoryIds.contains(cat.id),
                      onChanged: (_) => itemController.toggleCategory(cat.id),
                    );
                  }),

                ]),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge,
              vertical: Dimensions.paddingSizeDefault,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(fromDialog ? Dimensions.radiusExtraLarge : 0),
                bottomRight: Radius.circular(fromDialog ? Dimensions.radiusExtraLarge : 0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonText: 'reset'.tr,
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                    textColor: Theme.of(context).textTheme.bodyLarge!.color,
                    onPressed: () {
                      itemController.resetFilters(isPopular: isPopular, isSpecial: isSpecial);
                      Navigator.pop(context);
                    }
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: CustomButton(
                    buttonText: 'filter'.tr,
                    onPressed: () {
                      itemController.applyFilters(isPopular: isPopular, isSpecial: isSpecial);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ]),
      );
    });
  }
}

