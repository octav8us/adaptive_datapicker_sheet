// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_if_null_operators, prefer_const_constructors, unnecessary_this, prefer_is_empty, unnecessary_null_comparison, curly_braces_in_flow_control_structures, non_constant_identifier_names, constant_identifier_names, no_logic_in_create_state, sort_child_properties_last, duplicate_ignore, prefer_conditional_assignment, unused_local_variable, avoid_returning_null_for_void, prefer_is_not_operator, avoid_print


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:jiffy/jiffy.dart';


  int ind=0;
      int index=0;
  final List<dynamic>months = [
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
  List<dynamic> Generateyears = [];

typedef Pickerset = void Function(
  Map<dynamic,dynamic> index);


typedef PickerWidgetBuilder = Widget Function(
    BuildContext context, Widget pickerWidget);

typedef PickerItemBuilder = Widget? Function(BuildContext context, String? text,
    Widget? child, bool selected, int col, int index);

class Picker {
  static const double DefaultTextSize = 18.0;
late List<int> selecteds;
late PickerAdapter adapter;
final List<PickerDelimiter>? delimiter;
final VoidCallback? onCancel;

  final Pickerset? onchanged;
  
  final int? yearfrom;
  final int? yearto;
  
final List<int>? columnFlex;
final Widget? title;
 
  final double height;
final double itemExtent;
 TextStyle? textStyle,
      cancelTextStyle,
      confirmTextStyle,
      selectedTextStyle;
  final TextAlign textAlign;
  final IconThemeData? selectedIconTheme;
 double? textScaleFactor;
final EdgeInsetsGeometry? columnPadding;
  final Color? backgroundColor, headerColor, containerColor;
final bool hideHeader;
final bool reversedOrder;
final WidgetBuilder? builderHeader;
final PickerItemBuilder? onBuilderItem;
final List PassValues;
final int smooth;
final Widget? footer;
final Widget selectionOverlay;
final Decoration? headerDecoration;

  final double magnification;
  final double diameterRatio;
  final double squeeze;
  
  Widget? _widget;
  PickerWidgetState? _state;
  
  Picker( 
      {required this.adapter,
      this.delimiter,
      List<int>? selecteds,
      this.height = 150.0,
      this.itemExtent = 28.0,
      this.columnPadding,
      this.textStyle,
      this.cancelTextStyle,
      this.confirmTextStyle,
      this.selectedTextStyle,
      this.selectedIconTheme,
      this.textAlign = TextAlign.start,
      this.textScaleFactor,
      this.title,
      this.backgroundColor = Colors.white,
      this.containerColor,
      this.headerColor,
      this.builderHeader,
      this.hideHeader = false,
     this.reversedOrder = false,
      this.headerDecoration,
      this.columnFlex,
      this.footer,
      this.smooth = 0,
      this.magnification = 1.0,
      this.diameterRatio = 1.1,
      this.squeeze = 1.45,
      this.selectionOverlay = const CupertinoPickerDefaultSelectionOverlay(),
      this.onBuilderItem,
      this.onCancel,
      this.onchanged,
      this.yearfrom,this.yearto,required this.PassValues
      } ) {
      
        
    this.selecteds = selecteds == null ? <int>[] : selecteds;
  }
  
  Widget? get widget => _widget;
  PickerWidgetState? get state => _state;
  int _maxLevel = 1;
  
  Widget makePicker([ThemeData? themeData, bool isModal = false, Key? key]) {
     
    _maxLevel = adapter.maxLevel;
    
    adapter.picker = this;
    
    adapter.initSelects();
    _widget = PickerWidget(

      key: key ?? ValueKey(this),
      // ignore: sort_child_properties_last
      child:
          _PickerWidget(picker: this, themeData: themeData, isModal: isModal),
      data: this,
    );
    return _widget!;
  }

  

  

  /// Display modal picker
  Future<T?> showModal<T>(BuildContext context,
      {ThemeData? themeData,
      bool isScrollControlled = false,
      bool useRootNavigator = false,
      Color? backgroundColor,
      PickerWidgetBuilder? builder}) async {
         
       
    return await showModalBottomSheet<T>(
            
        context: context, //state.context,
         shape: const RoundedRectangleBorder( // <-- SEE HERE
          borderRadius: BorderRadius.vertical( 
            top: Radius.circular(25.0),
          ),
        ), 
        isScrollControlled: isScrollControlled,
        useRootNavigator: useRootNavigator,
        backgroundColor: backgroundColor,
        builder: (BuildContext context) {

            final picker = makePicker(themeData, true);
            
          return builder == null ? picker : builder(context, picker);
         
        });
  }
}


class PickerDelimiter {
  final Widget? child;
  final int column;
  PickerDelimiter({required this.child, this.column = 1});
}
class PickerItem<T> {
 final Widget? text;
final T? value;
final List<PickerItem<T>>? children;
PickerItem({this.text, this.value, this.children});
}

class PickerWidget<T> extends InheritedWidget {
  final Picker data;
  const PickerWidget({Key? key, required this.data, required Widget child})
      : super(key: key, child: child);
  @override
  bool updateShouldNotify(covariant PickerWidget oldWidget) =>
      oldWidget.data != data;

  static PickerWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PickerWidget>()
        as PickerWidget;
  }
}

