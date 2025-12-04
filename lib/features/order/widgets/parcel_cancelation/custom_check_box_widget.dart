import 'package:flutter/material.dart';
import 'package:sixam_mart/util/styles.dart';

class CustomCheckBoxWidget extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onClick;
  const CustomCheckBoxWidget({super.key, required this.title, required this.value, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(!value),
      child: Row(children: [
        Expanded(child: Text(title, style: robotoRegular.copyWith(
          color: value ? Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6) : Theme.of(context).hintColor,
          fontWeight: value ? FontWeight.w500 : FontWeight.w400,
        ))),

        Checkbox(
          value: value,
          onChanged: (bool? isActive) => onClick(isActive ?? false),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: Theme.of(context).primaryColor,
          side: BorderSide(
            color: value ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.5),
          ),
        ),
      ]),
    );
  }
}
