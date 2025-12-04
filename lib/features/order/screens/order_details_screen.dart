import 'dart:async';
import 'package:sixam_mart/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart/common/widgets/web_menu_bar.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/order/widgets/parcel_cancelation/cancellation_reason_bottom_sheet.dart';
import 'package:sixam_mart/features/order/widgets/parcel_cancelation/slider_button_widget.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/order/controllers/order_controller.dart';
import 'package:sixam_mart/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart/features/order/domain/models/order_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/confirmation_dialog.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_dialog.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/features/checkout/widgets/offline_success_dialog.dart';
import 'package:sixam_mart/features/order/widgets/cancellation_dialogue_widget.dart';
import 'package:sixam_mart/features/order/widgets/order_calcuation_widget.dart';
import 'package:sixam_mart/features/order/widgets/order_info_widget.dart';
import 'package:sixam_mart/features/review/screens/rate_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final int? orderId;
  final bool fromNotification;
  final bool fromOfflinePayment;
  final String? contactNumber;
  const OrderDetailsScreen({super.key, required this.orderModel, required this.orderId, this.fromNotification = false, this.fromOfflinePayment = false, this.contactNumber});

  @override
  OrderDetailsScreenState createState() => OrderDetailsScreenState();
}

class OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Timer? _timer;
  double? _maxCodOrderAmount;
  bool? _isCashOnDeliveryActive = false;
  final ScrollController scrollController = ScrollController();

  void _loadData(BuildContext context, bool reload) async {
    await Get.find<OrderController>().trackOrder(widget.orderId.toString(), reload ? null : widget.orderModel, false, contactNumber: widget.contactNumber).then((value) {
      if(widget.fromOfflinePayment) {
        Future.delayed(const Duration(seconds: 2), () => showAnimatedDialog(Get.context!, OfflineSuccessDialog(orderId: widget.orderId)));
      }
    });
    Get.find<OrderController>().timerTrackOrder(widget.orderId.toString(), contactNumber: widget.contactNumber);
    Get.find<OrderController>().getOrderDetails(widget.orderId.toString());
  }

  void _startApiCall(){
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await Get.find<OrderController>().timerTrackOrder(widget.orderId.toString(), contactNumber: widget.contactNumber);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData(context, false);
    _startApiCall();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async {
        if(widget.fromNotification || widget.fromOfflinePayment) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        } else {
          return;
        }
      },
      child: GetBuilder<OrderController>(builder: (orderController) {
        return Scaffold(
          appBar: isDesktop ? const WebMenuBar() : AppBar(
            title: Text(
              widget.orderModel?.orderType == 'parcel' ? 'parcel_details'.tr : 'order_details'.tr,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: () {
                if(widget.fromNotification || widget.fromOfflinePayment) {
                  Get.offAllNamed(RouteHelper.getInitialRoute());
                } else {
                  Get.back();
                }
              },
            ),
            backgroundColor: Theme.of(context).cardColor, surfaceTintColor: Theme.of(context).cardColor,
            shadowColor: Theme.of(context).disabledColor.withValues(alpha: 0.5), elevation: 2,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 2),
                decoration: BoxDecoration(
                  color: orderController.trackModel?.orderStatus == AppConstants.pending ? Colors.blue.withValues(alpha: 0.1) : orderController.trackModel?.orderStatus == AppConstants.canceled
                  ? Colors.red.withValues(alpha: 0.1) : Theme.of(context).disabledColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Text(
                  orderController.trackModel?.orderStatus?.tr ?? (widget.orderModel?.orderStatus?.tr ?? ''),
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: orderController.trackModel?.orderStatus == AppConstants.pending ? Colors.blue : orderController.trackModel?.orderStatus == AppConstants.canceled ?
                    Colors.red : Colors.green,
                  ),
                ),
              ),
            ]
          ),
          endDrawer: const MenuDrawer(),
          endDrawerEnableOpenDragGesture: false,
          body: SafeArea(child: GetBuilder<OrderController>(builder: (orderController) {
            double deliveryCharge = 0;
            double itemsPrice = 0;
            double discount = 0;
            double couponDiscount = 0;
            double tax = 0;
            double addOns = 0;
            double dmTips = 0;
            double additionalCharge = 0;
            double extraPackagingCharge = 0;
            double referrerBonusAmount = 0;
            OrderModel? order = orderController.trackModel;
            bool parcel = false;
            bool prescriptionOrder = false;
            bool taxIncluded = false;
            bool ongoing = false;
            bool showChatPermission = true;
            if(orderController.orderDetails != null  && order != null) {
              parcel = order.orderType == 'parcel';
              prescriptionOrder = order.prescriptionOrder!;
              deliveryCharge = order.deliveryCharge!;
              couponDiscount = order.couponDiscountAmount!;
              discount = order.storeDiscountAmount! + order.flashAdminDiscountAmount! + order.flashStoreDiscountAmount!;
              tax = order.totalTaxAmount!;
              dmTips = order.dmTips!;
              taxIncluded = order.taxStatus!;
              additionalCharge = order.additionalCharge!;
              extraPackagingCharge = order.extraPackagingAmount!;
              referrerBonusAmount = order.referrerBonusAmount!;
              if(prescriptionOrder) {
                double orderAmount = order.orderAmount ?? 0;
                itemsPrice = (orderAmount + discount) - ((taxIncluded ? 0 : tax) + deliveryCharge) - dmTips - additionalCharge;
              } else{
                for(OrderDetailsModel orderDetails in orderController.orderDetails!) {
                  for(AddOn addOn in orderDetails.addOns!) {
                    addOns = addOns + (addOn.price! * addOn.quantity!);
                  }
                  itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
                }
              }

              if(!parcel && order.store != null) {
                for(ZoneData zData in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
                  if(zData.id == order.store!.zoneId){
                    _isCashOnDeliveryActive = zData.cashOnDelivery;
                  }
                  for(Modules m in zData.modules!) {
                    if(m.id == order.store!.moduleId) {
                      _maxCodOrderAmount = m.pivot!.maximumCodOrderAmount;
                      break;
                    }
                  }
                }
              }

              if (order.store != null) {
                if (order.store!.storeBusinessModel == 'commission') {
                  showChatPermission = true;
                } else if (order.store!.storeSubscription != null && order.store!.storeBusinessModel == 'subscription') {
                  showChatPermission = order.store!.storeSubscription!.chat == 1;
                } else {
                  showChatPermission = false;
                }
              } else {
                showChatPermission = AuthHelper.isLoggedIn();
              }

              ongoing = (order.orderStatus != 'delivered' && order.orderStatus != 'failed' && order.orderStatus != 'canceled' && order.orderStatus != 'refund_requested'
              && order.orderStatus != 'refunded' && order.orderStatus != 'refund_request_canceled');

            }
            double subTotal = itemsPrice + addOns;
            double total = itemsPrice + addOns - discount + (taxIncluded ? 0 : tax) + deliveryCharge - couponDiscount + dmTips + additionalCharge + extraPackagingCharge - referrerBonusAmount;

            return orderController.orderDetails != null && order != null && orderController.trackModel != null ? Column(children: [

              isDesktop ? Container(
                height: 64,
                color: Theme.of(context).primaryColor.withValues(alpha: 0.10),
                child: Center(child: Text('order_details'.tr, style: robotoMedium)),
              ) : const SizedBox(),

              Expanded(child: SingleChildScrollView(
                controller: scrollController,
                child: FooterView(
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Column(children: [
                      isDesktop ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(
                          flex: 6,
                          child : OrderInfoWidget(
                            order: order, ongoing: ongoing, parcel: parcel, prescriptionOrder: prescriptionOrder,
                            timerCancel : () => _timer?.cancel(), startApiCall : () =>  _startApiCall(),
                            orderController: orderController, showChatPermission: showChatPermission,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        Expanded(
                          flex: 4,
                          child: OrderCalculationWidget(
                            orderController: orderController, order: order, ongoing: ongoing, parcel: parcel,
                            prescriptionOrder: prescriptionOrder, deliveryCharge: deliveryCharge, itemsPrice: itemsPrice,
                            discount: discount, couponDiscount: couponDiscount, tax: tax, addOns: addOns, dmTips: dmTips,
                            taxIncluded: taxIncluded, subTotal: subTotal, total: total,
                            bottomView: buildBottomView(orderController, order, parcel, total), extraPackagingAmount: extraPackagingCharge,
                            referrerBonusAmount: referrerBonusAmount, timerCancel : () => _timer?.cancel(), startApiCall : () =>  _startApiCall(),
                          ),
                        ),
                      ]) : const SizedBox(),

                      isDesktop ? const SizedBox() : OrderInfoWidget(
                        order: order, ongoing: ongoing, parcel: parcel, prescriptionOrder: prescriptionOrder,
                        timerCancel : () => _timer?.cancel(), startApiCall : () =>  _startApiCall(),
                        orderController: orderController, showChatPermission: showChatPermission,
                      ),

                      isDesktop ? const SizedBox() : OrderCalculationWidget(
                        orderController: orderController, order: order, ongoing: ongoing, parcel: parcel,
                        prescriptionOrder: prescriptionOrder, deliveryCharge: deliveryCharge, itemsPrice: itemsPrice,
                        discount: discount, couponDiscount: couponDiscount, tax: tax, addOns: addOns, dmTips: dmTips, taxIncluded: taxIncluded, subTotal: subTotal, total: total,
                        bottomView:  buildBottomView(orderController, order, parcel, total), extraPackagingAmount: extraPackagingCharge, referrerBonusAmount: referrerBonusAmount,
                        timerCancel : () => _timer?.cancel(), startApiCall : () =>  _startApiCall(),
                      ),
                    ]),
                  ),
                ),
              )),

              isDesktop ? const SizedBox() : buildBottomView(orderController, order, parcel, total),

            ]) : const Center(child: CircularProgressIndicator());
          })),
        );
      }),
    );
  }

  Widget buildBottomView(OrderController orderController, OrderModel order, bool parcel, double total) {
    return parcel ? _buildParcelBottomView(orderController, order, parcel, total) : _buildRegularBottomView(orderController, order, parcel, total);
  }

  Widget _buildRegularBottomView(OrderController orderController, OrderModel order, bool parcel, double totalPrice) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    final showCancelButton = _ButtonVisibilityHelper.shouldShowCancelButton(order, orderController);
    final showTrackDeliveryButton = _ButtonVisibilityHelper.shouldShowTrackDeliveryButton(order);
    final showReviewButton = _ButtonVisibilityHelper.shouldShowReviewButton(order, orderController);
    final showSwitchToCodButton = _ButtonVisibilityHelper.shouldShowSwitchToCodButton(order, _isCashOnDeliveryActive!);
    final showFailedCodButton = _ButtonVisibilityHelper.shouldShowFailedOrderCodButton(order);

    final showDecoration = showCancelButton || showTrackDeliveryButton || showReviewButton || showSwitchToCodButton;

    return Container(
      padding: EdgeInsets.all(!isDesktop && showDecoration ? Dimensions.paddingSizeDefault : 0),
      decoration: !isDesktop && showDecoration ? BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
      ) : null,
      child: Column(children: [
        if (!orderController.showCancelled) ...[
          _buildActionButtonsRow(
            showCancelButton: showCancelButton,
            showTrackDeliveryButton: showTrackDeliveryButton,
            isDesktop: isDesktop,
            order: order,
            parcel: parcel,
            onCancelPressed: () => _handleCancelOrder(orderController, order),
            onTrackPressed: () => _handleTrackOrder(order),
          ),

          if (showSwitchToCodButton)
            _buildSwitchToCodButton(orderController, order, parcel, totalPrice),
        ] else
          _buildCancelledOrderWidget(isDesktop),

        if (showReviewButton)
          _buildReviewButton(orderController, order),

        if (showFailedCodButton)
          _buildFailedOrderCodButton(orderController, order),
      ]),
    );
  }

  // Refactored parcel bottom view
  Widget _buildParcelBottomView(OrderController orderController, OrderModel order, bool parcel, double totalPrice) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    final showCancelButton = _ButtonVisibilityHelper.shouldShowParcelCancelButton(order, orderController);
    final showTrackDeliveryButton = _ButtonVisibilityHelper.shouldShowParcelTrackButton(order);
    final showReturnOtp = _ButtonVisibilityHelper.shouldShowParcelReturnOtp(order);
    final showReviewButton = _ButtonVisibilityHelper.shouldShowParcelReviewButton(order);
    final showSwitchToCodButton = _ButtonVisibilityHelper.shouldShowSwitchToCodButton(order, _isCashOnDeliveryActive!);
    final showFailedCodButton = _ButtonVisibilityHelper.shouldShowFailedOrderCodButton(order);

    final showDecoration = showCancelButton || showTrackDeliveryButton || showReturnOtp || showReviewButton || showSwitchToCodButton;

    return Container(
      padding: EdgeInsets.all(!isDesktop && showDecoration ? Dimensions.paddingSizeDefault : 0),
      decoration: !isDesktop && showDecoration ? BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
      ) : null,
      child: Column(children: [
        if (!orderController.showCancelled) ...[
          _buildParcelActionButtonsRow(
            showCancelButton: showCancelButton,
            showTrackDeliveryButton: showTrackDeliveryButton,
            order: order,
            parcel: parcel,
            isDesktop: isDesktop,
            onCancelPressed: () => _handleParcelCancel(orderController, order, isDesktop),
            onTrackPressed: () => _handleTrackOrder(order),
          ),

          if (_ButtonVisibilityHelper.shouldShowSwitchToCodButton(order, _isCashOnDeliveryActive!))
            _buildSwitchToCodButton(orderController, order, parcel, totalPrice),
        ] else
          _buildCancelledOrderWidget(isDesktop),

        if (showReturnOtp) ...[
          _buildParcelReturnOtpDisplay(order),
          SizedBox(height: Dimensions.paddingSizeSmall),

          _buildParcelReturnSlider(orderController, order),
        ],

        if (showReviewButton)
          _buildReviewButton(orderController, order),

        if (showFailedCodButton)
          _buildFailedOrderCodButton(orderController, order),
      ]),
    );
  }

  Widget _buildActionButtonsRow({required bool showCancelButton, required bool showTrackDeliveryButton, required bool isDesktop, required OrderModel order,
    required bool parcel, required VoidCallback onCancelPressed, required VoidCallback onTrackPressed}) {
    return Row(children: [
      if (showCancelButton)
        Expanded(
          child: CustomButton(
            isBorder: true,
            color: Colors.transparent,
            onPressed: onCancelPressed,
            buttonText: parcel ? 'cancel_delivery'.tr : 'cancel_order'.tr,
            textColor: Theme.of(context).disabledColor,
          ),
        ),

      if (showCancelButton && showTrackDeliveryButton)
        SizedBox(width: Dimensions.paddingSizeSmall),

      if (showTrackDeliveryButton)
        Expanded(
          child: CustomButton(
            buttonText: parcel ? 'track_delivery'.tr : 'track_order'.tr,
            onPressed: onTrackPressed,
          ),
        ),
    ]);
  }

  Widget _buildParcelActionButtonsRow({required bool showCancelButton, required bool showTrackDeliveryButton, required OrderModel order, required bool parcel,
    required bool isDesktop, required VoidCallback onCancelPressed, required VoidCallback onTrackPressed}) {
    return Row(children: [
      if (showCancelButton)
        Expanded(
          child: CustomButton(
            isBorder: true,
            color: Colors.transparent,
            onPressed: onCancelPressed,
            buttonText: 'cancel_delivery'.tr,
            textColor: Theme.of(context).disabledColor,
          ),
        ),

      if (showCancelButton && showTrackDeliveryButton)
        SizedBox(width: Dimensions.paddingSizeSmall),

      if (showTrackDeliveryButton)
        Expanded(
          child: CustomButton(
            buttonText: 'track_delivery'.tr,
            onPressed: onTrackPressed,
          ),
        ),
    ]);
  }

  Widget _buildSwitchToCodButton(OrderController orderController, OrderModel order, bool parcel, double totalPrice) {
    return CustomButton(
      buttonText: 'switch_to_cod'.tr,
      margin: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeSmall,
      ),
      onPressed: () => _handleSwitchToCod(orderController, order, parcel, totalPrice),
    );
  }

  Widget _buildCancelledOrderWidget(bool isDesktop) {
    return Center(
      child: Container(
        width: Dimensions.webMaxWidth,
        height: 50,
        margin: isDesktop ? null : const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeSmall,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        child: Text(
          'order_cancelled'.tr,
          style: robotoMedium.copyWith(color: Theme.of(context).disabledColor),
        ),
      ),
    );
  }

  Widget _buildReviewButton(OrderController orderController, OrderModel order) {
    return CustomButton(
      buttonText: 'review'.tr,
      color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
      textColor: Theme.of(context).textTheme.bodyLarge!.color,
      onPressed: () => _handleReviewButton(orderController, order),
    );
  }

  Widget _buildFailedOrderCodButton(OrderController orderController, OrderModel order) {
    return CustomButton(
      buttonText: 'switch_to_cash_on_delivery'.tr,
      textColor: Theme.of(context).textTheme.bodyLarge!.color,
      color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
      onPressed: () => _handleFailedOrderCod(orderController, order),
    );
  }

  Widget _buildParcelReturnOtpDisplay(OrderModel order) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        'parcel_returned_otp'.tr,
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
      ),

      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraSmall,
            vertical: 2,
          ),
          child: Text(
            order.parcelCancellation!.returnOtp.toString(),
            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
        ),
      ),
    ]);
  }

  Widget _buildParcelReturnSlider(OrderController orderController, OrderModel order) {
    return SliderButton(
      label: Text(
        'parcel_received'.tr,
        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).secondaryHeaderColor),
      ),
      dismissThresholds: 0.5, dismissible: false, shimmer: true, width: 1170,
      height: 60, buttonSize: 50, radius: 10,
      icon: Center(
        child: Icon(
          Get.find<LocalizationController>().isLtr ? Icons.double_arrow_sharp : Icons.keyboard_arrow_left,
          color: Colors.white,
          size: 20.0,
        ),
      ),
      isLtr: Get.find<LocalizationController>().isLtr,
      boxShadow: const BoxShadow(blurRadius: 0),
      buttonColor: Theme.of(context).primaryColor,
      backgroundColor: const Color(0xffF4F7FC),
      baseColor: Theme.of(context).primaryColor,
      action: () async {
        bool isSuccess = await orderController.submitParcelReturn(
          orderId: order.id!,
          returnOtp: order.parcelCancellation!.returnOtp!,
          contactNumber: widget.contactNumber,
        );

        if (mounted && isSuccess) {
          showCustomSnackBar('parcel_returned_successfully'.tr, isError: false);
        }
      },
    );
  }

  void _handleCancelOrder(OrderController orderController, OrderModel order) {
    orderController.setOrderCancelReason('');
    Get.dialog(CancellationDialogueWidget(
      orderId: order.id,
      contactNumber: widget.contactNumber,
    ));
  }

  void _handleParcelCancel(OrderController orderController, OrderModel order, bool isDesktop) {
    final isBeforePickup = ['pending', 'accepted', 'confirmed'].contains(order.orderStatus);
    final cancellationSheet = CancellationReasonBottomSheet(
      isBeforePickup: isBeforePickup,
      orderId: order.id,
      contactNumber: widget.contactNumber,
      chargePayerSender: order.chargePayer == 'sender',
      orderAmount: order.orderAmount ?? 0,
      dmTips: order.dmTips ?? 0,
    );

    if (isDesktop) {
      Get.dialog(Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        insetPadding: const EdgeInsets.all(20),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: cancellationSheet,
      ));
    } else {
      showCustomBottomSheet(child: cancellationSheet);
    }
  }

  Future<void> _handleTrackOrder(OrderModel order) async {
    _timer?.cancel();
    await Get.toNamed(RouteHelper.getOrderTrackingRoute(order.id, widget.contactNumber))?.whenComplete(() => _startApiCall());
  }

  void _handleSwitchToCod(OrderController orderController, OrderModel order, bool parcel, double totalPrice) {
    Get.dialog(ConfirmationDialog(
      icon: Images.warning,
      description: 'are_you_sure_to_switch'.tr,
      onYesPressed: () {
        final canSwitchToCod = _canSwitchToCashOnDelivery(parcel, totalPrice);

        if (canSwitchToCod) {
          orderController.switchToCOD(order.id.toString());
        } else {
          if (Get.isDialogOpen!) Get.back();
             showCustomSnackBar('${'you_cant_order_more_then'.tr} ${PriceConverter.convertPrice(_maxCodOrderAmount)} ${'in_cash_on_delivery'.tr}'
          );
        }
      },
    ));
  }

  void _handleReviewButton(OrderController orderController, OrderModel order) {
    final orderDetailsList = <OrderDetailsModel>[];
    final orderDetailsIdList = <int?>[];

    for (var orderDetail in orderController.orderDetails!) {
      if (!orderDetailsIdList.contains(orderDetail.itemDetails!.id)) {
        orderDetailsList.add(orderDetail);
        orderDetailsIdList.add(orderDetail.itemDetails!.id);
      }
    }

    Get.toNamed(RouteHelper.getReviewRoute(), arguments: RateReviewScreen(
      orderDetailsList: orderDetailsList,
      deliveryMan: order.deliveryMan,
      orderID: order.id,
      reviews: order.reviews,
    ));
  }

  void _handleFailedOrderCod(OrderController orderController, OrderModel order) {
    Get.dialog(ConfirmationDialog(
      icon: Images.warning,
      description: 'are_you_sure_to_switch'.tr,
      onYesPressed: () {
        orderController.switchToCOD(order.id.toString()).then((isSuccess) {
          Get.back();
          if (isSuccess) Get.back();
        });
      },
    ));
  }

  bool _canSwitchToCashOnDelivery(bool parcel, double totalPrice) {
    if (parcel) return true;

    return (_maxCodOrderAmount != null && totalPrice < _maxCodOrderAmount!) || _maxCodOrderAmount == null || _maxCodOrderAmount == 0;
  }
}


