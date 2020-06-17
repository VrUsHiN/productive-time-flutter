import 'package:flutter/material.dart';
import 'package:productivetimeflutter/providers/items_provider.dart';
import 'package:productivetimeflutter/providers/theme_provider.dart';
import 'package:productivetimeflutter/widgets/first_widget.dart';
import 'package:productivetimeflutter/widgets/productivity_stats.dart';
import 'package:provider/provider.dart';

enum ThemesColors{
  //Green,
  //Orange,//
  //Red,
  //Blue,
  //Pink,
  Purple,//
  Amber,
  //Teal,//default?
  //DeepOrange,
  Indigo,
  BlueGrey,//def
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
    final _appBar = AppBar(
      title: const Text(
        'Productive Time',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
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
            PopupMenuItem(child: Text('Dark Theme'),value: Colors.black),
          ],
          onSelected: (color) {
            Provider.of<ThemeProvider>(context,listen: false).setThemeSwatch(color);
          },
        ),
      ],
    );

    final _appBarSize = _appBar.preferredSize.height;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight, //Colors.green[100],
      appBar: _appBar,
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    children: <Widget>[
                      FirstWidget(_appBarSize),
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
