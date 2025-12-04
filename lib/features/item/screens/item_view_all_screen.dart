import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/controllers/theme_controller.dart';
import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/common/widgets/add_favourite_view.dart';
import 'package:sixam_mart/common/widgets/cart_widget.dart';
import 'package:sixam_mart/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart/common/widgets/custom_card.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/hover/on_hover.dart';
import 'package:sixam_mart/features/item/widgets/item_view_all_filter_bottom_sheet.dart';
import 'package:sixam_mart/features/item/widgets/item_view_all_sort_bottom_sheet.dart';
import 'package:sixam_mart/features/search/widgets/search_field_widget.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/cart_count_view.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/discount_tag.dart';
import 'package:sixam_mart/common/widgets/not_available_widget.dart';
import 'package:sixam_mart/common/widgets/organic_tag.dart';

class ItemViewAllScreen extends StatefulWidget {
  final bool isPopular;
  final bool isSpecial;
  const ItemViewAllScreen({super.key, this.isPopular = false, this.isSpecial = true});

  @override
  State<ItemViewAllScreen> createState() => _ItemViewAllScreenState();
}

class _ItemViewAllScreenState extends State<ItemViewAllScreen> {
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ItemController itemController = Get.find<ItemController>();
    itemController.setOffset(1);
    itemController.clearFilters(isPopular: widget.isPopular, isSpecial: widget.isSpecial);
    itemController.clearSearch(withUpdate: false);

    _scrollController.addListener(() {
      final itemController = Get.find<ItemController>();
      List<Item?>? items;

      if (widget.isPopular) {
        items = itemController.popularItemList;
      } else if (widget.isSpecial) {
        items = itemController.discountedItemList;
      } else {
        items = itemController.reviewedItemList;
      }

      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 && items != null && !itemController.isLoading) {

        int pageSize = (itemController.pageSize! / 10).ceil();
        if (itemController.offset < pageSize) {
          itemController.setOffset(itemController.offset + 1);
          debugPrint('end of the page, offset: ${itemController.offset}');

          itemController.showBottomLoader();

          if (widget.isPopular) {
            itemController.getPopularItemList(notify: false, dataSource: DataSourceEnum.client, offset: itemController.offset.toString());
          } else if (widget.isSpecial) {
            itemController.getDiscountedItemList(notify: false, dataSource: DataSourceEnum.client, offset: itemController.offset.toString());
          } else {
            itemController.getReviewedItemList(notify: false, dataSource: DataSourceEnum.client, offset: itemController.offset.toString());
          }
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    bool isShop = Get.find<SplashController>().module != null && Get.find<SplashController>().module!.moduleType.toString() == AppConstants.ecommerce;

    return GetBuilder<ItemController>(builder: (itemController) {

      List<Item?>? items;
      if(widget.isPopular){
        items = itemController.popularItemList;
      }else if(widget.isSpecial){
        items = itemController.discountedItemList;
      }else{
        items = itemController.reviewedItemList;
      }

      return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          Get.find<ItemController>().resetFilters(isPopular: widget.isPopular, isSpecial: widget.isSpecial);
          Get.find<ItemController>().clearSearch();
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(children: [
        
              Container(
                width: Dimensions.webMaxWidth,
                decoration: BoxDecoration(
                  color: Get.find<ThemeController>().darkTheme ? Colors.black12 : Theme.of(context).cardColor,
                  boxShadow: Get.find<ThemeController>().darkTheme ? null : [BoxShadow(color: Theme.of(context).disabledColor.withValues(alpha: 0.2), blurRadius: 3, offset: const Offset(0, 5))]
                ),
                child: Row(children: [
        
                  IconButton(
                    onPressed: (){
                      Get.find<ItemController>().resetFilters(isPopular: widget.isPopular, isSpecial: widget.isSpecial);
                      Get.find<ItemController>().clearSearch();
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
        
                  Expanded(child: Container(
                    margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall + 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: SearchFieldWidget(
                      controller: itemController.searchController,
                      isFocused: false,
                      radius: 50,
                      hint: 'search_your_desired_item'.tr,
                      prefixIcon: CupertinoIcons.search,
                      suffixIcon: itemController.isSearching ? CupertinoIcons.clear_thick : null,
                      iconPressed: () {
                        if (!itemController.isSearching) {
                          if (itemController.searchController.text.trim().isNotEmpty) {
                            if (widget.isPopular) {
                              itemController.getPopularItemList(notify: true, offset: '1');
                            } else if (widget.isSpecial) {
                              itemController.getDiscountedItemList(notify: true, offset: '1');
                            } else {
                              itemController.getReviewedItemList(notify: true, offset: '1');
                            }
                          } else {
                            showCustomSnackBar('write_item_name_for_search'.tr);
                          }
                        } else {
                          itemController.clearSearch();
                          if (widget.isPopular) {
                            itemController.getPopularItemList(notify: true, offset: '1');
                          } else if (widget.isSpecial) {
                            itemController.getDiscountedItemList(notify: true, offset: '1');
                          } else {
                            itemController.getReviewedItemList(notify: true, offset: '1');
                          }
                        }
                      },
                      onSubmit: (String text) {
                        if (itemController.searchController.text.trim().isNotEmpty) {
                          if (widget.isPopular) {
                            itemController.getPopularItemList(notify: true, offset: '1');
                          } else if (widget.isSpecial) {
                            itemController.getDiscountedItemList(notify: true, offset: '1');
                          } else {
                            itemController.getReviewedItemList(notify: true, offset: '1');
                          }
                        } else {
                          showCustomSnackBar('write_item_name_for_search'.tr);
                        }
                      },
                    ),
                  )),
        
                  IconButton(
                    onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                    icon: CartWidget(color: Theme.of(context).textTheme.bodyLarge!.color, size: 25),
                  ),
        
                ]),
              ),
        
              Padding(
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
                child: Row(children: [
        
                  Text(widget.isPopular ? isShop ? 'most_popular_products'.tr : 'most_popular_items'.tr : widget.isSpecial ? 'special_offer'.tr : 'best_reviewed_item'.tr, style: robotoBold),
                  Text(' (${itemController.pageSize ?? 0})', style: robotoBold),
                  const Spacer(),

                  InkWell(
                    onTap: () {
                      showCustomBottomSheet(child: ItemViewAllSortBottomSheet(isPopular: widget.isPopular, isSpecial: widget.isSpecial));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        border: Border.all(color: Theme.of(context).hintColor),
                      ),
                      child: Icon(CupertinoIcons.sort_down, color: Theme.of(context).hintColor, size: 18),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  InkWell(
                    onTap: () {
        
                      List<double?> prices = [];
                      for (var product in itemController.discountedItemList!) {
                        prices.add(product.price);
                      }
                      prices.sort();
                      double? maxValue = prices.isNotEmpty ? prices[prices.length-1] : 99999999;
        
                      showCustomBottomSheet(child: ItemViewAllFilterBottomSheet(maxValue: maxValue, isPopular: widget.isPopular, isSpecial: widget.isSpecial));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        border: Border.all(color: Theme.of(context).primaryColor),
                      ),
                      child: Icon(Icons.filter_list, color: Theme.of(context).primaryColor, size: 18),
                    ),
                  ),
        
                ]),
              ),
        
              Expanded(
                child: items != null ? items.isNotEmpty ? GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: Dimensions.paddingSizeSmall,
                    crossAxisSpacing: Dimensions.paddingSizeSmall,
                    childAspectRatio: 0.60,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ItemCardWidget(
                      item: items![index]!,
                    );
                  },
                ) : Center(
                  child: Text(
                    'no_items_found'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                  ),
                ) : GridView.builder(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: Dimensions.paddingSizeSmall,
                    crossAxisSpacing: Dimensions.paddingSizeSmall,
                    childAspectRatio: 0.60,
                  ),
                  itemCount: 14,
                  itemBuilder: (context, index) {
                    return const ItemShimmerView();
                  },
                ),
              ),

              itemController.isLoading ? Center(child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
              )) : const SizedBox(),
        
            ]),
          ),
        ),
      );
    });
  }
}

