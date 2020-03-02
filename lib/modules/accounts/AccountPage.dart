import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:silverkeep/db/models/Account.dart';
import 'package:silverkeep/enums/PageMode.dart';
import 'package:silverkeep/modules/shared/colors/ColorsApp.dart';
import 'package:silverkeep/modules/shared/colors/ColorsDialog.dart';
import 'package:silverkeep/utils/NumberInputFormatter2.dart';

class AccountPage extends StatefulWidget {

  final int idAccount;
  AccountPage({Key key,this.idAccount}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  PageMode _pageMode;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController,_amountController; 
  Account _account;
  FocusNode _nameFocus,_amountFocus;
  bool _loading;

  @override
  void initState() {
    super.initState();

    _pageMode=widget.idAccount==null?PageMode.add:PageMode.edit;

    _nameController=TextEditingController();
    _amountController=TextEditingController();

    _nameFocus=FocusNode();
    _amountFocus=FocusNode();

    _loading=false;
    if(_pageMode==PageMode.add){
      _account=new Account(
        color:'predetermined'
      );
    }
    else{
      _loading=true;
      Account.getById(widget.idAccount)
        .then((account){
          setState(()=>_account=account);
          _nameController.text=_account.name;
        })
        .whenComplete((){
          setState(()=>_loading=false);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_loading)return Container();

    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: ColorsApp(context).getColorDataByKey(_account.color)['color']
      ),
      child: Scaffold(
        appBar: AppBar(
          title:Text(_pageMode==PageMode.add?'Nueva cuenta':_account.name),
          actions: <Widget>[
            Visibility(
              visible: _pageMode==PageMode.edit,
              child: IconButton(
                icon: Icon(MdiIcons.deleteOutline),
                onPressed: _delete
              ),
            ),
            IconButton(
              icon: Icon(MdiIcons.check),
              onPressed: _save
            )
          ],
        ),
        body: Form(
          key:_formKey,
          child: ListView(
            children: <Widget>[
              ListTile(
                // leading: Visibility(
                //   visible: false,
                //   maintainAnimation: true,
                //   maintainSemantics: true,
                //   maintainSize: true,
                //   maintainState: true,
                //   child: Icon(Icons.title)
                // ),
                title: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 800,
                  ),
                  child: TextFormField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    autofocus: _nameController.text.length==0,
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.sentences,
                    //textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline,
                    decoration: InputDecoration(
                      hintText: 'Titulo',
                      border: InputBorder.none,
                      hintStyle: Theme.of(context).textTheme.headline.copyWith(color:Theme.of(context).hintColor)
                    ),
                    onFieldSubmitted: (value){
                      FocusScope.of(context).requestFocus(_amountFocus);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return '¿Cual es el titulo de esta cuenta?';
                      }
                      return null;
                    }
                  ),
                ),
              ),
              Divider(),
              Visibility(
                visible: _pageMode==PageMode.add,
                child: ListTile(
                  leading: Icon(Icons.attach_money),
                  title: TextField(
                    controller: _amountController,
                    focusNode: _amountFocus,
                    inputFormatters: [
                      ThousandsFormatter(allowFraction: true),
                    ],
                      keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
                      decoration: InputDecoration.collapsed(
                      hintText: 'Saldo inicial'
                    ),
                  ),
                ),
              ),
              ListTile(
                leading:Icon(MdiIcons.circle,color:ColorsApp(context).getColorDataByKey(_account.color)['color'],),
                title: Text(ColorsApp(context).getColorDataByKey(_account.color)['title']),
                onTap: _onTabColor,
              )
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(MdiIcons.contentSaveOutline),
        //   onPressed: _save
        // ),
        bottomNavigationBar: Container(
          height: kBottomNavigationBarHeight,
          child: RaisedButton(
            child: Text('Guardar',style: TextStyle(fontSize: 16),),
            textColor: Theme.of(context).primaryTextTheme.title.color,
            onPressed: _save
          ),
        ),
      ),
    );
  }

  _save(){
    if(!_formKey.currentState.validate())return;

    _account.name=_nameController.text;

    if(_pageMode==PageMode.add){
      Account.add(_account)
      .then((value){
        Navigator.of(context).pop(true);
      })
      .catchError((err){
        print(err);
      });
    }
    else{
      Account.editById(_account,_account.id)
      .then((value){
        Navigator.of(context).pop(true);
      })
      .catchError((err){
        print(err);
      });
    }
  }

  _delete(){
    Account.deleteById(_account.id)
      .then((value){
        Navigator.of(context).pop(true);
      })
      .catchError((err){
        print(err);
      });
  }

  _onTabColor(){
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (BuildContext bc){
        return AccountColorsDialog(selectedValue: _account.color,);
      },
    ).then((value){
      setState(() {
        if(value!=null)_account.color=value;
      });
    });
  }
}