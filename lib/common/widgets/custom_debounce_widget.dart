import 'dart:async';
import 'package:flutter/material.dart';

class CustomDebounceWidget{

  final int milliseconds;
  Timer? _timer;
  CustomDebounceWidget({required this.milliseconds});
  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

}