import 'package:flutter_todo/elements.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

void main() {
  runApp(GetMaterialApp(
    theme: ThemeData(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  final List<Elements> elements = [];

  late bool addCheck;

  @override
  void initState() {
    super.initState();
    addCheck = false;
  }

  String str = '';
  int index = 0;

  void addItemToList(String group) {
    setState(() {
      elements.add(Elements(group));
      addCheck = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (addCheck) {
          if (elements.last.controller.text.trim().isEmpty) {
            setState(() {
              removeItem(elements.last);
            });
          }
          setState(() {
            addCheck = false;
          });
        } else {
          setState(() {
            longPressedCheck(elements.last);
          });
        }
      },
      child: Scaffold(
          drawer: Drawer(),
          appBar: AppBar(
            title: Text('$addCheck'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    setState(() {
                      index++;
                      addItemToList('목표$index');
                      setState(() {
                        elements.last.longPressed = true;
                      });
                      elements.last.node.requestFocus();
                    });
                  });
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          body: elements.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        '일반',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        child: Text('Add'),
                        onPressed: () {
                          if (elements.isEmpty) {
                            addItemToList('일반');
                            setState(() {
                              elements.last.longPressed = true;
                            });
                            elements.last.node.requestFocus();
                          } else if (elements.last.controller.text
                              .trim()
                              .isNotEmpty) {
                            setState(() {
                              elements.last.longPressed = false;
                            });
                            addItemToList('일반');
                            setState(() {
                              elements.last.longPressed = true;
                            });
                            elements.last.node.requestFocus();
                          }
                        },
                      ),
                    ],
                  ),
                )
              : GroupedListView<Elements, String>(
                  shrinkWrap: true,
                  elements: elements,
                  groupBy: (element) => element.group,
                  groupComparator: (value1, value2) => value2.compareTo(value1),
                  itemComparator: (item1, item2) =>
                      item1.name.compareTo(item2.name),
                  order: GroupedListOrder.ASC,
                  useStickyGroupSeparators: false,
                  groupSeparatorBuilder: (String value) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              child: Text('Add'),
                              onPressed: () {
                                if (elements.isEmpty) {
                                  addItemToList(value);
                                  setState(() {
                                    elements.last.longPressed = true;
                                  });
                                  elements.last.node.requestFocus();
                                } else if (elements.last.controller.text
                                    .trim()
                                    .isNotEmpty) {
                                  setState(() {
                                    elements.last.longPressed = false;
                                  });
                                  addItemToList(value);
                                  setState(() {
                                    elements.last.longPressed = true;
                                  });
                                  elements.last.node.requestFocus();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                  itemBuilder: (BuildContext context, Elements element) {
                    return Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: Checkbox(
                              value: element.checked,
                              onChanged: (value) {
                                setState(() {
                                  if (!element.longPressed) {
                                    element.checked = !element.checked;
                                  }
                                });
                              },
                            ),
                            title: element.longPressed
                                ? inputBox(element)
                                : Text(element.controller.text),
                            trailing: IconButton(
                                onPressed: () {
                                  Get.defaultDialog();
                                },
                                icon: Icon(Icons.more_horiz)),
                            onTap: () {
                              Get.defaultDialog();
                            },
                            onLongPress: () {
                              setState(() {
                                longPressedCheck(element);
                                element.longPressed = true;
                                element.node.requestFocus();
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  })),
    );
  }

  inputBox(Elements element) {
    return Focus(
      onFocusChange: (focus) {
        if (focus) {
          if (!addCheck) {
            setState(() {
              str = element.controller.text;
            });
          }
        }
        if (!focus) {
          if (!addCheck) {
            if (element.controller.text.trim().isEmpty) {
              setState(() {
                element.controller.text = str;
              });
            }
            setState(() {
              element.longPressed = false;
            });
          }
        }
      },
      child: TextField(
        controller: element.controller,
        focusNode: element.node,
        decoration: InputDecoration(
          hintText: '입력',
        ),
        onSubmitted: (value) {
          if (addCheck) {
            if (value.trim().isEmpty) {
              if (element == elements.last) {
                setState(() {
                  removeItem(element);
                  addCheck = false;
                });
              }
            } else {
              addItemToList(element.group);
              setState(() {
                addCheck = true;
                elements.last.longPressed = true;
              });
              elements.last.node.requestFocus();
            }
          }
          if (value.trim().isNotEmpty) {
            setState(() {
              element.longPressed = false;
            });
          }
        },
      ),
    );
  }

  removeItem(Elements element) {
    elements.remove(element);
  }

  longPressedCheck(Elements element) {
    int value = elements.indexOf(element);
    if (value != -1) {
      element.longPressed = false;
    }
  }
}
