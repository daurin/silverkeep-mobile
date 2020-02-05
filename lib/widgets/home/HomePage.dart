import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:silverkeep/widgets/Dealings/DealingsAppBar.dart';
import 'package:silverkeep/widgets/dealings/DealingsFragment.dart';

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
            AppBar(),
            DialingsAppBar()
          ],
        ),
      ),
      body: IndexedStack(
        index:_bottonNavigationIndex,
        children:[
          Center(child:Text('General')),
          DialingsFragment(),
          Center(child:Text('Presupuestos')),
          Center(child:Text('Mas')),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){}
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottonNavigationIndex,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (index){
          setState(() {
            _bottonNavigationIndex=index;
          });
        },
        items:[
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.homeAnalytics),
            title: Text('General')
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.swapHorizontal),
            title: Text('Transacciones')
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.chartGantt),
            title: Text('Presupuestos')
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.dotsHorizontal),
            title: Text('Mas')
          )
        ]
      ),
    );
  }
}