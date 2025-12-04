import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';

class CustomCheckBoxWidget extends StatelessWidget {
  final String title;
  final bool value;
  final Function onClick;
  const CustomCheckBoxWidget({super.key, required this.title, required this.value, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick as void Function()?,
      child: Row(children: [
        Checkbox(
          value: value,
          onChanged: (bool? isActive) => onClick(),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: Theme.of(context).primaryColor,
          side: BorderSide(
            color: value ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.5),
          ),
        ),

        Text(title, style: robotoRegular),
      ]),
    );
  }
}
