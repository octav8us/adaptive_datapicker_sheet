// ignore_for_file: avoid_print

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
      
        primarySwatch: Colors.blue,
      ),
      home: const CustomCalendarPage(),
    );
  }
}


List req=[{"Month":"November","Year":"2030"}];
class CustomCalendarPage extends StatefulWidget {
  const CustomCalendarPage({Key? key}) : super(key: key);

  @override
  State<CustomCalendarPage> createState() => _CustomCalendarPageState();
}

class _CustomCalendarPageState extends State<CustomCalendarPage>
    with WidgetsBindingObserver {
 @override
int from=2000;
int to=2100;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                
                if(from!=null &&to!=null){
           var start=from;
          var end=to;
            if(int.parse(start.toString())<int.parse(end.toString())){
               for(var i=start;i<=end;i++){
              Generateyears.add(i.toString());
             }
            }
            else{
              for(var i=1990;i<=2050;i++){
              Generateyears.add(i.toString());
             }
            }
        }
        else if(from!=null &&to==null){
          var start=from;
         
             for(var i=start;i<=2050;i++){
              Generateyears.add(i.toString());
             }
        }
        else{
           for(var i=1990;i<=2050;i++){
              Generateyears.add(i.toString());
             }
        }
              WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCustomPicker();
    });
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
    PassValues:req,
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
      yearfrom: 2005,
      yearto: 2050,
      adapter:  PickerDataAdapter(
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
                for (int i = 0; i < Generateyears.length; i++)
                  PickerItem(
                      text: Center(
                        child: Text(
                          Generateyears[i],
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
