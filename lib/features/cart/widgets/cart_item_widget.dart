import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/cart/controllers/cart_controller.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/cart/domain/models/cart_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/item_bottom_sheet.dart';
import 'package:sixam_mart/common/widgets/quantity_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItemWidget extends StatefulWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  final bool showDivider;
  const CartItemWidget({super.key, required this.cart, required this.cartIndex, required this.isAvailable, required this.addOns, required this.showDivider});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {

  bool showAddonsVariations = false;

  @override
  Widget build(BuildContext context) {

    double? startingPrice = _calculatePrice(item: widget.cart.item);
    double? endingPrice = _calculatePrice(item: widget.cart.item, isStartingPrice: false);
    String? variationText = _setupVariationText(cart: widget.cart).$1;
    String addOnText = _setupAddonsText(cart: widget.cart) ?? '';
    //double addonPrice = _calculateAddonPrice(widget.cart);

    int addonCount = widget.cart.addOnIds?.length ?? 0;
    int variationCount = _setupVariationText(cart: widget.cart).$2;

    double? discount = widget.cart.item!.discount;
    String? discountType = widget.cart.item!.discountType;
    String genericName = '';

    if(widget.cart.item!.genericName != null && widget.cart.item!.genericName!.isNotEmpty) {
      for (String name in widget.cart.item!.genericName!) {
        genericName += name;
      }
    }

    double totalPrice = _calculatePriceWithVariation(cartModel: widget.cart, discount: discount, discountType: discountType);

    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: (context) {
                Get.find<CartController>().removeFromCart(widget.cartIndex, item: widget.cart.item);
              },
              backgroundColor: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.horizontal(right: Radius.circular(Get.find<LocalizationController>().isLtr ? Dimensions.radiusDefault : 0), left: Radius.circular(Get.find<LocalizationController>().isLtr ? 0 : Dimensions.radiusDefault)),
              foregroundColor: Colors.white,
              icon: CupertinoIcons.delete,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: showAddonsVariations ? Theme.of(context).disabledColor.withValues(alpha: 0.05) : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            // boxShadow: !ResponsiveHelper.isMobile(context) ? [const BoxShadow()] : [const BoxShadow(
            //   color: Colors.black12, blurRadius: 5, spreadRadius: 1,
            // )],
          ),
          child: CustomInkWell(
            onTap: () {
              ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (con) => ItemBottomSheet(itemId: widget.cart.item!.id!, cartIndex: widget.cartIndex, cart: widget.cart),
              ) : showDialog(context: context, builder: (con) => Dialog(
                child: ItemBottomSheet(itemId: widget.cart.item!.id!, cartIndex: widget.cartIndex, cart: widget.cart),
              ));
            },
            radius: Dimensions.radiusDefault,
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeExtraSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: CustomImage(
                          image: '${widget.cart.item!.imageFullUrl}',
                          height: ResponsiveHelper.isDesktop(context) ? 90 : 60, width: ResponsiveHelper.isDesktop(context) ? 90 : 60, fit: BoxFit.cover,
                        ),
                      ),
                      widget.isAvailable ? const SizedBox() : Positioned(
                        top: 0, left: 0, bottom: 0, right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.black.withValues(alpha: 0.6)),
                          child: Text('not_available_now_break'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(
                            color: Colors.white, fontSize: 8,
                          )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Flexible(
                          child: Text(
                            widget.cart.item!.name!,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        ((Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && widget.cart.item!.unitType != null && !Get.find<SplashController>().getModuleConfig(widget.cart.item!.moduleType).newVariation!)
                            || (Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!))
                            ? !Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! ? CustomAssetImageWidget(
                          widget.cart.item!.veg == 0 ? Images.nonVegImage : Images.vegImage,
                          height: 11, width: 11,
                        ) : Container(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          ),
                          child: Text(
                            widget.cart.item!.unitType ?? '',
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                          ),
                        ) : const SizedBox(),

                        SizedBox(width: widget.cart.item!.isStoreHalalActive! && widget.cart.item!.isHalalItem! ? Dimensions.paddingSizeExtraSmall : 0),

                        widget.cart.item!.isStoreHalalActive! && widget.cart.item!.isHalalItem! ? const CustomAssetImageWidget(
                         Images.halalTag, height: 13, width: 13) : const SizedBox(),

                      ]),

                      (genericName.isNotEmpty) ? Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Row(children: [
                          Flexible(
                            child: Text(
                              genericName,
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).disabledColor,
                              ),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ]),
                      ) : const SizedBox(),

                      const SizedBox(height: 2),

                      Wrap(children: [
                        Text(
                          '${PriceConverter.convertPrice(startingPrice, discount: discount, discountType: discountType)}'
                              '${endingPrice!= null ? ' - ${PriceConverter.convertPrice(endingPrice, discount: discount, discountType: discountType)}' : ''}',
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                        ),
                        SizedBox(width: discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                        discount > 0 ? Text(
                          '${PriceConverter.convertPrice(startingPrice)}'
                              '${endingPrice!= null ? ' - ${PriceConverter.convertPrice(endingPrice)}' : ''}',
                          textDirection: TextDirection.ltr,
                          style: robotoRegular.copyWith(
                            color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough,
                            fontSize: Dimensions.fontSizeExtraSmall,
                          ),
                        ) : const SizedBox(),
                      ]),

                      widget.cart.item!.isPrescriptionRequired! ? Padding(
                        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 2),
                        child: Text(
                          '* ${'prescription_required'.tr}',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).colorScheme.error),
                        ),
                      ) : const SizedBox(),

                      addOnText.isNotEmpty || variationText!.isNotEmpty ? InkWell(
                        onTap: () {
                          setState(() {
                            showAddonsVariations = !showAddonsVariations;
                          });
                        },
                        child: Row(spacing: Dimensions.paddingSizeExtraSmall, children: [
                          Text('${variationCount > 0 ? '$variationCount ${'variations'.tr}' : ''}'
                              '${addonCount > 0 ? ', $addonCount ${'addons'.tr}' : ''}',
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                            ),
                            child: Icon(
                              showAddonsVariations ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined,
                              size: 20, color: showAddonsVariations ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                            ),
                          ),
                        ]),
                      ) : const SizedBox(),

                    ]),
                  ),

                  GetBuilder<CartController>(
                    builder: (cartController) {
                      return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Row(children: [
                          QuantityButton(
                            onTap: cartController.isLoading ? null : () {
                              if (widget.cart.quantity! > 1) {
                                Get.find<CartController>().setQuantity(false, widget.cartIndex, widget.cart.stock, widget.cart.quantityLimit);
                              }else {
                                Get.find<CartController>().removeFromCart(widget.cartIndex, item: widget.cart.item);
                              }
                            },
                            isIncrement: false,
                            showRemoveIcon: widget.cart.quantity! == 1,
                          ),

                          Text(
                            widget.cart.quantity.toString(),
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                          ),

                          QuantityButton(
                            onTap: cartController.isLoading ? null : () {
                              Get.find<CartController>().forcefullySetModule(Get.find<CartController>().cartList[0].item!.moduleId!);
                              Get.find<CartController>().setQuantity(true, widget.cartIndex, widget.cart.stock, widget.cart.quantityLimit);
                            },
                            isIncrement: true,
                            color: cartController.isLoading ? Theme.of(context).disabledColor : null,
                          ),
                        ]),

                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Padding(
                          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                          child: PriceConverter.convertAnimationPrice(totalPrice),
                        ),
                      ]);
                    }
                  ),
                ]),

                if(showAddonsVariations)
                  Padding(
                    padding: EdgeInsets.only(left: ResponsiveHelper.isDesktop(context) ? 100 : 70),
                    child: Column(children: [

                      addOnText.isNotEmpty ? Padding(
                        padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('${'addons'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          Flexible(child: Text(
                            addOnText,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                          )),
                        ]),
                      ) : const SizedBox(),

                      variationText!.isNotEmpty ? Padding(
                        padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('${'variations'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          Flexible(child: Text(
                            variationText,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                          )),
                        ]),
                      ) : const SizedBox(),

                    ]),
                  ),

                if(widget.showDivider)
                  const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double? _calculatePrice({required Item? item, bool isStartingPrice = true}) {
    double? startingPrice;
    double? endingPrice;
    bool newVariation = Get.find<SplashController>().getModuleConfig(item!.moduleType).newVariation ?? false;

    if(item.variations!.isNotEmpty && !newVariation) {
      List<double?> priceList = [];
      for (var variation in item.variations!) {
        priceList.add(variation.price);
      }
      priceList.sort((a, b) => a!.compareTo(b!));
      startingPrice = priceList[0];
      if(priceList[0]! < priceList[priceList.length-1]!) {
        endingPrice = priceList[priceList.length-1];
      }
    }else {
      startingPrice = item.price;
    }
    if(isStartingPrice) {
      return startingPrice;
    } else {
      return endingPrice;
    }
  }

  double _calculatePriceWithVariation({required CartModel cartModel, required double? discount, required String? discountType}) {
    bool newVariation = Get.find<SplashController>().getModuleConfig(cartModel.item!.moduleType).newVariation ?? false;
    double price = 0;
    if(newVariation) {
      for(int index = 0; index< cartModel.item!.foodVariations!.length; index++) {
        for(int i=0; i<cartModel.item!.foodVariations![index].variationValues!.length; i++) {
          if(cartModel.foodVariations![index][i]!) {
            price += (PriceConverter.convertWithDiscount(cartModel.item!.foodVariations![index].variationValues![i].optionPrice!, discount, discountType, isFoodVariation: true)! * cartModel.quantity!);
          }
        }
      }

      price = price + _calculateAddonPrice(cartModel) + (PriceConverter.convertWithDiscount(cartModel.item!.price!, discount, discountType, isFoodVariation: true)! * cartModel.quantity!);

    } else {

      String variationType = '';
      for(int i=0; i<cartModel.variation!.length; i++) {
        variationType = cartModel.variation![i].type!;
      }

      if(variationType.isNotEmpty) {
        for (Variation variation in cartModel.item!.variations!) {
          if (variation.type == variationType) {
            price = (PriceConverter.convertWithDiscount(variation.price!, discount, discountType)! * cartModel.quantity!);
            break;
          }
        }
      } else {
        price = (PriceConverter.convertWithDiscount(cartModel.item!.price!, discount, discountType)! * cartModel.quantity!);
      }
    }
    return price;
  }

  (String?, int) _setupVariationText({required CartModel cart}) {
    String? variationText = '';
    int count = 0;

    if(Get.find<SplashController>().getModuleConfig(cart.item!.moduleType).newVariation!) {
      if(cart.foodVariations!.isNotEmpty) {
        for(int index=0; index<cart.foodVariations!.length; index++) {
          if(cart.foodVariations![index].contains(true)) {
            variationText = '${variationText!}${variationText.isNotEmpty ? ', ' : ''}${cart.item!.foodVariations![index].name} (';
            for(int i=0; i<cart.foodVariations![index].length; i++) {
              if(cart.foodVariations![index][i]!) {
                variationText = '${variationText!}${variationText.endsWith('(') ? '' : ', '}${cart.item!.foodVariations![index].variationValues![i].level}';
                count ++;
              }
            }
            variationText = '${variationText!})';
          }
        }
      }
    }else {
      if(cart.variation!.isNotEmpty) {
        List<String> variationTypes = cart.variation![0].type!.split('-');
        if(variationTypes.length == cart.item!.choiceOptions!.length) {
          int index0 = 0;
          for (var choice in cart.item!.choiceOptions!) {
            variationText = '${variationText!}${(index0 == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index0]}';
            index0 = index0 + 1;
            count ++;
          }
        }else {
          variationText = cart.item!.variations![0].type;
        }
      }
    }
    return (variationText, count);
  }

  String? _setupAddonsText({required CartModel cart}) {
    String addOnText = '';
    int index0 = 0;
    List<int?> ids = [];
    List<int?> qtys = [];
    for (var addOn in cart.addOnIds!) {
      ids.add(addOn.id);
      qtys.add(addOn.quantity);
    }
    for (var addOn in cart.item!.addOns!) {
      if (ids.contains(addOn.id)) {
        addOnText = '$addOnText${(index0 == 0) ? '' : ',  '}${addOn.name} (${qtys[index0]})';
        index0 = index0 + 1;
      }
    }
    return addOnText;
  }

  double _calculateAddonPrice(CartModel cartModel) {
    List<AddOns> addOnList = [];
    double addonPrice = 0;
    for (var addOnId in cartModel.addOnIds!) {
      for(AddOns addOns in cartModel.item!.addOns!) {
        if(addOns.id == addOnId.id) {
          addOnList.add(addOns);
          break;
        }
      }
    }

    for(int index=0; index<addOnList.length; index++) {
      addonPrice = addonPrice + (addOnList[index].price! * cartModel.addOnIds![index].quantity!);
    }
    return addonPrice;
  }
}
