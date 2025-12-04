import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
class ExtraDiscountViewWidget extends StatelessWidget {
  final double extraDiscount;
  const ExtraDiscountViewWidget({super.key, required this.extraDiscount});

  @override
  Widget build(BuildContext context) {
    return (extraDiscount > 0) ? Container(
      color: const Color(0xFFFFF6CA),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomAssetImageWidget(Images.taxiEnjoyIcon, height: 20, width: 20),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(text: 'you_got'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)),
              const TextSpan(text: ' '),

              TextSpan(text: PriceConverter.convertPrice(extraDiscount), style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)),
              const TextSpan(text: ' '),

              TextSpan(
                text: 'additional_discount'.tr,
                style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
            ]),
          ),
        ],
      ),
    ) : const SizedBox();
  }
}