class _PickerWidget<T> extends StatefulWidget {
  final Picker picker;
  final ThemeData? themeData;
  final bool isModal;
 const _PickerWidget(
      {Key? key, required this.picker, this.themeData, required this.isModal})
      : super(key: key);

  @override
  PickerWidgetState createState() =>
      PickerWidgetState<T>(picker: this.picker, themeData: this.themeData);
}

class PickerWidgetState<T> extends State<_PickerWidget> {
  final Picker picker;
  final ThemeData? themeData;
  PickerWidgetState({required this.picker, this.themeData});

  ThemeData? theme;
  final List<FixedExtentScrollController> scrollController = [];
  final List<StateSetter?> _keys = [];

  @override
  void initState() {
    super.initState();
     picker._state = this;
   
    if (scrollController.length == 0) {
      
      for (int i = 0; i < picker._maxLevel; i++) {
        scrollController
            .add(FixedExtentScrollController(initialItem: picker.selecteds[i]));
        _keys.add(null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    theme = themeData ?? Theme.of(context);

    if (_wait && picker.smooth > 0) {
      Future.delayed(Duration(milliseconds: picker.smooth), () {
        if (!_wait) return;
        setState(() {
          _wait = false;
        });
      });
    } else
    {
     setState(() {
        _wait = false;
      });
    }
     

    final _body = <Widget>[];
    
    if (!picker.hideHeader) {
     
      if (picker.builderHeader != null) {
         
        _body.add(picker.headerDecoration == null
            ? 
            picker.builderHeader!(context)
            : DecoratedBox(
                child: picker.builderHeader!(context),
                decoration: picker.headerDecoration!));
      } 
    }
List<Widget> _buildViews() {
    if (theme == null) theme = Theme.of(context);
    for (int j = 0; j < _keys.length; j++) _keys[j] = null;
List<Widget> items = [];
    PickerAdapter? adapter = picker.adapter;
    adapter.setColumn(-1);

    if (adapter.length > 0) {
      var _decoration = BoxDecoration(
        color: picker.containerColor == null
            ? theme!.dialogBackgroundColor
            : picker.containerColor
            
      );

      for (int i = 0; i < picker._maxLevel; i++) {
        Widget view = Expanded(
          flex: adapter.getColumnFlex(i),
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            height: picker.height-20,
           
            child: _wait
                ? null
                : StatefulBuilder(
                    builder: (context, state) {
                      _keys[i] = state;
                      adapter.setColumn(i - 1);
                      

                      // 上一次是空列表
                      final _lastIsEmpty = scrollController[i].hasClients &&
                          !scrollController[i].position.hasContentDimensions;

                      final _length = adapter.length;
                      final _view = _buildCupertinoPicker(context, i, _length,
                          adapter, _lastIsEmpty ? ValueKey(_length) : null);

                      if (_lastIsEmpty ||
                          (
                              picker.selecteds[i] >= _length)) {
                                
                        Timer(Duration(milliseconds: 100), () {
                          if (!this.mounted) return;
                          
                          var _len = adapter.length;
                          var _index = (_len < _length ? _len : _length) - 1;
                          if (scrollController[i]
                              .position
                              .hasContentDimensions) {
                           
                                
                            scrollController[i].jumpToItem(_index);
                          } else {
                           
                            scrollController[i] = FixedExtentScrollController(
                                initialItem: _index);
                            if (_keys[i] != null) {
                              _keys[i]!(() => null);
                            }
                          }
                        });
                      }

                      return _view;
                    },
                  ),
          ),
        );
        items.add(view);
      }
    }
     return items;
  }
    _body.add(_wait
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildViews(),
          )
        : AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _buildViews(),
            ),
          ));

    if (picker.footer != null) _body.add(picker.footer!);
    Widget v = Column(
      mainAxisSize: MainAxisSize.min,
      children: _body,
    );
   
    return v;
  }
bool _wait = true;
  final Map<int, int> lastData = {};
