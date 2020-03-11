import 'package:flutter/material.dart';
import 'package:silverkeep/db/models/Label.dart';
import 'package:silverkeep/db/models/Transaction.dart';

class TransactionLabelsPage extends StatefulWidget {
  final int transactionId;
  final TransactionType transactionType;

  TransactionLabelsPage({Key key,this.transactionId,this.transactionType}) : super(key: key);

  @override
  _TransactionLabelsPageState createState() => _TransactionLabelsPageState();
}

class _TransactionLabelsPageState extends State<TransactionLabelsPage> {

  TextEditingController _textController;
  List<Label> _labels;
  List<Label> _labelsFiltered;
  List<Label> _labelsSelected;
  bool _loadingLabels;

  TransactionType _transactionType;

  @override
  void initState() {
    super.initState();
    _labels=[];
    _labelsSelected=[];
    _loadingLabels=true;
    _labelsFiltered=[];

    _textController=TextEditingController();

    _transactionType=widget.transactionType;

    if(widget.transactionId ==null && widget.transactionType==null)throw ArgumentError();
    if(widget.transactionId !=null && widget.transactionType!=null)throw ArgumentError();

    if(widget.transactionId!=null){
      Transaction.findById(widget.transactionId)
        .then((Transaction transaction)async{
          _transactionType=transaction.transactionType;
          _getLabels();
        });
    }

    if(widget.transactionType!=null){
      _getLabels();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context,_labelsSelected);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _textController,
            onChanged: _onChangedText,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration.collapsed(
              hintText: 'Ingresar el nombre de la etiqueta',
            ),
          ),
        ),
        body: Builder(
          builder: (BuildContext context){
            if(_loadingLabels)return Container();

            List<Label> labels=[];
            labels=_textController.text.length>0? _labelsFiltered:_labels;

            return ListView(
              children: <Widget>[
                FutureBuilder(
                  future: Label.existByField(
                    field: 'name',
                    value: _textController.text.trim(),
                    type: LabelType.Income
                  ),
                  builder: (context,snapshot){
                    return Visibility(
                      visible: _textController.text.trim().length>0 && snapshot.data==false,
                      child: ListTile(
                        leading: Icon(Icons.add,color: Theme.of(context).accentColor),
                        title: Text('"${_textController.text.trim()}"'),
                        onTap: (){
                          Label.add(Label(name: _textController.text.trim(),type: LabelType.Income))
                            .then((int id)async{
                              _textController.clear();
                              _labelsSelected.add(await Label.findById(id));
                              _getLabels();
                            });
                        },
                      )
                    );
                  },
                ),
                ...labels.map((Label item){
                  return CheckboxListTile(
                    value: (_labelsSelected.firstWhere((v)=>v.id==item.id,orElse: ()=>null))!=null,
                    title: Text(item.name),
                    secondary: Icon(Icons.label_outline),
                    onChanged: (bool checked){
                      setState(() {  
                        Label label=_labelsSelected.firstWhere((v)=>v.id==item.id,orElse: ()=>null);
                        if(label!=null)_labelsSelected.remove(label);
                        else _labelsSelected.add(item);
                      });
                    }
                  );
                }).toList()
              ],
            );
          }
        ),
      ),
    );
  }

  void _getLabels()async{
    LabelType labelType;
    if(_transactionType==TransactionType.Expense)labelType=LabelType.Expense;
    if(_transactionType==TransactionType.Income)labelType=LabelType.Income;

    List<Label> labels=await Label.select(type: labelType);
    List<Label> labelsSelected=[];
    if(widget.transactionId!=null){
      await Label.select(transactionId: widget.transactionId)
        .then((List<Label> labels){
          for (Label item in labels) {
            if((_labelsSelected.firstWhere((v)=>v.id==item.id,orElse: ()=>null))!=null)labelsSelected.add(item);
          }
        });
      
    }
    setState((){
      _labels=labels;
      if(widget.transactionId!=null)_labelsSelected.addAll(labelsSelected);
      _loadingLabels=false;
    });

  }

  void _onChangedText(String text){
    String query=_textController.text.toLowerCase();

    if(query.isNotEmpty) {
      List<Label> dummyListData = List<Label>();
      _labels.forEach((Label label) {
        if(label.name.toLowerCase().contains(query)) {
          dummyListData.add(label);
        }
      });
      setState(() {
        _labelsFiltered.clear();
        _labelsFiltered.addAll(dummyListData);
      });
    } 
    else {
      setState(() {
        _labelsFiltered.clear();
      });
    }
  }

  void onSave(){

  }
}