class ItemCardWidget extends StatelessWidget {
  final Item item;
  const ItemCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    double? discount = item.discount;
    String? discountType = item.discountType;

    return OnHover(
      isItem: true,
      child: CustomCard(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: CustomInkWell(
          onTap: () => Get.find<ItemController>().navigateToItemPage(item, context),
          radius: Dimensions.radiusDefault,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Expanded(
              flex: 6,
              child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  child: CustomImage(
                    image: '${item.imageFullUrl}',
                    fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                  ),
                ),

                AddFavouriteView(
                  top: 5, right: 5,
                  item: item,
                ),

                item.isStoreHalalActive! && item.isHalalItem! ? const Positioned(
                  top: 30, right: 5,
                  child: CustomAssetImageWidget(
                    Images.halalTag,
                    height: 20, width: 20,
                  ),
                ) : const SizedBox(),

                DiscountTag(
                  discount: discount,
                  discountType: discountType,
                  freeDelivery: false,
                ),

                OrganicTag(item: item, placeInImage: false),

                (item.stock != null && item.stock! < 0) ? Positioned(
                  bottom: 10, left : 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(Dimensions.radiusLarge),
                        bottomRight: Radius.circular(Dimensions.radiusLarge),
                      ),
                    ),
                    child: Text('out_of_stock'.tr, style: robotoRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall)),
                  ),
                ) : const SizedBox(),

                Positioned(
                  bottom: 10, right: 10,
                  child: CartCountView(
                    item: item,
                  ),
                ),

                Get.find<ItemController>().isAvailable(item) ? const SizedBox() : const NotAvailableWidget(radius: Dimensions.radiusDefault, isAllSideRound: true),

              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Expanded(
              flex: 5,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [

                Flexible(child: Text(item.name ?? '', style: robotoBold, maxLines: 1, overflow: TextOverflow.ellipsis)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                item.ratingCount! > 0 ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Icon(Icons.star_rounded, size: 14, color: Theme.of(context).primaryColor),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Text(item.avgRating!.toStringAsFixed(1), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Text("(${item.ratingCount})", style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                ]) : const SizedBox(),
                SizedBox(height: item.ratingCount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                (Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && item.unitType != null) ? Text(
                  '(${ item.unitType ?? ''})',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor),
                ) : const SizedBox(),
                SizedBox(height: (Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && item.unitType != null) ? Dimensions.paddingSizeExtraSmall : 0),

                discount != null && discount > 0 ? Text(
                  PriceConverter.convertPrice(Get.find<ItemController>().getStartingPrice(item)),
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                    decoration: TextDecoration.lineThrough,
                  ), textDirection: TextDirection.ltr,
                ) : const SizedBox(),
                SizedBox(height: discount != null && discount > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                Text(
                  PriceConverter.convertPrice(
                    Get.find<ItemController>().getStartingPrice(item), discount: discount,
                    discountType: discountType,
                  ),
                  textDirection: TextDirection.ltr, style: robotoMedium,
                ),

              ]),
            ),

          ]),
        ),
      ),
    );
  }
}

class ItemShimmerView extends StatelessWidget {
  const ItemShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: true,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        height: 285, width: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        ),
        child: Column(children: [

          Container(
            height: 150, width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).shadowColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(children: [

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                height: 15, width: 100,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                height: 20, width: 200,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                height: 15, width: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}