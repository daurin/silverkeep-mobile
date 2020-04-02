import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:silverkeep/db/models/Transaction.dart';

class CustomRepeatPage extends StatefulWidget {
  
  final Transaction transaction; 

  const CustomRepeatPage({Key key,this.transaction}) : super(key: key);

  @override
  _CustomRepeatPageState createState() => _CustomRepeatPageState();
}

class _CustomRepeatPageState extends State<CustomRepeatPage> {

  FocusNode _repeatEveryFocus,_finishAfterRepeatFocus;
  TextEditingController _repeatEveryCountController,_finishAfterRepeatController;

  Transaction _transaction;
  DateTime _dateFinish;

  @override
  void initState() {
    super.initState();

    _transaction=widget.transaction;

    _repeatEveryFocus=FocusNode();
    _finishAfterRepeatFocus=FocusNode();
    _repeatEveryFocus.addListener((){
      if(_repeatEveryFocus.hasFocus)
        _repeatEveryCountController.selection=TextSelection(baseOffset: 0, extentOffset: _repeatEveryCountController.text.length);
    });
    _finishAfterRepeatFocus.addListener((){
      if(_finishAfterRepeatFocus.hasFocus)
        _finishAfterRepeatController.selection=TextSelection(baseOffset: 0, extentOffset: _finishAfterRepeatController.text.length);
    });

    _repeatEveryCountController=TextEditingController(
      text: _transaction.repeatEveryCount==null?'1':_transaction.repeatEveryCount.toString()
    );
    _finishAfterRepeatController=TextEditingController(
      text: _transaction.finishAfterRepeat==null?'1':_transaction.finishAfterRepeat.toString()
    );
    if(_transaction.repeatEvery==null)_transaction.repeatEvery=TransactionRepeatEvery.Days;
    if(_transaction.monday==null)_transaction.monday=false;
    if(_transaction.tuesday==null)_transaction.tuesday=false;
    if(_transaction.saturday==null)_transaction.saturday=false;
    if(_transaction.thursday==null)_transaction.thursday=false;
    if(_transaction.wednesday==null)_transaction.wednesday=false;
    if(_transaction.sunday==null)_transaction.sunday=false;
    if(_transaction.friday==null)_transaction.friday=false;

    if(_transaction.dateFinish!=null)_dateFinish=_transaction.dateFinish;
    else _dateFinish=DateTime.now().add(Duration(days: 30));

  }

