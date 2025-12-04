import 'package:flutter/material.dart';
import 'package:sixam_mart/common/widgets/web_page_title_widget.dart'; // your widget file


void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 1200, // force desktop width (because your widget only shows on desktop)
            child: WebScreenTitleWidget(title: "Preview Title"),
          ),
        ),
      ),
    ),
  );
}