class _ButtonVisibilityHelper {
  static bool shouldShowCancelButton(OrderModel order, OrderController orderController) {
    final isUserLoggedIn = Get.find<AuthController>().isLoggedIn();
    final hasGuestOrderDetails = orderController.orderDetails != null && orderController.orderDetails!.isNotEmpty && orderController.orderDetails![0].isGuest == 1;

    final canCancel = isUserLoggedIn || hasGuestOrderDetails;

    return order.orderStatus == 'pending' && canCancel;
  }

  static bool shouldShowParcelCancelButton(OrderModel order, OrderController orderController) {
    final isUserLoggedIn = Get.find<AuthController>().isLoggedIn();
    final isGuestLoggedIn = Get.find<AuthController>().isGuestLoggedIn();
    final hasGuestOrderDetails = orderController.orderDetails != null && orderController.orderDetails!.isNotEmpty && orderController.orderDetails![0].isGuest == 1;

    final canCancel = isUserLoggedIn || hasGuestOrderDetails;
    final cancellableStatuses = ['pending', 'accepted', 'confirmed', 'processing', 'handover', 'picked_up'];

    if(isGuestLoggedIn){
      return order.orderStatus == 'pending' && canCancel;
    }else{
      return cancellableStatuses.contains(order.orderStatus) && canCancel;
    }
  }