  @override
  void dispose() {
    _repeatEveryFocus.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.close), onPressed: ()=>Navigator.pop(context)),
        title:Text('Repeticiones personalizada'),
        actions: <Widget>[
          ButtonBar(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.check),
                onPressed: _onSubmit,
              )
            ],
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          _buildLabel('Se repite cada'),
          ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildInput(
                  controller: _repeatEveryCountController,
                  focusNode: _repeatEveryFocus,
                  onChanged: (String text)=>setState(()=>_transaction.repeatEveryCount=int.parse(text)),
                ),
                SizedBox(width: 13,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    height: 48,
                    child: Material(
                      color: Colors.grey.shade200,
                      child: PopupMenuButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(width: 6,),
                            Text((){
                              switch (_transaction.repeatEvery) {
                                case TransactionRepeatEvery.Days:return 'Dias';
                                case TransactionRepeatEvery.Weeks:return 'Semanas';
                                case TransactionRepeatEvery.Months:return 'Meses';
                                case TransactionRepeatEvery.Years:return 'Años';
                                default: return '';
                              }
                            }()),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                        itemBuilder: (BuildContext context){
                          return <PopupMenuItem<TransactionRepeatEvery>>[
                            new PopupMenuItem<TransactionRepeatEvery>(
                              child: const Text('Dias'), value: TransactionRepeatEvery.Days
                            ),
                            new PopupMenuItem<TransactionRepeatEvery>(
                              child: const Text('Semanas'), value: TransactionRepeatEvery.Weeks
                            ),
                            new PopupMenuItem<TransactionRepeatEvery>(
                              child: const Text('Meses'), value: TransactionRepeatEvery.Months
                            ),
                            new PopupMenuItem<TransactionRepeatEvery>(
                              child: const Text('Años'), value: TransactionRepeatEvery.Years
                            ),
                          ];                    
                        },
                        onSelected: (TransactionRepeatEvery value)=>setState(()=>_transaction.repeatEvery=value),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: _transaction.repeatEvery==TransactionRepeatEvery.Weeks,
            child: _buildWeekRepeat(),
          ),
          Divider(),
          _buildLabel('Finaliza'),
          // ListTile(
          //   title: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: <Widget>[
          //       _buildInput(
          //         onChanged: (String text)=>setState(()=>_transaction.repetitions=int.parse(text)),
          //       ),
          //     ],
          //   ),
          // ),
          // RadioListTile<DateTime>(
          //   value: null,
          //   groupValue: _transaction.dateFinish,
          //   title: Text('Nunca'),
          //   onChanged: _onChangeDateFinish
          // ),
          RadioListTile(
            value: TransactionFinishMode.Date,
            groupValue: _transaction.finishRepeatMode,
            title: GestureDetector(
              onTap:  _transaction.finishRepeatMode== TransactionFinishMode.Date?_onTabDateFinish:null,
              child: Text('El ${DateFormat.yMMMMEEEEd().format(_dateFinish)}'),
            ),
            secondary: IconButton(
              icon: Icon(Icons.date_range),
              onPressed: _onTabDateFinish
            ),
            onChanged: _onChangeFinish
          ),
          RadioListTile(
            value: TransactionFinishMode.AfterRepeat,
            groupValue: _transaction.finishRepeatMode,
            title: GestureDetector(
              child: Row(
                children: <Widget>[
                  Text('Despues de'),
                  SizedBox(width: 8,),
                  _buildInput(
                    focusNode: _finishAfterRepeatFocus,
                    controller: _finishAfterRepeatController,
                    onChanged: (String text)=>setState(()=>_transaction.finishAfterRepeat=int.parse(text)),
                  ),
                  SizedBox(width: 8,),
                  Text('repeticiones'),
                ],
              ),
            ),
            onChanged: _onChangeFinish
          ),
        ],
      ),
    );
  }

  Widget _buildInput({TextEditingController controller,FocusNode focusNode,void Function(String text) onChanged}){
    return Container(
      width: 48,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
        textAlign: TextAlign.center,
        decoration: InputDecoration.collapsed(
          hintText: '',
          border: OutlineInputBorder(),
          fillColor: Colors.grey.shade200,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(2),
          WhitelistingTextInputFormatter.digitsOnly,
          TextInputFormatter.withFunction((TextEditingValue oldValue, TextEditingValue newValue){
            if(newValue.text.length==0)return newValue;
            if(newValue.text[0]=='0')return newValue.copyWith(text: '1');
            return newValue;
          })
        ],
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildLabel(String text){
    return ListTile(
      title:Text(text.toUpperCase(),style: Theme.of(context).textTheme.subtitle,),
    );
  }

  Widget _buildWeekRepeat(){
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(),
          _buildLabel('Se repite el'),
          ListTile(
            title: Wrap(
              spacing: 7,
              runSpacing: 7,
              children: <Widget>[
                _buildCircleCheck(text: 'L',selected: _transaction.monday,onTab: ()=>setState(()=>_transaction.monday=!_transaction.monday)),
                _buildCircleCheck(text: 'M',selected: _transaction.tuesday,onTab: ()=>setState(()=>_transaction.tuesday=!_transaction.tuesday)),
                _buildCircleCheck(text: 'M',selected: _transaction.wednesday,onTab: ()=>setState(()=>_transaction.wednesday=!_transaction.wednesday)),
                _buildCircleCheck(text: 'J',selected: _transaction.thursday,onTab: ()=>setState(()=>_transaction.thursday=!_transaction.thursday)),
                _buildCircleCheck(text: 'V',selected: _transaction.friday,onTab: ()=>setState(()=>_transaction.friday=!_transaction.friday)),
                _buildCircleCheck(text: 'S',selected: _transaction.saturday,onTab: ()=>setState(()=>_transaction.saturday=!_transaction.saturday)),
                _buildCircleCheck(text: 'D',selected: _transaction.sunday,onTab: ()=>setState(()=>_transaction.sunday=!_transaction.sunday)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Widget _buildMonthRepeat(){
  //   return Container(
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         Divider(),
  //         _buildLabel(text: '')
  //         Divider()
  //       ],
  //     ),
  //   );
  //}

  Widget _buildCircleCheck({String text='',bool selected=false,Function onTab})
  {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        height: 35,
        width: 35,
        child: CircleAvatar(
          backgroundColor: selected?Theme.of(context).accentColor:Colors.grey.shade300,
          foregroundColor: selected?Colors.white:Colors.black,
          child: Text(text),
        ),
      ),
    );
  }

  void _onChangeFinish(TransactionFinishMode value){
    setState((){
      _transaction.finishRepeatMode=value;
    });
  }

  void _onTabDateFinish (){
    setState(() {
      _transaction.dateFinish=_dateFinish;
    });

    showDatePicker(
      context: context,
      initialDate: _transaction.dateFinish??DateTime.now(),
      firstDate: _transaction.date,
      lastDate: DateTime.now().add(Duration(days: 36500))
    )
    .then((DateTime date){
      if(date!=null){
        setState(() {
          setState((){
            if(date!=null)_dateFinish=date;
            _transaction.dateFinish=date;
          });
        });
      }
    });
  }

  void _onSubmit(){
    _transaction.repeatEveryCount=int.parse(_repeatEveryCountController.text);
    _transaction.repeatMode=TransactionRepeatMode.Custom;

    if(_transaction.repeatEveryCount==null)_transaction.repeatEveryCount=1;
    if(_transaction.finishAfterRepeat==null)_transaction.finishAfterRepeat=1;

    Navigator.pop(context,_transaction);
  }
}