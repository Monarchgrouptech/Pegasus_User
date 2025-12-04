import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/cart/controllers/cart_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class ExtraPackagingWidget extends StatelessWidget {
  final CartController cartController;
  const ExtraPackagingWidget({super.key, required this.cartController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return storeController.store?.extraPackagingStatus ?? false ? Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.grey.shade50, blurRadius: 2, spreadRadius: 1)],
        ),
        child: Row(children: [

          Checkbox(
            activeColor: Theme.of(context).primaryColor,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            value: cartController.needExtraPackage,
            onChanged: (bool? isChecked) {
              cartController.toggleExtraPackage();
            },
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('need_extra_packaging'.tr, style: robotoMedium),
              Text(
                '${'additional'.tr} ${PriceConverter.convertPrice(storeController.store?.extraPackagingAmount)} '
                    '${'change_will_be_added_for_extra_packaging'.tr}',
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
              ),
            ]),
          ),

        ]),
      ) : const SizedBox();
    });
  }
}
