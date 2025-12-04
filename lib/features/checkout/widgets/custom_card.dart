import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/dimensions.dart';

class CustomCard extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool isBorder;
  const CustomCard({super.key, this.child, this.width, this.height, this.borderRadius, this.margin, this.padding, this.isBorder = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity, height: height,
      margin: margin, padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(borderRadius ?? Dimensions.radiusDefault),
        border: isBorder ? Border.all(color: Get.isDarkMode ? const Color(0xff171515) : const Color(0xffF2F2F2), width: 1) : null,
        boxShadow: [BoxShadow(color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05), blurRadius: 20, spreadRadius: 0, offset: const Offset(0, 5))],
      ),
      child: child,
    );
  }
}
