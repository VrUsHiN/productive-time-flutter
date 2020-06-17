import 'package:flutter/material.dart';
import 'package:productivetimeflutter/providers/items_provider.dart';
import 'package:productivetimeflutter/widgets/quote_container.dart';
import 'package:productivetimeflutter/widgets/target_picker.dart';
import 'package:productivetimeflutter/screens/secondary_screen.dart';
import 'package:productivetimeflutter/widgets/productive_time_item.dart';
import 'package:provider/provider.dart';

class FirstWidget extends StatelessWidget {
  final appBarHeight;

  FirstWidget(this.appBarHeight);

  @override
  Widget build(BuildContext context) {
    int shownItemIndex =
        (DateTime.now().hour - 1) == -1 ? 9999 : (DateTime.now().hour - 1);

    final defaultHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBarHeight -
        32.5;

    return RefreshIndicator(
      //Only works on listview or singlechildscrollview with always AlwaysScrollableScrollPhysics
      onRefresh: () async {
        await Provider.of<ItemsProvider>(context, listen: false)
            .fetchAndSetData();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        //necessary for the RefreshIndicator to work!
        child: Container(
          height: defaultHeight < 600 ? 600 : defaultHeight, //defaultHeight,
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          //color: Colors.orange,
          child: Column(
            mainAxisAlignment: shownItemIndex != 9999
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            children: <Widget>[
              if (defaultHeight < 550) SizedBox(height: 5),
              TargetPicker(),
              if (shownItemIndex == 9999)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.arrow_upward,
                        size: 50,
                      ),
                      Text(
                        'Set target for the new day!',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              if (defaultHeight < 550) SizedBox(height: 15),
              if (shownItemIndex != 9999)
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: FittedBox(
                              child: Text(
                            'How was your past hour?',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.headline5.color,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          )),
                        ),
                        FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          color: Theme.of(context)
                              .cardColor
                              .withOpacity(0.75), //Colors.green[50],
                          child: Text(
                            'More',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline5.color,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SecondaryScreen()));
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    ProductiveTimeItem(index: shownItemIndex),
                  ],
                ),
              if (defaultHeight < 550) SizedBox(height: 25),
              if (shownItemIndex != 9999) QuoteContainer(),
              if (defaultHeight < 550) SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
