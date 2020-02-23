import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberInputFormatter2 extends TextInputFormatter{

  bool _signed;
  int _decimalRange;
  String _decimalSeparator;
  String _thousandsSeparator;

  NumberInputFormatter2({
    
    String thousandsSeparator=',',
    String decimalSeparator='.',
    int decimalRange=0,
    bool signed=false
  }){
    _decimalSeparator=decimalSeparator;
    _thousandsSeparator=thousandsSeparator;
    _decimalRange=decimalRange;
    _signed=signed;
  }


  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    if(newValue.text.length==0)return newValue;
    if(newValue.text==',')return oldValue;

    // Validamos la entrada del usuario
    // RegExp(r'^(?:-?(?:[0-9]+))?(?:\.[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?$'); Original regex
    RegExp regEx=RegExp('');
    if(_decimalRange>0)regEx=RegExp(r'^'+(_signed?'-?':'')+'(?:[0-9]+)?(?:[$_decimalSeparator][0-9]{0,$_decimalRange})?(?:[eE][\+\-]?(?:[0-9]+))?\$');
    else regEx=RegExp('^'+(_signed?'-?':'')+'(?:-?(?:[0-9]+))?\$');
    //regEx=RegExp(r'^-?[0-9]\d*(\.\d{1,'+_decimalRange.toString()+r'})?$');
    if(!regEx.hasMatch(newValue.text.replaceAll(_thousandsSeparator,''))){
      return oldValue;
    }
    //if(!_isNumeric(oldValue.text))return oldValue;

    String newText=newValue.text;
    String oldText=oldValue.text;
    int selectionOffset=newValue.selection.end;

    if(_thousandsSeparator.length>0 && _thousandsSeparator!=null && _isNumeric(newText.replaceAll(RegExp(_thousandsSeparator),''))){
      //print(oldValue.selection.textInside(oldValue.text));
      String oldTextNumber=oldValue.text.replaceAll(_thousandsSeparator, '');
      String newTextNumber=newValue.text.replaceAll(_thousandsSeparator, '');
      selectionOffset=0;

      if((oldTextNumber.length == newTextNumber.length) && oldValue.selection.textInside(oldValue.text).length==0){
        //print(oldValue.selection.start.toString()+' - '+newValue.selection.extentOffset.toString());

        // 0 = delete
        // 1 = backspace
        if(oldValue.selection.start-newValue.selection.extentOffset==1){
          newText=oldText.replaceRange(oldValue.selection.start-2,oldValue.selection.end,'');
        }
        else{
          newText=oldText.replaceRange(oldValue.selection.start,oldValue.selection.end+2,'');
          selectionOffset++;
        }  

        //print((oldValue.selection.start).toString()+' '+(oldValue.selection.end).toString());
      }

      NumberFormat format=NumberFormat();
      if(newText.substring(newText.length-1,newText.length)=='.'){
        newText=format.format(double.parse(newText.replaceAll(_thousandsSeparator, '')));
        newText=newText+'.';
      }
      else {
        newText=format.format(double.parse(newText.replaceAll(_thousandsSeparator, '')));
      }
      newText=newText.replaceAll('.',_decimalSeparator);
      newText=newText.replaceAll(',',_thousandsSeparator);
      
      selectionOffset+=newText.length-(newValue.text.length - newValue.selection.end);
      if(selectionOffset<0)selectionOffset=0;
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionOffset),
      //selection: selectionOffset,
      composing: TextRange.empty
    );
  }
  
  bool _isNumeric(String s) {
   if (s == null)return false;
   return double.tryParse(s) != null;
  }
}