Widget _buildCupertinoPicker(BuildContext context,
      int i, int _length, PickerAdapter adapter, Key? key) {
    return CupertinoPicker.builder(
      
      key: key,
      backgroundColor: Colors.transparent,
      scrollController: scrollController[i],
      itemExtent: picker.itemExtent,
       magnification: picker.magnification,
      diameterRatio: picker.diameterRatio,
      squeeze: picker.squeeze,
      selectionOverlay: picker.selectionOverlay,
      childCount:  200,
      itemBuilder: (context, index) {
        adapter.setColumn(i-1);
        return adapter.buildItem(context, index % _length);
      },
      onSelectedItemChanged: (int _ind) {
        if (_length <= 0) return;
        var _index = _ind % _length;
        if(i==0){
          ind=_index;
          Map<dynamic,dynamic> req={"Month":months[_index],"Year":Generateyears[index]};
           picker.onchanged!(req);
        }
        else{
          index=_index;
          Map<dynamic,dynamic> req={"Month":months[ind],"Year":Generateyears[_index]};
           picker.onchanged!(req);
        }
       },
    );
  }
}

/// 选择器数据适配器
abstract class PickerAdapter<T> {
  
  Picker? picker;

  int getLength();
  int getMaxLevel();
  void setColumn(int index);
  void initSelects();
  Widget buildItem(BuildContext context, int index);

  

  Widget makeText(Widget? child, String? text, bool isSel) {
    return Center(
        child: DefaultTextStyle(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: picker!.textAlign,
            style: picker!.textStyle ??
                TextStyle(
                    color: Colors.black87,
                    fontFamily: picker?.state?.context != null
                        ? Theme.of(picker!.state!.context)
                            .textTheme
                            .headline6!
                            .fontFamily
                        : "",
                    fontSize: Picker.DefaultTextSize),
            child: child != null
                ? (isSel && picker!.selectedIconTheme != null
                    ? IconTheme(
                        data: picker!.selectedIconTheme!,
                        child: child,
                      )
                    : child)
                : Text(text ?? "",
                    textScaleFactor: picker!.textScaleFactor,
                    style: (isSel ? picker!.selectedTextStyle : null))));
  }

  Widget makeTextEx(
      Widget? child, String text, Widget? postfix, Widget? suffix, bool isSel) {
    List<Widget> items = [];
    if (postfix != null) items.add(postfix);
    items.add(
        child ?? Text(text, style: (isSel ? picker!.selectedTextStyle : null)));
    if (suffix != null) items.add(suffix);

    Color? _txtColor = Colors.black87;
    double? _txtSize = Picker.DefaultTextSize;
    if (isSel && picker!.selectedTextStyle != null) {
      if (picker!.selectedTextStyle!.color != null)
       {
         _txtColor = picker!.selectedTextStyle!.color;
       }
      if (picker!.selectedTextStyle!.fontSize != null)
        {
          _txtSize = picker!.selectedTextStyle!.fontSize;
        }
    }

    // ignore: unnecessary_new
    return new Center(
        //alignment: Alignment.center,
        child: DefaultTextStyle(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: picker!.textAlign,
            style: picker!.textStyle ??
                TextStyle(color: _txtColor, fontSize: _txtSize),
            child: Wrap(
              children: items,
            )));
  }

 

  int getColumnFlex(int column) {
    if (picker!.columnFlex != null && column < picker!.columnFlex!.length)
      {
        return picker!.columnFlex![column];
      }
    return 1;
  }

  int get maxLevel => getMaxLevel();

 
  int get length => getLength();

  

  
}

/// 数据适配器
class PickerDataAdapter<T> extends PickerAdapter<T> {
  
  List<PickerItem<T>>? data;
  List<PickerItem<dynamic>>? _datas;
  int _maxLevel = -1;
  int _col = 0;
  final bool isArray;

  PickerDataAdapter(
      {List? pickerdata, List<PickerItem<T>>? data, this.isArray = false}) {
        
        
        
    this.data = data ?? <PickerItem<T>>[];
     
    _parseData(pickerdata);
  }

  
  void _parseData(List? pickerData) {
    
    if (pickerData != null && pickerData.length > 0 && (data!.length == 0)) {
      if (isArray) {
        _parseArrayPickerDataItem(pickerData, data!);
      } else {
        _parsePickerDataItem(pickerData, data!);
      }
    }
    
  }

  _parseArrayPickerDataItem(List? pickerData, List<PickerItem> data) {
    if (pickerData == null) return;
    var len = pickerData.length;
    for (int i = 0; i < len; i++) {
      var v = pickerData[i];
      if (!(v is List)) continue;
      List lv = v;
      if (lv.length == 0) continue;

      PickerItem item = PickerItem<T>(children: <PickerItem<T>>[]);
      data.add(item);

      for (int j = 0; j < lv.length; j++) {
        var o = lv[j];
        if (o is T) {
          item.children!.add(PickerItem<T>(value: o));
        } else if (T == String) {
          String _v = o.toString();
          item.children!.add(PickerItem<T>(value: _v as T));
        }
      }
    }
    
  }

