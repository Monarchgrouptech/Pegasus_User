import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class ItemViewAllSortBottomSheet extends StatelessWidget {
  final bool isPopular;
  final bool isSpecial;
  final bool fromDialog;
  const ItemViewAllSortBottomSheet({super.key, required this.isPopular, required this.isSpecial, this.fromDialog = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(builder: (itemController) {
      return Container(
        height: fromDialog ? 400 : null,
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
        child: Column(mainAxisSize: MainAxisSize.min, children: [
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
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Text('sort_by'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

          Padding(
            padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeDefault),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              ...itemController.sortOptions.map((option) {
                return Padding(
                  padding: EdgeInsets.only(bottom: fromDialog ? Dimensions.paddingSizeSmall : 0),
                  child: FilterButton(
                    title: option.tr,
                    isSelected: itemController.selectedSortOption == option,
                    onTap: () {
                      itemController.setSelectedSortOption(option);
                    },
                  ),
                );
              }),

            ]),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeLarge),
            child: Row(children: [

              Expanded(
                child: CustomButton(
                  buttonText: 'reset'.tr,
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                  textColor: Theme.of(context).textTheme.bodyLarge!.color,
                  onPressed: () {
                    itemController.resetFilters(isPopular: isPopular, isSpecial: isSpecial);
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: CustomButton(
                  buttonText: 'sort_by'.tr,
                  onPressed: () {
                    itemController.applyFilters(isPopular: isPopular, isSpecial: isSpecial);
                    Navigator.pop(context);
                  },
                ),
              ),

            ]),
          ),

        ]),
      );
    });
  }
}

class FilterButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function onTap;
  const FilterButton({super.key, required this.title, this.isSelected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: robotoRegular),

        RadioGroup(
          groupValue: true,
          onChanged: (bool? value) {
            onTap();
          },
          child: Radio(
            value: isSelected,
            activeColor: Theme.of(context).primaryColor,
            fillColor: WidgetStateProperty.all(isSelected ? Theme.of(context).primaryColor :Theme.of(context).disabledColor),
          ),
        ),

      ]),
    );
  }
}