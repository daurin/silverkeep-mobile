import 'package:flutter/material.dart';

class CustomNotificationPage extends StatefulWidget {
  CustomNotificationPage({Key key}) : super(key: key);

  @override
  _CustomNotificationPageState createState() => _CustomNotificationPageState();
}

class _CustomNotificationPageState extends State<CustomNotificationPage> {
  
  bool _monday=false,_tuesday=false,_wednesday=false,_thursday=false,_friday=false,_saturday=false,_sunday=false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.close), onPressed: ()=>Navigator.pop(context)),
        title:Text('Repeticiones personalizada'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _onSubmit,
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          _buildLabel(
            text:'SE REPITE CADA'
          ),
          ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildContainer(
                  width: 60,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration.collapsed(
                      hintText: ''
                    ),
                  ),
                ),
                SizedBox(width: 13,),
                IntrinsicWidth(
                  child: _buildContainer(
                    child: PopupMenuButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(width: 6,),
                          Text('Dia'),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                      itemBuilder: (_) => <PopupMenuItem<String>>[
                        new PopupMenuItem<String>(child: const Text('Dias'), value: 'Doge'),
                        new PopupMenuItem<String>(child: const Text('Semanas'), value: 'Lion'),
                        new PopupMenuItem<String>(child: const Text('Meses'), value: 'Lion'),
                        new PopupMenuItem<String>(child: const Text('Años'), value: 'Lion')
                      ],
                    )
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          _buildLabel(text: 'SE REPITE EL'),
          ListTile(
            title: Wrap(
              spacing: 7,
              runSpacing: 7,
              children: <Widget>[
                _buildCircleCheck(text: 'L',selected: _monday,onTab: ()=>setState(()=>_monday=!_monday)),
                _buildCircleCheck(text: 'M',selected: _tuesday,onTab: ()=>setState(()=>_tuesday=!_tuesday)),
                _buildCircleCheck(text: 'M',selected: _wednesday,onTab: ()=>setState(()=>_wednesday=!_wednesday)),
                _buildCircleCheck(text: 'J',selected: _thursday,onTab: ()=>setState(()=>_thursday=!_thursday)),
                _buildCircleCheck(text: 'V',selected: _friday,onTab: ()=>setState(()=>_friday=!_friday)),
                _buildCircleCheck(text: 'S',selected: _saturday,onTab: ()=>setState(()=>_saturday=!_saturday)),
                _buildCircleCheck(text: 'D',selected: _sunday,onTab: ()=>setState(()=>_sunday=!_sunday)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLabel({String text}){
    return InkWell(
      onTap: (){

      },
      enableFeedback: true,
      child: Container(
        height: 45,
        child: ListTile(
          title:Text(text,style: Theme.of(context).textTheme.subtitle,),
        ),
      ),
    );
  }

  Widget _buildContainer({Widget child,double width}){
    return Container(
      height: 48,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade200,
      ),
      child: LimitedBox(
        maxWidth: 100,
        child: Center(child: child)
      ),
    );
  }

  Widget _buildCircleCheck({String text='',bool selected=false,Function onTab})
  {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        height: 35,
        width: 35,
        child: CircleAvatar(
          backgroundColor: selected?Theme.of(context).primaryColor:Colors.grey.shade300,
          foregroundColor: selected?Colors.white:Colors.black,
          child: Text(text),
        ),
      ),
    );
  }

  void _onSubmit(){

  }
}