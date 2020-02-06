import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DealingItem2 extends StatelessWidget {
  final double amount; 

  const DealingItem2({Key key,this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Sueldo del trabajo'),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Banco popular',
                  style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 13,color: Colors.grey[700])
                ),
                WidgetSpan(
                  child: Icon(MdiIcons.swapHorizontal, size: 13,color: Colors.grey,),
                  alignment: PlaceholderAlignment.middle,
                  style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 15,color: Colors.grey)
                ),
                TextSpan(
                  text: 'Banco popular',
                  style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 13,color: Colors.grey[700])
                ),
              ]
            )
          ),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.refresh, size: 17,color: Colors.grey,),
                  alignment: PlaceholderAlignment.middle,
                  style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 15,color: Colors.grey)
                ),
                TextSpan(
                  text: '  Periodica',
                  style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 15,color: Colors.grey)
                ),
              ]
            )
          )
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text('\$ 30,000',style: TextStyle(fontSize: 17 ,color: Colors.green),),
          Text('Sueldo • Trabajo 1',style:TextStyle(fontSize: 14 ,color: Colors.grey))
        ],
      ),
      isThreeLine: true,
      onTap: (){

      },
    );
  }
}
