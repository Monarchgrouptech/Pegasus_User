import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/util/dimensions.dart';

class ItemBottomSheetShimmer extends StatelessWidget {
  const ItemBottomSheetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * 0.5,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: Shimmer(
                child: Container(height: 120, width: 120, decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor)),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeLarge),

            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: Shimmer(
                  child: Container(height: 15, width: 150, decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor)),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: Shimmer(
                  child: Container(height: 10, width: 120, decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor)),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: Shimmer(
                  child: Container(height: 12, width: 150, decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor)),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: Shimmer(
                  child: Container(height: 15, width: 140, decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor)),
                ),
              ),
            ]),

          ]),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: Shimmer(
              child: Container(height: 15, width: 100, decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor)),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: Shimmer(
              child: Container(height: 10, width: context.width, decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor)),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: Shimmer(
              child: Container(height: 12, width: context.width, decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor)),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: Shimmer(
              child: Container(height: 10, width: 170, decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor)),
            ),
          ),

        ],
      ),
    );
  }
}
