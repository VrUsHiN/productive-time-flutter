import 'package:flutter/material.dart';
import 'package:productivetimeflutter/providers/items_provider.dart';
import 'package:productivetimeflutter/providers/theme_provider.dart';
import 'package:productivetimeflutter/widgets/productive_time_list.dart';
import 'package:productivetimeflutter/widgets/productivity_stats.dart';
import 'package:provider/provider.dart';

class SecondaryScreen extends StatefulWidget {

  @override
  _SecondaryScreenState createState() => _SecondaryScreenState();
}

class _SecondaryScreenState extends State<SecondaryScreen> {
  bool showChart = false;

  var _future;

  @override
  void initState() {
    super.initState();
    _future =
        Provider.of<ItemsProvider>(context, listen: false).fetchAndSetData();
  }

  @override
  Widget build(BuildContext context) {
    final targetMet = Provider.of<ItemsProvider>(context).isTargetMet();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,//Colors.green[100],
      appBar: AppBar(
        title: const Text('Productive Time',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
        actions: <Widget>[
          IconButton(
            icon: Stack(
              children: <Widget>[
                if (targetMet)
                  Icon(
                    Icons.check_circle,
                    size: 15,
                  ),
                Icon(Icons.show_chart, size: 34),
              ],
            ),
            tooltip: targetMet ? 'Target Met' : 'Target Yet to Meet',
            onPressed: () {
              setState(() {
                showChart = !showChart;
              });
            },
          ),
          PopupMenuButton<Color>(
            initialValue: Colors.blueGrey,
            tooltip: 'Themes',
            icon: Icon(
              Icons.more_vert,
              size: 28,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Default Theme'),value: Colors.blueGrey),
              PopupMenuItem(child: Text('Indigo Theme'),value: Colors.indigo),
              PopupMenuItem(child: Text('Amber Theme'),value: Colors.amber),
              PopupMenuItem(child: Text('Purple Theme'),value: Colors.purple),
            ],
            onSelected: (color) {
              Provider.of<ThemeProvider>(context,listen: false).setThemeSwatch(color);
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Stack(
                  children: <Widget>[
                    ProductiveTimeList(),
                    if (showChart)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showChart = false;
                          });
                        },
                        child: ProductivityStats(),
                      ),
                  ],
                );
          }),
    );
  }
}

//
