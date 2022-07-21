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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCustomPicker();
    });
  }

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
                 _showCustomPicker();
              },
              child: const Text('show picker'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomPicker() {
    Picker(
      height: 192,
      
      itemExtent: 40,
      textScaleFactor: 0,
      squeeze: 1,
      builderHeader: (_)=> const SizedBox.shrink(),
      
      selectionOverlay: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Colors.black12,
              width: 1.0,
            ),
          ),
        ),
      ),
      onchanged: (req) {
        print("the req is : $req");
      },
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

    ).showModal(context);
  }
}
