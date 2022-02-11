import 'package:flutter/material.dart';

class Elements {
  String name = '';
  String group;
  final TextEditingController controller = TextEditingController();
  final FocusNode node = FocusNode();
  DateTime dateTime;
  bool longPressed = false;
  bool checked = false;

  Elements(this.group, this.dateTime);
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
