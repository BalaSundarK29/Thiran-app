import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

String ticketModelToJson(TicketModel data) => json.encode(data.toJson());

class TicketModel {
  String? problemTitle;
  String? problemDesc;

  String? imagePath;
  GeoPoint? location;
  int? currentDate;

  TicketModel({
    required this.problemTitle,
    required this.problemDesc,
    required this.location,
    required this.imagePath,
    required this.currentDate,
  });

  TicketModel.fromMap(DocumentSnapshot data) {
    problemTitle = data["problemtitle"];
    problemDesc = data["problemdescription"];
    location = data["location"];
    imagePath = data["image_path"];
    currentDate = data["currentdate"];
  }

  Map<String, dynamic> toJson() => {
        "problemtitle": problemTitle,
        "problemdescription": problemDesc,
        "location": location,
        "image_path": imagePath,
        "currentdate": currentDate,
      };
}