  static bool shouldShowTrackDeliveryButton(OrderModel order) {
    final trackableStatuses = ['pending', 'accepted', 'confirmed', 'processing', 'handover', 'picked_up'];
    final isPendingWithoutDigitalPayment = order.orderStatus == 'pending' && order.paymentMethod != 'digital_payment';

    return isPendingWithoutDigitalPayment || trackableStatuses.contains(order.orderStatus);
  }

  static bool shouldShowParcelTrackButton(OrderModel order) {
    final trackableStatuses = ['pending', 'accepted', 'confirmed', 'processing', 'handover', 'picked_up'];
    return trackableStatuses.contains(order.orderStatus);
  }

  static bool shouldShowReviewButton(OrderModel order, OrderController orderController) {
    if (AuthHelper.isGuestLoggedIn()) return false;
    if (order.orderStatus != 'delivered') return false;

    return orderController.orderDetails!.isNotEmpty && orderController.orderDetails![0].itemCampaignId == null && canReviews(order.reviews, orderController);
  }

  static bool shouldShowParcelReviewButton(OrderModel order) {
    if (AuthHelper.isGuestLoggedIn()) return false;

    final canReview = order.orderStatus == 'delivered' || order.orderStatus == 'returned';
    if (!canReview) return false;

    return order.deliveryMan != null;
  }

  static bool canReviews(List<Reviews>? reviews, OrderController orderController) {
    if(AuthHelper.isLoggedIn()) {
      if(reviews != null && reviews.isNotEmpty){
        for (int i = 0; i < orderController.orderDetails!.length; i++) {
          for(int j = 0; j < reviews.length; j++) {
            if(orderController.orderDetails![i].itemId == reviews[j].itemId) {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  static bool shouldShowSwitchToCodButton(OrderModel order, bool isCashOnDeliveryActive) {
    return order.orderStatus == 'pending' && order.paymentStatus == 'unpaid' && order.paymentMethod == 'digital_payment' && isCashOnDeliveryActive;
  }

  static bool shouldShowParcelReturnOtp(OrderModel order) {
    return order.orderStatus != 'returned' && order.parcelCancellation != null && order.parcelCancellation!.beforePickup == 0 && order.parcelCancellation!.returnOtp != null;
  }

  static bool shouldShowFailedOrderCodButton(OrderModel order) {
    return order.orderStatus == 'failed' && Get.find<SplashController>().configModel!.cashOnDelivery!;
  }
}