import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberInputFormatter2 extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    print(newValue);
    
    return newValue;
  }
  
}
