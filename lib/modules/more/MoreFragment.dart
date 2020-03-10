import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:silverkeep/modules/accounts/AccountsPage.dart';
import 'package:silverkeep/modules/labels/LabelsPage.dart';

class MoreFragment extends StatelessWidget {
  const MoreFragment({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Administrar', style: TextStyle(color:Theme.of(context).hintColor)),
        ),
        ListTile(
          leading: Icon(MdiIcons.walletOutline),
          title: Text('Cuentas'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AccountsPage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.label_outline),
          title: Text('Etiquetas'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LabelsPage()));
          },
        ),
        Divider(
          height: 1,
        ),
        ListTile(
          title: Text('Informes', style: TextStyle(color:Theme.of(context).hintColor)),
        ),
        ListTile(
          leading: Icon(MdiIcons.chartDonut),
          title: Text('Graficos'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(MdiIcons.finance),
          title: Text('Resumen'),
          onTap: () {},
        ),
        Divider(
          height: 1,
        ),
        ListTile(
          title: Text('Aplicación', style: TextStyle(color:Theme.of(context).hintColor)),
        ),
        ListTile(
          leading: Icon(MdiIcons.settingsOutline),
          title: Text('Configuración'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('Acerca de Silver Keep'),
          onTap: () {},
        )
      ],
    );
  }
}
