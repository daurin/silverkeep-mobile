import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ColorSelectDialog extends StatelessWidget {
  const ColorSelectDialog({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((duration){
    //   if(widget.keySelectedOption!=null)Scrollable.ensureVisible(widget.keySelectedOption.currentContext);
    // });

    return AlertDialog(
      //title: Text('Color'),
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Column(
          children: [
            {
              'title':'Tomate',
              'color':'E53935'
            },
            {
              'title':'Mandarina',
              'color':'FF6F00'
            },
            {
              'title':'Girasol',
              'color':'FFC400'
            },
            {
              'title':'Albahaca',
              'color':'388E3C'
            },
            {
              'title':'Menta',
              'color':'00E676'
            },
            {
              'title':'Turquesa',
              'color':'00BCD4'
            },
            {
              'title':'Índigo',
              'color':'3F51B5'
            },
            {
              'title':'Lavanda',
              'color':'9575CD'
            },
            {
              'title':'Uva',
              'color':'7B1FA2'
            },
            {
              'title':'Flamenco',
              'color':'EF6C00'
            },
            {
              'title':'Grafito',
              'color':'616161'
            },
            // {
            //   'title':'Color prodeterminado',
            //   'color':Theme.of(context).primaryColor.toString()
            // }
          ].map<Widget>((v){
            return _buildItem(value:v['color'],title:v['title'],color: Color(int.parse('0xff'+v['color'])));
          }).toList()
        ),
      ),
      // actions: <Widget>[
      //   FlatButton(
      //     child: Text('Cancelar'),
      //     onPressed: (){
      //       Navigator.of(context).pop();
      //     },
      //   )
      // ],
    );
  }

  _buildItem({String value,String title,Color color}){
    return ListTile(
      leading:value=='00E676'?Icon(MdiIcons.circle,color:color):
        Icon(MdiIcons.recordCircle,color:color),
      title: value=='00E676'?Text(title,style: TextStyle(color: color),):Text(title),
      onTap: (){

      },
    );
  }
}