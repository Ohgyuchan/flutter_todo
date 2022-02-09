import 'package:flutter/material.dart';

class Elements {
  String name = '';
  String group;
  final TextEditingController controller = TextEditingController();
  final FocusNode node = FocusNode();
  bool longPressed = false;
  bool checked = false;

  Elements(this.group);
}
