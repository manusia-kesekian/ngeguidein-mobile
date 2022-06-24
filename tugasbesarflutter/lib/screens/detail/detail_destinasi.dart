import 'package:flutter/material.dart';
// import 'package:tugasbesarflutter/main.dart';
import 'package:tugasbesarflutter/models/Destinasi.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:tugasbesarflutter/models/komentar.dart';
import 'package:tugasbesarflutter/api.dart';

class DetailDestinasi extends StatefulWidget {
  const DetailDestinasi({Key? key, required this.destinasi}) : super(key: key);

  final Destinasi destinasi;

  @override
  State<DetailDestinasi> createState() => _DetailDestinasiState();
}

class _DetailDestinasiState extends State<DetailDestinasi> {
  // int _idDestinasi = Widget.destinasi.;
  late Future<List<Komentar>> futureKomentar;
  bool login = false;

  final komentarController = TextEditingController();
  final PanelController _panelController = PanelController();

  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  static const LatLng _kMapCenter =
      LatLng(-6.973316094903573, 107.63032874757012);
  static const CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 17.0, tilt: 0, bearing: 0);

  Set<Marker> _createMarker() {
    return {
      Marker(
          markerId: const MarkerId("M1"),
          position: const LatLng(-6.973316094903573, 107.63032874757012),
          infoWindow: InfoWindow(
              title: 'Telkom University',
              snippet: 'Click Here To Open On Google Maps',
              onTap: () => MapsLauncher.launchCoordinates(
                  -6.973316094903573, 107.63032874757012, 'Telkom University')),
          icon: BitmapDescriptor.defaultMarker),
    };
  }

  @override
  void initState() {
    super.initState();
    // if (login == true) {
    futureKomentar = fetchKomentar(widget.destinasi.idDestinasi);
    // }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    komentarController.dispose();
    super.dispose();
  }

  void togglePanel() {
    _panelController.isPanelOpen
        ? _panelController.close()
        : _panelController.open();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(217, 217, 217, 217),
          title: Text(
            widget.destinasi.namaTempat,
            style: const TextStyle(
              fontFamily: 'Poppins-Bold',
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: SlidingUpPanel(
          controller: _panelController,
          parallaxEnabled: true,
          parallaxOffset: 0.6,
          minHeight: MediaQuery.of(context).size.height * 0.1,
          panel: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  children: [
                    GestureDetector(
                      onTap: togglePanel,
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        height: 10,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade400),
                      ),
                    ),
                    Container(
                        margin:
                            const EdgeInsets.only(top: 5, left: 10, right: 10),
                        child: Column(children: [
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Center(
                                child: Text(
                                  widget.destinasi.namaTempat,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins-Bold',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: const Text(
                              "Informasi Terkait",
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            margin: const EdgeInsets.only(bottom: 10),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 30, right: 30),
                            child: Text(
                              widget.destinasi.deskripsi,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text('Foto',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child:
                                Image.asset('assets/img/danau.png', height: 70),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text('Komentar',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          login == true
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: komentarController,
                                        decoration: InputDecoration(
                                          fillColor: const Color(0x00C8C8C8),
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                          hintText: "Komentar..",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                width: 2,
                                                color: Color.fromARGB(
                                                    255, 59, 61, 58)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            futureKomentar = postKomentar(
                                                widget.destinasi.idDestinasi,
                                                3,
                                                komentarController.text);
                                          });
                                          komentarController.clear();
                                        },
                                        child: const Text('Kirim',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        style: ElevatedButton.styleFrom(
                                            onPrimary: Colors.white,
                                            primary: Color(0xFF1A2E35),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ))),
                                  ],
                                )
                              : Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: const Text(
                                    "Login Untuk Menambahkan Komentar",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                          FutureBuilder<List<Komentar>>(
                              future: futureKomentar,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<Komentar> data = snapshot.data!;
                                  // setState(() {
                                  //   _idDestinasi = data[0].idDestinasi;
                                  // });
                                  return Column(
                                    children: [
                                      for (var i = 0; i < data.length; i++)
                                        Card(
                                          margin: const EdgeInsets.all(10),
                                          child: ListTile(
                                            leading: Image.asset(
                                                'assets/img/profile.png',
                                                height: 30),
                                            // title: Text(data[i].name),
                                            title: Text(data[i].name),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(data[i].komentar),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  child:
                                                      Text(data[i].create_at),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                    ],
                                  );
                                  //  Text(data.length.toString());
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }

                                return const CircularProgressIndicator();
                              })
                          // Card(
                          //   margin: EdgeInsets.only(left: 30, right: 50),
                          //   child: ListTile(
                          //     leading: Image.asset('assets/img/profile.png',
                          //         height: 30),
                          //     title: Text('Elita - 23 Maret 2022'),
                          //     subtitle: Text('Hehe...'),
                          //   ),
                          // )
                        ])),
                  ],
                ),
              ],
            ),
          ),
          // collapsed: Container(
          //   decoration:
          //       BoxDecoration(color: Colors.white, borderRadius: radius),
          //   child: Center(
          //     child: Text(
          //       widget.destinasi.namaTempat,
          //       style: TextStyle(
          //         fontFamily: 'Poppins-Bold',
          //         color: Colors.black,
          //         fontWeight: FontWeight.bold,
          //         fontSize: 18,
          //       ),
          //     ),
          //   ),
          // ),
          borderRadius: radius,
          body: GoogleMap(
            initialCameraPosition: _kInitialPosition,
            myLocationEnabled: true,
            markers: _createMarker(),
            // mapToolbarEnabled: true,
            // onMapCreated: (GoogleMapController controller),
          ),
        ));
  }
}
