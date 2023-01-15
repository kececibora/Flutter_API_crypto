import 'package:cointracker/second_layer.dart';

class firstClass {
  late List<secondClass> data;
  late bool success;

  firstClass.fromJson(Map json) {
    this.data = (json['data'] ?? [])
        .map((e) => secondClass.fromJson(e))
        .toList()
        .cast<secondClass>();
    this.success = json["success"];
  }
}
