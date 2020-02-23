import 'package:flutter/material.dart';
import 'package:silverkeep/db/models/Label.dart';
import 'package:silverkeep/modules/shared/colors/ColorsApp.dart';
import 'package:silverkeep/modules/shared/colors/ColorsDialog.dart';

class LabelsPage extends StatefulWidget {
  LabelsPage({Key key}) : super(key: key);

  @override
  _LabelsPageState createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage> {

  TextEditingController _incomeAddController;
  FocusNode _incomeAddFocus;
  bool _incomeAddFocused=false;
  String _incomeColor='predetermined';
  List<Map> _incomesItems;

  TextEditingController _expenseAddController;
  FocusNode _expenseAddFocus;
  bool _expenseAddFocused=false;
  String _expenseColor='predetermined';
  List<Map> _expenseItems;

  @override
  void initState() {
    super.initState();

    // Income
    _incomeAddController=TextEditingController();
    _incomeAddFocus=FocusNode();
    _incomeAddFocus.addListener((){
      setState(() {
        _incomeAddFocused=_incomeAddFocus.hasFocus;
      });
    });
    _incomesItems=[];
    _loadIncomesItems();

    // Expense
    _expenseAddController=TextEditingController();
    _expenseAddFocus=FocusNode();
    _expenseAddFocus.addListener((){
      setState(() {
        _expenseAddFocused=_expenseAddFocus.hasFocus;
      });
    });
    _expenseItems=[];
    _loadExpenseItems();
  }

  @override
  void dispose() {
    super.dispose();

    _incomeAddFocus.dispose();
    for (Map item in _incomesItems) {
      item['controller'].dispose();
      item['focusNode'].dispose();
    }

    _expenseAddFocus.dispose();
    for (Map item in _expenseItems) {
      item['controller'].dispose();
      item['focusNode'].dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title:Text('Etiquetas'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Ingresos',),
              Tab(text: 'Gastos',),
            ],
          )
        ),
        body: TabBarView(
          children: [
            // ReorderableColumn(
            //     mainAxisSize: MainAxisSize.min,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       _buildLabelAdd(
            //         key: Key('-5'),
            //         controller: _incomeAddController,
            //         focusNode: _incomeAddFocus,
            //         focused: _incomeAddFocused,
            //         selectColor: _selectIncomeLabelColor,
            //         add: _addIncomeLabel
            //       ),
            //       ..._incomesItems.map((v){
            //         return _buildLabelEdit(
            //           controller: v['controller'],
            //           focusNode: v['focusNode'],
            //           focused: v['focused'],
            //           label: v['label']
            //         );
            //       }).toList()
            //     ],
            //     onReorder: _onReorder
            //   ),
            ListView(
              children: <Widget>[
                _buildLabelAdd(
                  controller: _incomeAddController,
                  focusNode: _incomeAddFocus,
                  focused: _incomeAddFocused,
                  selectColor: _selectIncomeLabelColor,
                  add: _addIncomeLabel
                ),
                ..._incomesItems.map((v){
                  return _buildLabelEdit(
                    controller: v['controller'],
                    focusNode: v['focusNode'],
                    focused: v['focused'],
                    label: v['label']
                  );
                }).toList()
              ], 
            ),
            ListView(
              children: <Widget>[
                _buildLabelAdd(
                  key: Key('-4'),
                  controller: _expenseAddController,
                  focusNode: _expenseAddFocus,
                  focused: _expenseAddFocused,
                  selectColor: _selectExpenseLabelColor,
                  add: _addExpenseLabel
                ),
                ..._expenseItems.map((v){
                  return _buildLabelEdit(
                    controller: v['controller'],
                    focusNode: v['focusNode'],
                    focused: v['focused'],
                    label: v['label']
                  );
                }).toList()
              ], 
            )
          ],
        )
      ),
    );
  }

  _loadIncomesItems(){
    Label.getAllIncomes(orderBy: 'id desc')
      .then((List<Label> res){
        setState(() {  
          _incomesItems=res.map((Label label){
            return {
              'controller':TextEditingController(text: label.name),
              'focusNode':FocusNode(),
              'focused':false,
              'label':label
            };
          }).toList();
        });
        for (Map item in _incomesItems) {
            item['focusNode'].addListener((){
              setState(() {
                item['focused']=item['focusNode'].hasFocus;
              });

              if(!item['focusNode'].hasFocus){
                if(item['controller'].text.replaceAll(' ', '').length==0){
                  item['controller'].text=item['label'].name;
                }
                else{
                  item['label'].name=item['controller'].text;
                  Label.editById(item['label'],item['label'].id);
                }
              }
            });
          }
      });
  }

  _loadExpenseItems(){
    Label.getAllExpense(orderBy: 'id desc')
      .then((List<Label> res){
        setState(() {  
          _expenseItems=res.map((Label label){
            return {
              'controller':TextEditingController(text: label.name),
              'focusNode':FocusNode(),
              'focused':false,
              'label':label
            };
          }).toList();
        });
        for (Map item in _expenseItems) {
            item['focusNode'].addListener((){
              setState(() {
                item['focused']=item['focusNode'].hasFocus;
              });

              if(!item['focusNode'].hasFocus){
                if(item['controller'].text.replaceAll(' ', '').length==0){
                  item['controller'].text=item['label'].name;
                }
                else{
                  item['label'].name=item['controller'].text;
                  Label.editById(item['label'],item['label'].id);
                }
              }
            });
          }
      });
  }

  Widget _buildLabelAdd({Key key,TextEditingController controller,FocusNode focusNode,bool focused,Function selectColor,Function add}){
    return Column(
      key: key,
      children: <Widget>[
        ListTile(
          leading: IconButton(
            icon: Icon(focused?Icons.close:Icons.add),
            onPressed: (){
              if(focused)focusNode.unfocus();
              else focusNode.requestFocus();
            },
          ),
          title: TextField(
            controller: controller,
            focusNode: focusNode,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration.collapsed(
              hintText: 'Crear etiqueta nueva'
            ),
            onSubmitted: (v)=>add(),
          ),
          trailing: Visibility(
            visible: focused,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon:Icon(Icons.color_lens,color: ColorsApp(context).getColorDataByKey(_incomeColor)['color'],),
                  onPressed: selectColor,
                ),
                IconButton(
                  icon:Icon(Icons.check),
                  onPressed: add,
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: focused,
          maintainSize: true,
          maintainAnimation: true,
          maintainInteractivity: true,
          maintainSemantics: true,
          maintainState: true,
          child: Divider(height: 1,)
        ),
      ],
    );
  }

  Widget _buildLabelEdit({TextEditingController controller,FocusNode focusNode,bool focused,Label label}){

    return Column(
      key: ValueKey(label.id),
      children: <Widget>[
        Visibility(
          visible: focused,
          maintainSize: true,
          maintainAnimation: true,
          maintainInteractivity: true,
          maintainSemantics: true,
          maintainState: true,
          child: Divider(height: 1,)
        ),
        ListTile(
          leading: IconButton(
            icon: Icon(focused?Icons.delete_outline:Icons.label_outline),
            onPressed: (){
              if(focused){
                Label.deleteById(label.id);
                if(label.type=='I')_loadIncomesItems();
                if(label.type=='E')_loadExpenseItems();
              }
              else focusNode.requestFocus();
            },
          ),
          title: TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration.collapsed(
              hintText: ''),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Visibility(
                visible: focused,
                child: IconButton(
                  icon:Icon(Icons.color_lens,color: ColorsApp(context).getColorDataByKey(label.color)['color'],),
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext bc){
                        return AccountColorsDialog();
                      },
                    ).then((value){
                      setState(() {
                        if(value!=null)label.color=value;
                      });
                    });
                  },
                ),
              ),
              IconButton(
                icon:focused?
                  Icon(Icons.check,color: Theme.of(context).primaryColor,):
                  Icon(Icons.edit,),
                onPressed: (){
                  if(focused){
                    if(controller.text.replaceAll(' ', '').length==0){
                      controller.text=label.name;
                      focusNode.unfocus();
                      return;
                    }
                    label.name=controller.text;
                    Label.editById(label,label.id)
                    .then((value){
                      focusNode.unfocus();
                      if(label.type=='I')_loadIncomesItems();
                      if(label.type=='E')_loadExpenseItems();
                    });
                  }
                  else focusNode.requestFocus();
                },
              )
            ],
          ),
        ),
        Visibility(
          visible: focused,
          maintainSize: true,
          maintainAnimation: true,
          maintainInteractivity: true,
          maintainSemantics: true,
          maintainState: true,
          child: Divider(height: 1,)
        ),
      ],
    );
  }


  _addIncomeLabel(){
    if(_incomeAddController.text.replaceAll(' ', '').length==0)return;
    Label.add(new Label(
      name: _incomeAddController.text.trim(),
      color: _incomeColor,
      type: 'I'
    ))
      .then((value){
        _incomeAddController.text='';
        _incomeColor='';
        _loadIncomesItems();
        _incomeAddFocus.unfocus();
      });
  }

  _selectIncomeLabelColor(){
    showDialog(
      context: context,
      builder: (BuildContext bc){
        return AccountColorsDialog();
      },
    ).then((value){
      setState(() {
        if(value!=null)_incomeColor=value;
      });
    });
  }

  _addExpenseLabel(){
    if(_expenseAddController.text.replaceAll(' ', '').length==0)return;
    Label.add(new Label(
      name: _expenseAddController.text.trim(),
      color: _expenseColor,
      type: 'E'
    ))
      .then((value){
        _expenseAddController.text='';
        _expenseColor='';
        _loadExpenseItems();
        _expenseAddFocus.unfocus();
      });
  }
  
  _selectExpenseLabelColor(){
    showDialog(
      context: context,
      builder: (BuildContext bc){
        return AccountColorsDialog();
      },
    ).then((value){
      setState(() {
        if(value!=null)_expenseColor=value;
      });
    });
  }
}