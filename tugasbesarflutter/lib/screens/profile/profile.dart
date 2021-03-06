import 'package:flutter/material.dart';
import 'package:tugasbesarflutter/models/user.dart';
import 'editprofile.dart';
import 'package:tugasbesarflutter/api.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<User> _futureUser;
  String id = "";

  @override
  void initState() {
    super.initState();
    setState(() {});
    _futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 100.0,
                        backgroundImage: NetworkImage(
                          Apis.baseUrl + snapshot.data!.gambar,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            // ignore: use_full_hex_values_for_flutter_colors
                            primary: const Color(0xffff70d4e)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                        data: snapshot.data!,
                                      )));
                        },
                        child: Text('Edit Profil'),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        snapshot.data!.name,
                        style: TextStyle(
                          fontFamily: 'Poppins-Bold',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 150.0,
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        snapshot.data!.job,
                        style: TextStyle(
                          fontFamily: 'Poppins-Light',
                        ),
                      ),
                      Text(
                        snapshot.data!.faculty,
                        style: TextStyle(
                          fontFamily: 'Poppins-Light',
                        ),
                      ),
                      Text(
                        snapshot.data!.bio,
                        style: TextStyle(
                          fontFamily: 'Poppins-Light',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
