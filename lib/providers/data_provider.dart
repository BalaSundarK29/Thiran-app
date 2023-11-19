import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:negup/model/ticket_model.dart';
import 'package:path/path.dart';

final databaseProvider = Provider((ref) => FireStoreDataProvider());
final dateProvider = StateProvider((ref) {  
  var timestamp = DateTime.now().millisecondsSinceEpoch;
  return timestamp;
});

final locationProvider = FutureProvider<Position>((ref) async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  return position;
});

final filePickProvider = StateProvider<String>((ref) {
  return "";
});

class FireStoreDataProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _movies;

  Stream get allTickets => _firestore
      .collection("tickets")
      .orderBy('currentdate', descending: true)
      .snapshots();

  Future<bool> addNewTicket(TicketModel m) async {
    _movies = _firestore.collection('tickets');
    try {
      await _movies.add({
        'problemtitle': m.problemTitle,
        'problemdescription': m.problemDesc,
        'location': m.location,
        'image_path': m.imagePath,
        'currentdate': m.currentDate
      });
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }
 

  Future<String> FilePickFromDevice(BuildContext context) async {
    String uploadedPath = '';
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      final storageRef = FirebaseStorage.instance.ref();
      final metadata = SettableMetadata(contentType: "image/jpeg");

      if (file == null) return "";
      final fileName = basename(file.path);
      final destination = 'files/$fileName';

      try {
        showLoaderDialog(context);
        final taskSnapshot =
            await storageRef.child(destination).putFile(file, metadata);
        uploadedPath = await taskSnapshot.ref.getDownloadURL();
        Navigator.pop(context);
      } catch (e) {
        print('error occured');
        Navigator.pop(context);
      }
    }
    return uploadedPath;
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("File Uploading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
