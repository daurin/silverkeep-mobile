import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:silverkeep/widgets/dealings/DealingItem2.dart';

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
        return DealingItem2();
      },
      separatorBuilder: (bc,index){
        return Divider(height: 1,);
      },
      itemCount: 20
    );
  }

}
