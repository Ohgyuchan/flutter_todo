import 'package:get/get.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GetMaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  final List<TextEditingController> controllers = <TextEditingController>[];
  final List<TextField> fileds = <TextField>[];
  final List<FocusNode> nodes = <FocusNode>[];

  var longPressed = false;

  void addItemToList() {
    setState(() {
      fileds.add(TextField());
      nodes.add(FocusNode());
      controllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Tutorial - googleflutter.com'),
        ),
        body: Column(children: <Widget>[
          ElevatedButton(
            child: Text('Add'),
            onPressed: () {
              if (controllers.last.text.trim().isNotEmpty) {
                addItemToList();
                nodes.last.requestFocus();
              }
            },
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: fileds.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.snackbar('title', 'message');
                        },
                        onLongPress: () {
                          setState(() {
                            longPressed = true;
                          });
                        },
                        child: SizedBox(
                          width: 300,
                          child: longPressed
                              ? inputBox(index)
                              : index == nodes.length - 1
                                  ? inputBox(index)
                                  : Text(controllers[index].text),
                        ),
                      ),
                      Checkbox(
                        value: false,
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                    ],
                  );
                }),
          )
        ]));
  }

  inputBox(int index) {
    return TextField(
      controller: controllers[index],
      focusNode: nodes[index],
      decoration: InputDecoration(hintText: '입력'),
      onSubmitted: (value) {
        if (value.trim().isEmpty) {
          if (index == nodes.length - 1) {
            setState(() {
              fileds.removeAt(index);
              nodes.removeAt(index);
              controllers.removeAt(index);
            });
          }
        } else {
          addItemToList();
          nodes.last.requestFocus();
        }
      },
    );
  }
}
