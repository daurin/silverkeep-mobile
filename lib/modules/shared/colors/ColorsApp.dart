import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorsApp{

  BuildContext context;
  List<Map> colors;

  ColorsApp(this.context){
    colors=[
      {
        'key':'tomato',
        'title':'Tomate',
        'color':getColorByHex('E53935')
      },
      {
        'key':'tangerine',
        'title':'Mandarina',
        'color':getColorByHex('FF6F00')
      },
      {
        'key':'sunflower',
        'title':'Girasol',
        'color':getColorByHex('FFC400')
      },
      {
        'key':'basil',
        'title':'Albahaca',
        'color':getColorByHex('388E3C')
      },
      {
        'key':'mint',
        'title':'Menta',
        'color':getColorByHex('00E676')
      },
      {
        'key':'turquoise',
        'title':'Turquesa',
        'color':getColorByHex('00BCD4')
      },
      {
        'key':'indigo',
        'title':'Índigo',
        'color':getColorByHex('3F51B5')
      },
      {
        'key':'lavender',
        'title':'Lavanda',
        'color':getColorByHex('9575CD')
      },
      {
        'key':'grape',
        'title':'Uva',
        'color':getColorByHex('7B1FA2')
      },
      {
        'key':'flemish',
        'title':'Flamenco',
        'color':getColorByHex('EF6C00')
      },
      {
        'key':'graphite',
        'title':'Grafito',
        'color':getColorByHex('616161')
      },
      {
        'key':'predetermined',
        'title':'Predeterminado',
        'color':null
      }
    ];
  }

  static Color getColorByHex(String hex){
    return Color(int.parse('0xff'+hex));
  }

  Map getColorDataByKey(String key){
    Map colorData=colors.firstWhere((v)=>v['key']==key,orElse:() => colors[colors.length-1]);
    return colorData;  
  }
}