import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivetimeflutter/providers/items_provider.dart';
import 'package:productivetimeflutter/widgets/productive_time_item.dart';
import 'package:provider/provider.dart';

class ProductiveTimeList extends StatefulWidget {
//  final appBarHeight;
//
//  ProductiveTimeList(this.appBarHeight);

  @override
  _ProductiveTimeListState createState() => _ProductiveTimeListState();
}

class _ProductiveTimeListState extends State<ProductiveTimeList> {

//  ScrollController _scrollController;
//  bool scroll;

  @override
  void initState() {
//    _scrollController = ScrollController();
//    scroll = true;
    super.initState();
//    WidgetsBinding.instance.addPostFrameCallback((_) {
//      //print('hi');
//      _scrollFunction();
//    }); //Run method on Widget build complete
  }

//  void _scrollFunction() {
//    //print('hello');
//    if (_scrollController.hasClients && scroll) {
//      int i = DateTime
//          .now()
//          .hour;
//      double position = (24* 75.0 + 24* 5.0) - i * 75.0 + i * 5.0 - 25;//i * 75.0 + i * 5.0 - 25;
//      //_scrollController.jumpTo(position);
//      _scrollController.animateTo(
//        position > _scrollController.position.maxScrollExtent
//            ? _scrollController.position.maxScrollExtent
//            : (position < _scrollController.position.minScrollExtent
//            ? _scrollController.position.minScrollExtent
//            : position),
//        duration: Duration(microseconds: 1,),
//        curve: Curves.linear,
//      );
//      scroll = false;
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<ItemsProvider>(context, listen: false)
              .fetchAndSetData();
        },
        child: ListView.separated(
          itemBuilder: (context, index) {
            return ProductiveTimeItem(index: index);
          },
          itemCount: TimeOfDay.hoursPerDay,
          separatorBuilder: (context, index) => Divider(height: 5.0),
          //controller: _scrollController,
        ),
      ),
    );
  }

//  @override
//  void dispose() {
//    _scrollController.dispose();
//    super.dispose();
//  }
}
