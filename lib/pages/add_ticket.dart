import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:negup/model/ticket_model.dart';
import 'package:negup/providers/data_provider.dart';
import 'package:negup/service/notification_service.dart';

class AddTicket extends ConsumerStatefulWidget {
  static String get routeName => 'addticket';
  static String get routeLocation => '/addticket';
  const AddTicket({Key? key}) : super(key: key);

  @override
  _MyAddState createState() => _MyAddState();
}

class _MyAddState extends ConsumerState<AddTicket> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff081029),
        elevation: 0,
        title: const Text(
          'Add Ticket',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
      ),
      body: buildBodyWidget(),
    );
  }

  buildBodyWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitleWidget(),
          const SizedBox(
            height: 20,
          ),
          buildDescWidget(),
          const SizedBox(
            height: 20,
          ),
          buildCurrentDate(),
          const SizedBox(
            height: 20,
          ),
          buildCurrentLocation(),
          const SizedBox(
            height: 20,
          ),
          buildUploadWidget(),
          const SizedBox(
            height: 60,
          ),
          buildSubmitButton()
        ],
      ),
    );
  }

  buildTitleWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Problem Title',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color(0xff081029)),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 55,
          //margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Colors.grey.withOpacity(0.7),
              width: 1.0,
            ),
          ),
          child: TextField(
            textAlign: TextAlign.left,
            maxLength: 100,
            controller: titleController,
            decoration: const InputDecoration(
                hintText: 'Enter problem title',
                border: InputBorder.none,
                counterText: ""),
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  buildDescWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Problem description',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color(0xff081029)),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 80,
          // margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
          // padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Colors.grey.withOpacity(0.7),
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: TextField(
            textAlign: TextAlign.justify,
            maxLines: 10,
            controller: descController,
            decoration: const InputDecoration(
              hintText: 'Enter problem description title',
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  String formatTimestamp(int timestamp) {
    var format = DateFormat('d MMM, hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return format.format(date);
  }

  buildCurrentDate() {
    int timestamp = ref.watch(dateProvider);
    String currentdate = formatTimestamp(timestamp);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current date',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xff081029)),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            //  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
            //padding: const EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width,
            //  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
            padding: const EdgeInsets.only(
              left: 10,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Colors.grey.withOpacity(0.7),
                width: 1.0,
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                currentdate,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
        ]);
  }

  buildCurrentLocation() {
    final lProvider = ref.watch(locationProvider);

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Location',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xff081029)),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            //  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
            padding: const EdgeInsets.only(
              left: 10,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Colors.grey.withOpacity(0.7),
                width: 1.0,
              ),
            ),
            alignment: Alignment.center,
            child: Align(
                alignment: Alignment.centerLeft,
                child: lProvider.when(
                  data: (data) => Text('${data.latitude} , ${data.longitude}',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87)),
                  error: (Object error, StackTrace stackTrace) {
                    return Container();
                  },
                  loading: () {
                    return Container();
                  },
                )),
          ),
        ]);
  }

  buildUploadWidget() {
    String uploadedPath = ref.watch(filePickProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Image',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color(0xff081029)),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  FilePickfromDevice();
                },
                icon: const Icon(Icons.attach_file)),
            const SizedBox(
              width: 10,
            ),
            Container(
                height: 80,
                // margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                //padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.7),
                    width: 1.0,
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.7,
                //  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                child: Text(
                  uploadedPath,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                )),
          ],
        ),
      ],
    );
  }

  buildSubmitButton() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        height: 50,
        child: ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xff081029)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Color(0xff081029))))),
            onPressed: () => checkValidate(),
            child: Text("Add Ticket".toUpperCase(),
                style: const TextStyle(fontSize: 14))),
      ),
    );
  }

  checkValidate() async {
    final location = ref.read(locationProvider);
    Position position = location.asData!.value;
    final currentdate = ref.read(dateProvider);
    final uploadedFilePath = ref.read(filePickProvider);
    if (titleController.text.isEmpty || descController.text.isEmpty) {
      showMessage('Please enter problem title and description');
    } else if (uploadedFilePath.isEmpty) {
      showMessage('Please attach your image');
    } else {
      try {
        TicketModel model = TicketModel(
            problemTitle: titleController.text,
            problemDesc: descController.text,
            location: GeoPoint(position.latitude, position.longitude),
            imagePath: uploadedFilePath,
            currentDate: currentdate);
        final dProvider = ref.read(databaseProvider);
        bool isAdded = await dProvider.addNewTicket(model);
        if (isAdded) {
          NotificationService().showLocalNotification('Ticket Raised success',
              'The requested has been created successfully! our team will contact you soon');
          showMessage("Ticket created successfully");
          context.pop();
        }
      } catch (e) {
        showMessage("Tickets adding failed!...");
        print(e);
      }
    }
  }

  showMessage(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        print("'Location permissions are permanently denied");
      } else {
        print("GPS Location service is granted");
      }
    } else {
      print("GPS Location permission granted.");
    }
  }

  void FilePickfromDevice() async {
    String filePath =
        await ref.read(databaseProvider).FilePickFromDevice(context);
    ref.read(filePickProvider.notifier).state = filePath;
  }

  void refreshProvider() {
    try {
      Future.delayed(const Duration(seconds: 0), () {
        ref.refresh(dateProvider);
        ref.refresh(filePickProvider);
        ref.refresh(locationProvider);
      });
    } catch (e) {}
  }
}
