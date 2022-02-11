// import 'dart:collection';

// import 'package:flutter_todo/src/elements.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/intl.dart';
// import 'package:table_calendar/table_calendar.dart';

// void main() {
//   initializeDateFormatting().then(
//     (_) => runApp(
//       GetMaterialApp(
//         theme: ThemeData(
//           splashColor: Colors.transparent,
//           hoverColor: Colors.transparent,
//           highlightColor: Colors.transparent,
//         ),
//         home: MyApp(),
//       ),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   _State createState() => _State();
// }

// class _State extends State<MyApp> {
//   List<Elements> selectedElements = [];
//   final List<Elements> elements = [];
//   late bool addCheck;
//   late DateTime pickDate;

//   @override
//   void initState() {
//     super.initState();
//     pickDate = DateTime.now();
//     addCheck = false;
//   }

//   String str = '';
//   int index = 0;
//   var kElements = LinkedHashMap<DateTime, List<Elements>>(
//     equals: isSameDay,
//     hashCode: getHashCode,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//         if (addCheck) {
//           if (selectedElements.last.controller.text.trim().isEmpty) {
//             setState(() {
//               removeItem(selectedElements.last);
//             });
//           }
//           setState(() {
//             addCheck = false;
//           });
//         } else {
//           setState(() {
//             longPressedCheck(selectedElements.last);
//           });
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('$addCheck'),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 for (var element in selectedElements) {
//                   element.node.unfocus();
//                 }
//                 setState(() {
//                   index++;
//                   addItemToList('목표$index', pickDate);
//                   addCheck = true;
//                   selectedElements.last.longPressed = true;
//                 });
//                 selectedElements.last.node.requestFocus();
//               },
//               icon: Icon(Icons.add),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               buildTableCalendar(),
//               makeEventsList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTableCalendar() {
//     return TableCalendar<Elements>(
//       locale: 'ko-KR',
//       firstDay: DateTime(2020),
//       lastDay: DateTime(2100),
//       focusedDay: pickDate,
//       headerStyle: HeaderStyle(
//         titleCentered: true,
//         titleTextFormatter: (date, locale) =>
//             DateFormat.yMMMMd(locale).format(date),
//         formatButtonVisible: false,
//         leftChevronIcon: Icon(
//           Icons.chevron_left,
//           color: Colors.black,
//         ),
//         rightChevronIcon: Icon(
//           Icons.chevron_right,
//           color: Colors.black,
//         ),
//       ),
//       calendarBuilders: CalendarBuilders(
//         dowBuilder: (context, day) {
//           return Center(
//             child: Text(
//               DateFormat.E('ko-KR').format(day),
//             ),
//           );
//         },
//         todayBuilder: (context, today, selectDay) {
//           return Padding(
//             padding: EdgeInsets.all(10),
//             child: Container(
//               decoration: BoxDecoration(
//                 border: today != pickDate
//                     ? Border.all(color: Colors.blueGrey)
//                     : Border.all(color: Colors.black),
//                 borderRadius: BorderRadius.circular(4.0),
//               ),
//               child: Center(
//                   child: Text(
//                 '${today.day}',
//               )),
//             ),
//           );
//         },
//         selectedBuilder: (context, selectDay, date) {
//           return Padding(
//             padding: EdgeInsets.all(10),
//             child: Container(
//               decoration: BoxDecoration(
//                 border:
//                     date == pickDate ? Border.all(color: Colors.black) : null,
//                 borderRadius: BorderRadius.circular(4.0),
//               ),
//               child: Center(
//                   child: Text(
//                 '${date.day}',
//               )),
//             ),
//           );
//         },
//         markerBuilder: (context, date, events) {
//           if (events.isNotEmpty) {
//             return Padding(
//               padding: EdgeInsets.all(10),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: events.length == 1
//                       ? Color(0xFFCDCCF7)
//                       : events.length == 2
//                           ? Color(0xFF8A89ED)
//                           : Color(0xFF5646D5),
//                   border:
//                       date == pickDate ? Border.all(color: Colors.black) : null,
//                   borderRadius: BorderRadius.circular(4.0),
//                 ),
//                 child: Center(
//                     child: Text(
//                   '${date.day}',
//                 )),
//               ),
//             );
//           }
//         },
//       ),
//       calendarFormat: CalendarFormat.month,
//       selectedDayPredicate: (day) => isSameDay(pickDate, day),
//       eventLoader: getEventsForDay,
//       startingDayOfWeek: StartingDayOfWeek.monday,
//       calendarStyle: CalendarStyle(
//         outsideDaysVisible: false,
//         markersAlignment: Alignment.topCenter,
//       ),
//       onDaySelected: (selectedDay, focusedDay) {
//         onDaySelected(selectedDay, focusedDay);
//       },
//       onPageChanged: (focusedDay) {
//         onDaySelected(focusedDay, focusedDay);
//       },
//     );
//   }

//   onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     setState(() {
//       pickDate = focusedDay;
//       pickDate = focusedDay;
//       selectedElements = getEventsForDay(selectedDay);
//     });
//   }

//   Widget makeEventsList() {
//     return GroupedListView<Elements, String>(
//       shrinkWrap: true,
//       elements: selectedElements,
//       groupBy: (element) => element.group,
//       groupComparator: (value1, value2) => value2.compareTo(value1),
//       itemComparator: (item1, item2) => item1.name.compareTo(item2.name),
//       order: GroupedListOrder.ASC,
//       useStickyGroupSeparators: false,
//       groupSeparatorBuilder: (String value) => Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             Text(
//               value,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             ElevatedButton(
//               child: Text('Add'),
//               onPressed: () {
//                 setState(() {
//                   addCheck = true;
//                 });
//                 if (selectedElements.isEmpty) {
//                   addItemToList(value, pickDate);
//                   setState(() {
//                     selectedElements.last.longPressed = true;
//                   });
//                   selectedElements.last.node.requestFocus();
//                 } else if (selectedElements.last.controller.text
//                     .trim()
//                     .isNotEmpty) {
//                   setState(() {
//                     selectedElements.last.longPressed = false;
//                   });
//                   addItemToList(value, pickDate);
//                   setState(() {
//                     selectedElements.last.longPressed = true;
//                   });
//                   selectedElements.last.node.requestFocus();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//       itemBuilder: (BuildContext context, Elements element) {
//         return Row(
//           children: [
//             Expanded(
//               child: ListTile(
//                 leading: Checkbox(
//                   value: element.checked,
//                   onChanged: (value) {
//                     setState(() {
//                       if (!element.longPressed) {
//                         element.checked = !element.checked;
//                       }
//                     });
//                   },
//                 ),
//                 title: element.longPressed
//                     ? inputBox(element)
//                     : Text(element.controller.text),
//                 trailing: IconButton(
//                     onPressed: () {
//                       Get.defaultDialog();
//                     },
//                     icon: Icon(Icons.more_horiz)),
//                 onTap: () {
//                   Get.defaultDialog();
//                 },
//                 onLongPress: () {
//                   setState(() {
//                     longPressedCheck(element);
//                     element.longPressed = true;
//                     element.node.requestFocus();
//                   });
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   List<Elements> getEventsForDay(DateTime day) {
//     selectedElements =
//         elements.where((element) => element.dateTime == pickDate).toList();

//     kElements.addAll({
//       for (var element in selectedElements) element.dateTime: selectedElements
//     });
//     return kElements[day] ?? [];
//   }

//   inputBox(Elements element) {
//     return Focus(
//       onFocusChange: (focus) {
//         if (focus) {
//           if (!addCheck) {
//             setState(() {
//               str = element.controller.text;
//             });
//           }
//         }
//         if (!focus) {
//           if (!addCheck) {
//             if (element.controller.text.trim().isEmpty) {
//               setState(() {
//                 element.controller.text = str;
//               });
//             }
//             setState(() {
//               element.longPressed = false;
//             });
//           }
//         }
//       },
//       child: TextField(
//         controller: element.controller,
//         focusNode: element.node,
//         decoration: InputDecoration(
//           hintText: '입력',
//         ),
//         onSubmitted: (value) {
//           if (addCheck) {
//             if (value.trim().isEmpty) {
//               if (element == selectedElements.last) {
//                 setState(() {
//                   removeItem(element);
//                   addCheck = false;
//                 });
//               }
//             } else {
//               addItemToList(element.group, pickDate);
//               setState(() {
//                 addCheck = true;
//                 selectedElements.last.longPressed = true;
//               });
//               selectedElements.last.node.requestFocus();
//             }
//           }
//           if (value.trim().isNotEmpty) {
//             setState(() {
//               element.longPressed = false;
//             });
//           }
//         },
//       ),
//     );
//   }

//   removeItem(Elements element) {
//     selectedElements.remove(element);
//     elements.remove(element);
//   }

//   longPressedCheck(Elements element) {
//     int value = selectedElements.indexOf(element);
//     if (value != -1) {
//       element.longPressed = false;
//     }
//   }

//   addItemToList(String group, DateTime dateTime) {
//     selectedElements.add(Elements(group, dateTime));
//     elements.add(Elements(group, dateTime));
//   }
// }
