import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:productivetimeflutter/providers/items_provider.dart';
import 'package:provider/provider.dart';

class ProductiveTimeItem extends StatelessWidget {
  final int index;

  ProductiveTimeItem({this.index});

  @override
  Widget build(BuildContext context) {

    final listItemText = index == 23
        ? 'Hours: $index:00 - 00:00'
        : 'Hours: $index:00 - ${index + 1}:00';

    return Consumer<ItemsProvider>(
      builder: (context, itemsData, child) => Container(
        height: 75,
        color: DateTime.now().hour == index
            ? Theme.of(context).primaryColorLight
            : Theme.of(context).cardColor.withOpacity(0.75),
        //Theme.of(context).primaryColorLight,//Colors.green[50],
        child: CheckboxListTile(
          title: Text(
            itemsData.isChecked(index)
                ? 'Productive Hour'
                : 'Unproductive Hour',
            style: TextStyle(
              color: itemsData.isChecked(index) ? Theme.of(context).textTheme.headline6.color : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            listItemText,
            style: TextStyle(
              color: itemsData.isChecked(index) ? Theme.of(context).textTheme.headline6.color : Colors.grey,
            ),
          ),
          value: itemsData.isChecked(index),
          onChanged: index > DateTime.now().hour
              ? (_) {
                  Fluttertoast.showToast(
                    msg: 'This action can\'t be performed only until future ',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              : (value) {
                  itemsData.toggleIsChecked(index);
                },
//              activeColor: Colors.lightGreen,
//              checkColor: Colors.white,
        ),
      ),
//        child: CheckboxListTile(
//          title: Text(
//            isChecked ? 'Productive Hour' : 'Unproductive Hour',
//            style: TextStyle(
//              color: isChecked ? Colors.black : Colors.grey,
//              fontWeight: FontWeight.bold,
//            ),
//          ),
//          subtitle: Text(
//            listItemText,
//            style: TextStyle(
//              color: isChecked ? Colors.black : Colors.grey,
//            ),
//          ),
//          value: isChecked,
//          onChanged: (value) {
//            onChanged(value);
//          },
//          activeColor: Colors.green,
//          checkColor: Colors.white,
//        ),
    );
  }
}
