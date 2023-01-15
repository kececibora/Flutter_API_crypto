import 'dart:convert';

class secondClass {
  late String pair;
  late double average;
  secondClass.fromJson(Map json) {
    this.pair = json['pair'];
    this.average = double.parse(json['average'].toString());
  }
}
