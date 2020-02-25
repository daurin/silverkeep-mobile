import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:silverkeep/modules/more/MoreFragment.dart';
import 'package:silverkeep/modules/more/MoreAppBar.dart';
import 'package:silverkeep/modules/transactions/TransactionAppBar.dart';
import 'package:silverkeep/modules/transactions/TransactionPage.dart';
import 'package:silverkeep/modules/transactions/TransactionsFragment.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _bottonNavigationIndex;

  @override
  void initState() {
    super.initState();

    _bottonNavigationIndex=0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: IndexedStack(
          index:_bottonNavigationIndex,
          children: <Widget>[
            AppBar(
              title: Text('Silver Keep'),
            ),
            TransactionAppBar(),
            //AppBar( title: Text('Presupuestos'),),
            MoreAppBar()
          ],
        ),
      ),
      body: IndexedStack(
        index:_bottonNavigationIndex,
        children:[
          Center(child:Text('General')),
          TransactionsFragment(),
          //Center(child:Text('Presupuestos')),
          MoreFragment()
        ]
      ),
      floatingActionButton:_bottonNavigationIndex!=2 ? FloatingActionButton(
        child:Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TransactionPage()));
        }
      ):null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottonNavigationIndex,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        //showUnselectedLabels: false,
        onTap: (index){
          setState(() {
            _bottonNavigationIndex=index;
          });
        },
        items:[
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.homeOutline),
            title: Text('General')
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.clipboardListOutline),
            title: Text('Transacciones'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(MdiIcons.flagOutline),
          //   title: Text('Presupuestos')
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            title: Text('Mas')
          )
        ]
      ),
    );
  }
}