import 'package:flutter/material.dart';
import 'package:productivetimeflutter/models/item.dart';
import 'package:productivetimeflutter/helpers/db_helper.dart';
import 'dart:async';

class ItemsProvider with ChangeNotifier {
  List<Item> _items =
      List.generate(TimeOfDay.hoursPerDay, (index) => Item(false));
  int _prodTarget = 8;
  Timer timer;

  bool isTargetMet(){
    return totalProductiveItems>=_prodTarget;
  }

//  ItemsProvider() {
//    timer = Timer.periodic(
//        //Duration(seconds: 5),
//        Duration(
//          hours: (23 - DateTime.now().hour),
//          minutes: (59 - DateTime.now().minute),
//          seconds: (59 - DateTime.now().second),
//        ),
//        (Timer t)  {print(timer.isActive);fetchAndSetPlaces().then((value) => print('Yoo'));});
//    print(timer.isActive);
//  }

  Future<void> fetchAndSetData() async {
    DBHelper.initialiseDatabase(); //
    final dataList = await DBHelper.getData('user_items');
    _items = dataList
        .map((element) => Item(element['isChecked'] == 0 ? false : true))
        .toList();
    final targetList = await DBHelper.getData('user_target');
    _prodTarget = targetList[0]['target'];
    //print(targetList);
    notifyListeners();
  }

  List<Item> get items => [..._items];

  int get prodTarget => _prodTarget;

  void updateTarget(int newVal) {
    _prodTarget = newVal;
    notifyListeners();
    DBHelper.update(
      'user_target',
      {'target': newVal},
      'none',
    );
  }

  void toggleIsChecked(int index) {
    _items[index].isChecked = !_items[index].isChecked;
    notifyListeners();
    DBHelper.update(
      'user_items',
      {
        'id': index.toString(),
        'isChecked': _items[index].isChecked ? 1 : 0,
      },
      index.toString(),
    );
  }

  bool isChecked(int index) {
    return _items[index].isChecked;
  }

  int get totalProductiveItems {
    int count = 0;
    for (Item x in _items) {
      if (x.isChecked) {
        count++;
      }
    }
    return count;
  }

  //http://www.learnersdictionary.com/qa/parts-of-the-day-early-morning-late-morning-etc

  String get mostProductiveTime {
    int morning = 0;
    int afternoon = 0;
    int evening = 0;
    int night = 0;
    for (int i = 5; i < 12; i++) {
      if (_items[i].isChecked) morning++;
    }
    for (int i = 12; i < 17; i++) {
      if (_items[i].isChecked) afternoon++;
    }
    for (int i = 17; i < 21; i++) {
      if (_items[i].isChecked) evening++;
    }
    for (int i = 21; i < 24; i++) {
      if (_items[i].isChecked) night++;
    }
    for (int i = 0; i < 5; i++) {
      if (_items[i].isChecked) night++;
    }

    if(morning>afternoon && morning>evening && morning>night){
      return 'Morning ($morning hours)';
    }
    else if(afternoon>morning && afternoon>evening && afternoon>night){
      return 'Afternoon ($afternoon hours)';
    }
    else if(evening>morning && evening>afternoon && evening>night){
      return 'Evening ($evening hours)';
    }
    else if(night>morning && night>evening && night>afternoon){
      return 'Night ($night hours)';
    }
    else{
      return '-';
    }

//    if (morning > evening) {
//      return 'Morning ($morning hours)';
//    } else if (morning == evening) {
//      return '$morning hours equally';
//    } else {
//      return 'Evening ($evening hours)';
//    }
  }
}
