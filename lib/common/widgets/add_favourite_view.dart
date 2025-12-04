import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';

class AddFavouriteView extends StatefulWidget {
  final Item? item;
  final double? top, right;
  final double? left;
  final int? storeId;
  const AddFavouriteView({super.key, required this.item, this.top = 15, this.right = 15, this.left, this.storeId});

  @override
  State<AddFavouriteView> createState() => _AddFavouriteViewState();
}

class _AddFavouriteViewState extends State<AddFavouriteView> with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top, right: widget.right, left: widget.left,
      child: GetBuilder<FavouriteController>(builder: (favouriteController) {
        bool isWished;
        if(widget.storeId != null) {
          isWished = favouriteController.wishStoreIdList.contains(widget.storeId);
        } else {
          isWished = favouriteController.wishItemIdList.contains(widget.item!.id);
        }
        return InkWell(
          onTap: favouriteController.isRemoving ? null : () {
            if(AuthHelper.isLoggedIn()) {
              if(widget.storeId != null) {
                isWished ? favouriteController.removeFromFavouriteList(widget.storeId, true) : favouriteController.addToFavouriteList(null, widget.storeId, true);
              } else {
                isWished ? favouriteController.removeFromFavouriteList(widget.item!.id, false) : favouriteController.addToFavouriteList(widget.item, null, false);
              }
            }else {
              showCustomSnackBar('you_are_not_logged_in'.tr);
            }
            _controller.reverse().then((value) => _controller.forward());
          },
          child: ScaleTransition(
            scale: Tween(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
            child: Icon(isWished ? CupertinoIcons.heart_solid : CupertinoIcons.heart, color: isWished ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withValues(alpha: 0.3), size: 25),
          ),
        );
      }),
    );
  }
}
