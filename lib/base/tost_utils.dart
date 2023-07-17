
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension StringExtensions on String {

  showAsToast(){
    Fluttertoast.showToast(
        msg: this,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  int parseInt() {
    return int.parse(this);
  }
  double parseDouble() {
    return double.parse(this);
  }
}