import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<String>? items;
  final bool showTitle;
  final bool isBorder;
  final String? hintText;
  final double? borderRadius;
  final Color? backgroundColor;
  final Function(String?)? onChanged;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final FontWeight? titleFontWeight;
  final String? selectedValue;
  final List<DropdownMenuItem<String>>? dropdownMenuItems;

  const CustomDropdownButton({
    super.key,
    this.items,
    this.showTitle = true,
    this.isBorder = true,
    this.hintText,
    this.borderRadius,
    this.backgroundColor,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.titleFontWeight,
    this.selectedValue,
    this.dropdownMenuItems,
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 45,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? Dimensions.radiusDefault),
      ),
      child: DropdownButtonFormField2<String>(

        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          focusedBorder: _border(),
          enabledBorder: _border(),
          disabledBorder: _border(),
          focusedErrorBorder: _border(),
          errorBorder: _border(),
        ),
        hint: Text(
          widget.hintText ?? 'select_an_option'.tr,
          style: robotoRegular.copyWith(color: Colors.grey),
        ),
        value: widget.selectedValue,
        items: (widget.dropdownMenuItems ?? widget.items?.map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item, style: robotoRegular,
          ),
        )).toList()) ?? [
          DropdownMenuItem<String>(
            value: null,
            child: Text(
              'no_data_available'.tr,
              style: robotoRegular.copyWith(color: Colors.grey),
            ),
          )
        ],
        validator: widget.validator ?? (value) {
          if (value == null) {
            return 'please_select_an_option'.tr;
          }
          return null;
        },
        onChanged: widget.onChanged,
        onSaved: widget.onSaved,
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).disabledColor, size: 30),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? Dimensions.radiusDefault)),
      borderSide: BorderSide(width: 1, color: widget.isBorder ? Theme.of(context).disabledColor.withValues(alpha: 0.2) : Colors.transparent),
    );
  }
}
