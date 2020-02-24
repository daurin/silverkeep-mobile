import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TransactionItem extends StatelessWidget {
  final double amount; 

  const TransactionItem({Key key,this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Sueldo del trabajo',style: Theme.of(context).textTheme.subhead,),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Banco popular ',
                  style: Theme.of(context).textTheme.subtitle
                ),
                WidgetSpan(
                  child: Icon(MdiIcons.swapHorizontal, size: 12,),
                  alignment: PlaceholderAlignment.middle,
                  style: Theme.of(context).textTheme.subtitle
                ),
                TextSpan(
                  text: ' Billetera',
                  style: Theme.of(context).textTheme.subtitle
                ),
              ]
            )
          ),
          SizedBox(height: 5,),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.refresh, size: 14,color: Colors.grey,),
                  alignment: PlaceholderAlignment.middle,
                  style: Theme.of(context).textTheme.subtitle
                ),
                TextSpan(
                  text: ' Periodica',
                  style: Theme.of(context).textTheme.subtitle
                ),
              ]
            )
          )
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          RichText(
            text:TextSpan(
              children: [
                // WidgetSpan(
                //   child: Icon(Icons.trending_up, size: 17),
                // ),
                TextSpan(
                  text: ' + \$ 30,000',
                  style: Theme.of(context).textTheme.title.copyWith(color:Colors.green.shade400)
                ),
              ]
            )
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
               _buildDealingTag(context,title: 'Sueldo'),
               _buildDealingTag(context,title: 'Clientes'),
            ],
          )
        ],
      ),
      isThreeLine: true,
      onTap: (){

      },
    );
  }

  _buildDealingTag(BuildContext context,{String title}){
    return Container(
      margin: EdgeInsets.only(left: 5),
      child: Text(title,style: Theme.of(context).textTheme.caption.copyWith(fontSize: 14),),
      padding: EdgeInsets.fromLTRB(7, 3, 7, 2),
      decoration: BoxDecoration(
        border: Border.all(width: 1,color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.all(Radius.circular(7))
      ),
    );
  }
}
