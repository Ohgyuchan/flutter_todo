import 'package:get/get.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const GetMaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  final List<TextEditingController> controllers = <TextEditingController>[];
  final List<TextField> fileds = [];
  final List<FocusNode> nodes = [];
  final List<bool> longPresseds = [];
  final List<bool> checkeds = [];
  var addCheck = false;
  String str = '';

  void addItemToList() {
    setState(() {
      addCheck = true;
      fileds.add(TextField());
      nodes.add(FocusNode());
      controllers.add(TextEditingController());
      longPresseds.add(false);
      checkeds.add(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          if (addCheck) {
            if (controllers.last.text.trim().isEmpty) {
              fileds.removeLast();
              nodes.removeLast();
              controllers.removeLast();
              longPresseds.removeLast();
              checkeds.removeLast();
            }
          }
          int value = longPresseds.indexOf(true);
          if (value != -1) {
            longPresseds[longPresseds.indexOf(true)] = false;
          }
          addCheck = false;
        });
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('$addCheck'),
          ),
          body: Column(children: <Widget>[
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                if (fileds.isEmpty) {
                  addItemToList();
                  setState(() {
                    longPresseds.last = true;
                  });
                  nodes.last.requestFocus();
                } else if (controllers.last.text.trim().isNotEmpty) {
                  setState(() {
                    longPresseds.last = false;
                  });
                  addItemToList();
                  setState(() {
                    longPresseds.last = true;
                  });
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
                    return GestureDetector(
                      onTap: () {
                        Get.defaultDialog();
                      },
                      onLongPress: () {
                        setState(() {
                          int value = longPresseds.indexOf(true);
                          if (value != -1) {
                            longPresseds[longPresseds.indexOf(true)] = false;
                          }
                          longPresseds[index] = true;
                          nodes[index].requestFocus();
                        });
                      },
                      child: SizedBox(
                        width: 300,
                        child: longPresseds[index]
                            ? inputBox(index)
                            : Text(controllers[index].text),
                      ),
                    );
                  }),
            )
          ])),
    );
  }

  inputBox(int index) {
    return Focus(
      onFocusChange: (focus) {
        if (focus) {
          if (!addCheck) {
            setState(() {
              str = controllers[index].text;
            });
          }
        }
        if (!focus) {
          if (!addCheck) {
            if (controllers[index].text.trim().isEmpty) {
              setState(() {
                controllers[index].text = str;
              });
            }
          }
          setState(() {
            longPresseds[index] = false;
          });
        }
      },
      child: TextField(
        controller: controllers[index],
        focusNode: nodes[index],
        decoration: InputDecoration(
          hintText: '입력',
          prefixIcon: Checkbox(
            value: checkeds[index],
            onChanged: (value) {
              setState(() {
                checkeds[index] = !checkeds[index];
              });
            },
          ),
          suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.more)),
        ),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            setState(() {
              longPresseds[index] = false;
            });
            if (addCheck) {
              if (value.trim().isEmpty) {
                if (index == nodes.length - 1) {
                  setState(() {
                    addCheck = false;
                    fileds.removeAt(index);
                    nodes.removeAt(index);
                    controllers.removeAt(index);
                    longPresseds.removeAt(index);
                    checkeds.removeAt(index);
                  });
                }
              } else {
                addItemToList();
                setState(() {
                  longPresseds.last = true;
                });
                nodes.last.requestFocus();
              }
            } else {
              nodes[index].unfocus();
            }
          }
          addCheck = false;
        },
      ),
    );
  }
}
