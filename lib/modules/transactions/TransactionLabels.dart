import 'package:flutter/material.dart';
import 'package:silverkeep/db/models/Label.dart';

class TransactionLabels extends StatefulWidget {
  TransactionLabels({Key key}) : super(key: key);

  @override
  _TransactionLabelsState createState() => _TransactionLabelsState();
}

class _TransactionLabelsState extends State<TransactionLabels> {

  TextEditingController _textController;
  List<Label> _labels;
  bool _loadingLabels;

  List<Label> _labelsFiltered;
  List<int> _labelsSelected;

  @override
  void initState() {
    super.initState();
    _labelsSelected=[];
    _loadingLabels=true;
    _getLabels();
    _labelsFiltered=[];

    _textController=TextEditingController();
    _textController.addListener((){
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
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _textController,
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
                          .then((int id){
                            _textController.clear();
                            _labelsSelected.add(id);
                            _getLabels();
                          });
                      },
                    )
                  );
                },
              ),
              ...labels.map((Label item){
                return CheckboxListTile(
                  value: _labelsSelected.contains(item.id),
                  title: Text(item.name),
                  secondary: Icon(Icons.label_outline),
                  onChanged: (bool checked){
                    setState(() {  
                      if(_labelsSelected.contains(item.id))_labelsSelected.remove(item.id);
                      else _labelsSelected.add(item.id);
                    });
                  }
                );
              }).toList()
            ],
          );
        }
      ),
    );
  }

  void _getLabels(){
    Label.getAllIncomes()
      .then((List<Label> labels){
        setState(() {
          _labels=labels;
        });
      })
      .whenComplete(()=>setState(()=>_loadingLabels=false));
  }
}