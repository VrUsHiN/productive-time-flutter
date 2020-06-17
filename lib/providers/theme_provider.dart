import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  Color _themeSwatchColor = Colors.blueGrey;
  SharedPreferences prefs;

  Future<void> getThemeColor() async{
    int code = prefs.getInt('theme') ?? 0;
    //print(code);
    decode(code);
    print(_themeSwatchColor);
  }

  Future<void> setThemeColor(int code) async{
    prefs.setInt('theme', code);
  }

  Future<void> initialisePreferences() async{
    print('hi');
    prefs = await SharedPreferences.getInstance();
    getThemeColor();//await?
  }

//  ThemeProvider(){
//    initialisePreferences();
//    print('hi');
//  }


  ThemeData get themeData => _themeSwatchColor == Colors.black
      ? ThemeData.dark().copyWith(
          accentColor: Colors.orange,
          primaryColorLight: Colors.black,
          primaryColor: Colors.black,
          toggleableActiveColor: Colors.orange,
          appBarTheme: AppBarTheme(
            textTheme: TextTheme(headline6: TextStyle(color: Colors.orange)),
            iconTheme: IconThemeData(color: Colors.orange),
          ),
          textTheme: TextTheme(
            headline5: TextStyle(color: Colors.orange),
            headline6: TextStyle(color: Colors.white),
          ),

          sliderTheme: SliderThemeData().copyWith(
            activeTrackColor: Colors.orange,
            overlayColor: Colors.orange.withOpacity(0.1),
            thumbColor: Colors.orange,
            inactiveTrackColor: Colors.orange.withOpacity(0.1),
            valueIndicatorColor: Colors.orange,
          ),
        )
      : ThemeData(
          primarySwatch: _themeSwatchColor, //Colors.lightGreen,
          textTheme: TextTheme(
            headline6: TextStyle(color: Colors.black),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        );

  int encode(Color color){
    if(color==Colors.blueGrey){
      return 0;
    }
    else if(color==Colors.indigo){
      return 1;
    }
    else if(color==Colors.amber){
      return 2;
    }
    else if(color==Colors.purple){
      return 3;
    }
    else if(color==Colors.black){
      return 4;
    }
    else{
      return 9999;
    }
  }

  void decode(int code){
    if(code==0){
      _themeSwatchColor = Colors.blueGrey;
    }
    else if(code==1){
      _themeSwatchColor = Colors.indigo;
    }
    else if(code==2){
      _themeSwatchColor = Colors.amber;
    }
    else if(code==3){
      _themeSwatchColor = Colors.purple;
    }
    else if(code==4){
      _themeSwatchColor = Colors.black;
    }
    else{
      _themeSwatchColor = Colors.blueGrey;
    }
  }

  void setThemeSwatch(Color color) async{
    _themeSwatchColor = color;
    notifyListeners();
    int code = encode(color);
    setThemeColor(code);
  }


}
