import 'package:flutter/material.dart';
import 'package:productivetimeflutter/providers/items_provider.dart';
import 'package:provider/provider.dart';

const sizedBox = SizedBox(
  height: 10,
  width: double.infinity,
);

class ProductivityStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final statsStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      backgroundColor: Theme.of(context).primaryColor,
    );

    Widget _buildStatsData(String textToShow) {
      return FittedBox(
        child: Text(
          textToShow,
          style: statsStyle,
        ),
      );
    }

    return Container(
      color: Colors.black.withOpacity(0.7),
      padding: const EdgeInsets.all(8.0),
      child: Consumer<ItemsProvider>(
        builder: (context, itemsData, child) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildStatsData(
                ' Total Productive Hours: ${itemsData.totalProductiveItems}/24 '),
            sizedBox,
            _buildStatsData(' Most Productive Period: ${itemsData.mostProductiveTime} '),
            sizedBox,
            _buildStatsData(' Target Status: ' +
                (itemsData.totalProductiveItems >= itemsData.prodTarget ? 'Met ' : 'Not Met ')),
          ],
        ),
      ),
    );
  }
}
