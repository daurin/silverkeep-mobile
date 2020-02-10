import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DrawerHome extends StatelessWidget {
  const DrawerHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 100,
            child: DrawerHeader(
              child: Text('Silver Keep',style:Theme.of(context).textTheme.headline.copyWith(color: Colors.grey.shade700)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.label_outline),
            title: Text('Categorias'),
            onTap: () {
            },
          ),
          Divider(height: 1,),
          ListTile(
            title: Text('Informes',style: TextStyle(color: Colors.grey)),
          ),
          ListTile(
            leading: Icon(MdiIcons.chartDonut),
            title: Text('Graficos'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.finance),
            title: Text('Resumen'),
            onTap: () {
            },
          ),
          Divider(height: 1,),
          ListTile(
            leading: Icon(MdiIcons.settingsOutline),
            title: Text('Configuración'),
            onTap: () {
            },
          ),
          Divider(height: 1,),
          ListTile(
            title: Text('Acerca de Silver Keep'),
            onTap: () {
            },
          )
        ],
      ),
    );
  }
}