  _parsePickerDataItem(List? pickerData, List<PickerItem> data) {
    
    if (pickerData == null) return;
    var len = pickerData.length;
    for (int i = 0; i < len; i++) {
      var item = pickerData[i];
      if (item is T) {
        data.add(PickerItem<T>(value: item));
      } else if (item is Map) {
        final Map map = item;
        if (map.length == 0) continue;

        List<T> _mapList = map.keys.toList().cast();
        for (int j = 0; j < _mapList.length; j++) {
          var _o = map[_mapList[j]];
          if (_o is List && _o.length > 0) {
            List<PickerItem<T>> _children = <PickerItem<T>>[];
            
            data.add(PickerItem<T>(value: _mapList[j], children: _children));
            _parsePickerDataItem(_o, _children);
          }
        }
      } else if (T == String && (item is List)) {
        String _v = item.toString();
        
        data.add(PickerItem<T>(value: _v as T));
      }
    }
  }

  @override
  void setColumn(int index) {
    if (_datas != null && _col == index + 1) return;
    _col = index + 1;
    if (isArray) {
      
      if (_col < data!.length)
        {
          _datas = data![_col].children;
        }
      else
        {
          _datas = null;
        }
      return;
    }
    if (index < 0) {
      _datas = data;
    } else {
      _datas = data;
      // 列数过多会有性能问题
      for (int i = 0; i <= index; i++) {
        var j = picker!.selecteds[i];
        if (_datas != null && _datas!.length > j)
          {
            _datas = _datas![j].children;
          }
        else {
          _datas = null;
          break;
        }
      }
    }
  }

  @override
  int getLength() => _datas?.length ?? 0;

  @override
  getMaxLevel() {
    
   if (_maxLevel == -1) _checkPickerDataLevel(data, 1);
    return _maxLevel;
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    final PickerItem item = _datas![index];
    final isSel = index == picker!.selecteds[_col];
    if (picker!.onBuilderItem != null) {
      final _v = picker!.onBuilderItem!(
          context, item.value.toString(), item.text, isSel, _col, index);
      if (_v != null) return _v;
    }
    if (item.text != null) {
      return isSel && picker!.selectedTextStyle != null
          ? DefaultTextStyle(
              style: picker!.selectedTextStyle!,
              child: picker!.selectedIconTheme != null
                  ? IconTheme(
                      data: picker!.selectedIconTheme!,
                      child: item.text!,
                    )
                  : item.text!)
          : item.text!;
    }
    return makeText(
        item.text, item.text != null ? null : item.value.toString(), isSel);
  }

  @override
  void initSelects() {
    
    
    if (picker!.selecteds == null){
      
      
       picker!.selecteds = <int>[];
    }
    if(picker!.selecteds.length == 0) {
      if(picker!.PassValues!=null){
        
      
      for(int i=0;i<months.length;i++){
        if(months[i]==picker!.PassValues[0]["Month"]){
          
           picker!.selecteds.add(i);
           ind=i;
        }
      }
      for(int j=0;j<Generateyears.length;j++){
        if(picker!.PassValues[0]["Year"].toString()==Generateyears[j].toString()){
          
          index=j;
          picker!.selecteds.add(j);
        }
      }
      picker?.onchanged!({"Month":months[ind],"Year":Generateyears[index]});
      }
       else{
        print("the getter value is : ${picker!.PassValues}");
        final DateTime now = DateTime.now();
      
      var y=Jiffy(now,"yyyy-mm-dd hh:mm:ssZ").format("yyyy");
      var m=Jiffy(now,"yyyy-mm-dd hh:mm:ssZ").format("MMMM");
      
      int ind=0;
      int index=0;
      for(int i=0;i<months.length;i++){
        
        if(months[i]==m){
          
           picker!.selecteds.add(i);
           ind=i;
           
        }
        
      }
      for(int j=0;j<Generateyears.length;j++){
        if(y.toString()==Generateyears[j]){
          index=j;
          picker!.selecteds.add(j);
        }
      }
       picker?.onchanged!({"Month":months[ind],"Year":Generateyears[index]});
       }
     
      for (int i = 0; i < 2; i++) picker!.selecteds.add(1);
    }
  }

  

  _checkPickerDataLevel(List<PickerItem>? data, int level) {
    
    if (data == null) return;
    if (isArray) {
      
      _maxLevel = data.length;
      return;
    }
    
    for (int i = 0; i < data.length; i++) {
      if (data[i].children != null && data[i].children!.length > 0) 

        _checkPickerDataLevel(data[i].children, level + 1);
    }
    if (_maxLevel < level) _maxLevel = level;
  }
}

