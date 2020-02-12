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

    if(newValue.text.length==0){
      return newValue;
    }
    // if(newValue.text.startsWith(_thousandsSeparator))
    //   return oldValue.copyWith(
    //     text: oldValue.text.substring(2,oldValue.text.length),
    //     selection: TextSelection.collapsed(offset: 0),
    //   );
    //print(oldValue.text.length-newValue.text.length);

    if(oldValue.text.length-newValue.text.length==1)print('('+oldValue.text.substring(oldValue.selection.start-1,oldValue.selection.end)+')');
    else print('('+oldValue.text.substring(oldValue.selection.start,oldValue.selection.end)+')');

    // Validamos la entrada del usuario
    // RegExp(r'^(?:-?(?:[0-9]+))?(?:\.[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?$'); Original regex
    RegExp regEx=RegExp('');
    if(_decimalRange>0)regEx=RegExp('^'+(_signed?'-?':'')+'(?:[0-9]+)?(?:[$_decimalSeparator][0-9]{0,$_decimalRange})?(?:[eE][\+\-]?(?:[0-9]+))?\$');
    else regEx=RegExp('^'+(_signed?'-?':'')+'(?:-?(?:[0-9]+))?\$');
    if(!regEx.hasMatch(newValue.text.replaceAll(RegExp(_thousandsSeparator),'')))return oldValue;

    String newText=newValue.text;
    int selectionOffset=newValue.selection.end;

    if(_thousandsSeparator.length>0 || _thousandsSeparator!=null && _isNumeric(newText)){
      newText=NumberFormat().format(double.parse(newValue.text.replaceAll(RegExp(_thousandsSeparator),'')));
      //if(_thousandsSeparator.allMatches(newText).length>0)selectionOffset=newValue.selection.end-1;
      // if(_thousandsSeparator.allMatches(newValue.text).length > _thousandsSeparator.allMatches(oldValue.text).length)
      selectionOffset=newText.length-(newValue.text.length - newValue.selection.end);
    }



    //return newValue;
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionOffset),
      //selection: selectionOffset,
      composing: TextRange.empty
    );
  }
  
  bool _isNumeric(String s) {
   if (s == null) {
     return false;
   }
   return double.tryParse(s) != null;
  }
}
