// To parse this JSON data, do////     final categoryModel = categoryModelFromJson(jsonString);import 'dart:convert';CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());class CategoryModel {  CategoryModel({    this.msg,    this.data,    this.code,  });  String msg;  List<Datum> data;  int code;  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(    msg: json["msg"] == null ? null : json["msg"],    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),    code: json["code"] == null ? null : json["code"],  );  Map<String, dynamic> toJson() => {    "msg": msg == null ? null : msg,    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),    "code": code == null ? null : code,  };}class Datum {  Datum({    this.id,    this.category,    this.icon,  });  String id;  String category;  String icon;  factory Datum.fromJson(Map<String, dynamic> json) => Datum(    id: json["id"] == null ? null : json["id"],    category: json["category"] == null ? null : json["category"],    icon: json["icon"] == null ? null : json["icon"],  );  Map<String, dynamic> toJson() => {    "id": id == null ? null : id,    "category": category == null ? null : category,    "icon": icon == null ? null : icon,  };}