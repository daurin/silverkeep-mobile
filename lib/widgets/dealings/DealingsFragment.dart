import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:silverkeep/widgets/dealings/DealingItem.dart';

class DialingsFragment extends StatefulWidget {
  DialingsFragment({Key key}) : super(key: key);

  @override
  _DialingsFragmentState createState() => _DialingsFragmentState();
}

class _DialingsFragmentState extends State<DialingsFragment> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (bc,index){
        if(index>5)return _buildItem();
        else return DealingItem();
      },
      separatorBuilder: (bc,index){
        return Divider(height: 1,);
      },
      itemCount: 20
    );
  }

  Widget _buildItem(){
    return ListTile(
      title: Text('Cuenta de ahorro popular',style: TextStyle(fontWeight: FontWeight.w500),),
      subtitle: Text('8 Jul 2020',style: TextStyle(fontWeight: FontWeight.w500),),
      trailing: Text('\$ 30,000', style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.green))
    );
  }
}
