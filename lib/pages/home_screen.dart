import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:negup/model/ticket_model.dart';
import 'package:negup/providers/data_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  static String get routeName => 'home';
  static String get routeLocation => '/home';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    checkLocationPermission();
    final database = ref.watch(databaseProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff081029),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Home Page',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: database.allTickets,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.error != null) {
            return const Center(child: Text('Document Read failed..'));
          }
          return TicketListWidget(snapshot.data.docs);
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            backgroundColor: const Color(0xff081029),
            onPressed: () {
              GoRouter.of(context).push('/addticket');
            },
            child: const Icon(
              Icons.add,
              size: 40,
            ),
          ),
        ),
      ),
    );
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
}

class TicketListWidget extends StatelessWidget {
  final List<QueryDocumentSnapshot> _ticketList;
  const TicketListWidget(this._ticketList, {super.key});

  @override
  Widget build(BuildContext context) {
    return _ticketList.isNotEmpty
        ? ListView.separated(
            itemCount: _ticketList.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.grey, thickness: 0.5),
            itemBuilder: (context, index) {
              TicketModel model = TicketModel.fromMap(_ticketList[index]);
              String formatteddate = formatTimestamp(model.currentDate!);
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color(0xff081029),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(width: 5.0, color: Color(0xff081029)),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: model.imagePath!,
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            Container(color: Color(0xff081029)),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextRow(
                              'ProblemTitle:', model.problemTitle, context),
                          const SizedBox(
                            height: 10,
                          ),
                          buildTextRow(
                              'ProblemDesc:', model.problemDesc, context),
                          const SizedBox(
                            height: 10,
                          ),
                          buildTextRow(
                              'Location:',
                              " ${model.location!.latitude},${model.location!.longitude}",
                              context),
                          const SizedBox(
                            height: 10,
                          ),
                          buildTextRow('Date:', formatteddate, context)
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )
        : const Center(child: Text('No Tickets yet'));
  }

  String formatTimestamp(int timestamp) {
    var format = DateFormat('d MMM, hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return format.format(date);
  }

  buildTextRow(title, msg, context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 5,
            child: Text(msg.toString(),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          )
        ],
      ),
    );
  }
}
