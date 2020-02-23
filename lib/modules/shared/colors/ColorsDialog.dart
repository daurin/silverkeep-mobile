import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:silverkeep/modules/shared/colors/ColorsApp.dart';

class AccountColorsDialog extends StatelessWidget {

  final String selectedValue;

  AccountColorsDialog({Key key,this.selectedValue='predetermined'}) : super(key: key);


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
          children:ColorsApp(context).colors.map<Widget>((v){
            return _buildItem(
              context: context,
              key:v['key'],
              color:v['color'],
              title:v['title']
            );
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

  _buildItem({BuildContext context,String key,String title,Color color}){
    // Default value '616161'
    //Color color=Color(int.parse('0xff'+value));

    return ListTile(
      leading:key==this.selectedValue?Icon(MdiIcons.circle,color:color):
        Icon(MdiIcons.recordCircle,color:color),
      title: key==selectedValue?Text(title,style: TextStyle(color: color),):Text(title),
      onTap: (){
        Navigator.pop(context,key);
      },
    );
  }
}