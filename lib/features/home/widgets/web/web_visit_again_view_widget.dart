import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/card_design/visit_again_card.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/home/widgets/web/widgets/arrow_icon_button.dart';

class WebVisitAgainView extends StatefulWidget {
  final bool fromFood;
  const WebVisitAgainView({super.key, required this.fromFood});

  @override
  State<WebVisitAgainView> createState() => _WebVisitAgainViewState();
}

class _WebVisitAgainViewState extends State<WebVisitAgainView> {
  final CarouselSliderController carouselController = CarouselSliderController();

  ScrollController scrollController = ScrollController();
  bool showBackButton = false;
  bool showForwardButton = false;
  bool isFirstTime = true;

  @override
  void initState() {
    scrollController.addListener(_checkScrollPosition);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _checkScrollPosition() {
    setState(() {
      if (scrollController.position.pixels <= 0) {
        showBackButton = false;
      } else {
        showBackButton = true;
      }

      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        showForwardButton = false;
      } else {
        showForwardButton = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      List<Store>? stores = storeController.visitAgainStoreList;

      return stores != null ? stores.isNotEmpty ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            widget.fromFood ? '${"wanna_try_again".tr}!' : '${"visit_again".tr}!',
            style: robotoBold,
          ),

          Text(
            'get_your_recent_purchase_from_the_shop_you_recently_ordered'.tr,
            style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Stack(
            children: [
              Container(
                height: 200, width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                ),
                child: ListView.builder(
                  itemCount: stores.length,
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeLarge),
                  shrinkWrap: true,
                    itemBuilder: (context, index) {
                  return Container(
                    height: 150, width: 250,
                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeSmall),
                    child: VisitAgainCard(store: stores[index], fromFood: widget.fromFood),
                  );
                }, scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics()
              )),

              if(showBackButton)
                Positioned(
                  top: 70, left: Get.find<LocalizationController>().isLtr ? 45 : 0,
                  child: ArrowIconButton(
                    isRight: false,
                    onTap: () => scrollController.animateTo(scrollController.offset - (Dimensions.webMaxWidth / 3),
                        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                  ),
                ),

              if(showForwardButton)
                Positioned(
                  top: 70, right: Get.find<LocalizationController>().isLtr ? 0 : 45,
                  child: ArrowIconButton(
                    onTap: () => scrollController.animateTo(scrollController.offset + (Dimensions.webMaxWidth / 3),
                        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                  ),
                ),
            ],
          ),
        ],
      ) : const SizedBox() : WebVisitAgainShimmerView(storeController: storeController);
    });
  }
}

class WebVisitAgainShimmerView extends StatelessWidget {
  final StoreController storeController;
  const WebVisitAgainShimmerView({super.key, required this.storeController});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
        child: Stack(clipBehavior: Clip.none, children: [

          Container(
            height: 150, width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
            child: Column(children: [

              Container(
                height: 20, width: 100,
                color: Colors.grey[300],
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                height: 20, width: 200,
                color: Colors.grey[300],
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              CarouselSlider.builder(
                itemCount: 5,
                options: CarouselOptions(
                  aspectRatio: 6,
                  enlargeCenterPage: true,
                  disableCenter: true,
                  viewportFraction: .25,
                  enlargeFactor: 0.2,
                  onPageChanged: (index, reason) {},
                ),
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Container(
                    height: 150, width: double.infinity,
                    margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                    ),
                  );
                },
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}