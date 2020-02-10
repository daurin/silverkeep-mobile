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
        return DealingItem();
      },
      separatorBuilder: (bc,index){
        return Divider(height: 1,);
      },
      itemCount: 20
    );
  }

}
