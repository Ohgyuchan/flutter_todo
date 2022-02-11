import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title'.tr),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Center(
      child: Text('default_group'.tr),
    );
  }
}
