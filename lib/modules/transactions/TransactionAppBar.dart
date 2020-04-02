import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:silverkeep/blocs/transaction/TransactionBloc.dart';
import 'package:silverkeep/blocs/transaction/TransactionEvents.dart';
import 'package:silverkeep/blocs/transaction/TransactionState.dart';
import 'package:silverkeep/modules/transactions/TransactionFilterPage.dart';

class TransactionAppBar extends StatelessWidget {
  const TransactionAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc,TransactionState>(
      condition: (oldState,newState){
        return oldState.visibleAmount!=newState.visibleAmount;
      },
      builder: (context,TransactionState state){
        return AppBar(
          title: Text('Transacciones'),
          actions: <Widget>[
            ButtonBar(
              children: <Widget>[
                IconButton(
                  icon: Icon(state.visibleAmount? MdiIcons.eyeOutline: MdiIcons.eyeOffOutline),
                  onPressed: ()=>_onTabVisibleAmount(context,state),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: ()=>_onPressedFilter(context)
                ),
              ],
            )
          ],
        ); 
      },
    );
  }

  void _onPressedFilter(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>TransactionFilterPage()));
  }

  void _onTabVisibleAmount(BuildContext context,TransactionState state){
    BlocProvider.of<TransactionBloc>(context).add(ChangeVisibleAmount(!state.visibleAmount));
  }
}