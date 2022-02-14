import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('title'.tr),
        ),
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Text('default_group'.tr),
              const Icon(Icons.add),
            ],
          ),
        ),
      ],
    );
  }
}
