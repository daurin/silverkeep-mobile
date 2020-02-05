import 'package:flutter/material.dart';

class DealingItem extends StatelessWidget {
  final double amount; 

  const DealingItem({Key key,this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(16),
      height: 72,
      child: InkWell(
        onTap: (){},
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Visibility(
              maintainSize: false, 
              maintainAnimation: true,
              maintainState: true,
              visible: true,
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 16, 0,16),
                height: double.infinity,
                width: 7,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4),bottomLeft: Radius.circular(4)),
                ),
              ),
            ),
            Expanded(
              child: Container(
                //color: Colors.red,
                margin: EdgeInsets.fromLTRB(16,16, 0, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Cuenta de ahorro banco popular',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('Comida - 8 Jul 2020',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade800),)
                    )
                  ],
                ),
              ),
            ),
            Container(
              //color: Colors.blue,
              margin: EdgeInsets.fromLTRB(0, 16, 16, 16),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: Text('+\$ 30,000',
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.green)
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.refresh, size: 12,color: Colors.grey,),
                              alignment: PlaceholderAlignment.middle,
                              style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey)
                            ),
                            TextSpan(
                              text:' Pendiente',
                              style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey)
                            )
                          ]
                        )
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}