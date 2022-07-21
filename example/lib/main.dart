

import 'package:adaptive_date_picker/adaptive_date_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const CustomCalendarPage(),
    );
  }
}



class CustomCalendarPage extends StatefulWidget {
  const CustomCalendarPage({Key? key}) : super(key: key);

  @override
  State<CustomCalendarPage> createState() => _CustomCalendarPageState();
}

class _CustomCalendarPageState extends State<CustomCalendarPage>
    with WidgetsBindingObserver {
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final List<String> years = [
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
  ];

  @override
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // buildPicker();
                 showPickerDateTimeRoundBg(context);
              },
              child: const Text('show picker'),
            ),
          ],
        ),
      ),
    );
  }

  showPickerDateTimeRoundBg(BuildContext context) {
    var picker = Picker(
      height: 192,
        backgroundColor: Colors.transparent,
        headerDecoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black12))),
                selectionOverlay: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Colors.black12,
             
            ),
          ),
        ),
      ),
        adapter: PickerDataAdapter(
        data: [
          for (int i = 0; i < months.length; i++)
            PickerItem(
              text: Center(
                child: Text(
                  months[i],
                  textAlign: TextAlign.right,
                ),
              ),
              value: i,
              children: [
                for (int i = 0; i < years.length; i++)
                  PickerItem(
                      text: Center(
                        child: Text(
                          years[i],
                          textAlign: TextAlign.left,
                        ),
                      ),
                      value: i),
              ],
            ),
        ],
      ),
        delimiter: [
          PickerDelimiter(
              column: 3,
              child: Container(
                width: 8.0,
                alignment: Alignment.center,
              )),
          PickerDelimiter(
              column: 5,
              child: Container(
                width: 12.0,
                alignment: Alignment.center,
                child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
                color: Colors.white,
              )),
        ],
        
        onConfirm: (Picker picker, List value) {
          print("priits : ${picker.adapter.text}");
        },
        onSelect: (Picker picker, int index, List<int> selected) {
         
        });
    picker.showModal(context, backgroundColor: Colors.transparent,
        builder: (context, view) {
      return Material(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Container(
            padding: const EdgeInsets.only(top: 14,left:5,right:5),
            child: view,
          ));
    });
  }
}
