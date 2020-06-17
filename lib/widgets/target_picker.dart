import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivetimeflutter/providers/items_provider.dart';
import 'package:provider/provider.dart';

class TargetPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsProvider>(
      builder: (_, itemsData, child) => Container(
//              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: 'Productivity Target: ',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.headline6.color,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' ${itemsData.prodTarget} hrs. ',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      //color: Theme.of(context).textTheme.headline5.color,
                      backgroundColor: Theme.of(context).cardColor.withOpacity(0.75),//Colors.green[50],
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.75),//Colors.green[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Slider.adaptive(
                min: 0,
                max: 24,
                //divisions: 24,
                label: 'Hrs.',
                value: itemsData.prodTarget.toDouble(),
                onChanged: (newVal) {
                  itemsData.updateTarget(newVal.toInt());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
