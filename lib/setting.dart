import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 216, 216, 216),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: 20.0),
                buildAccountButton(),
                SizedBox(height: 20.0),
                buildAccountButton(),
              ],
            ),
            buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget buildAccountButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 20.0),
          backgroundColor:
              Colors.white, // Ganti 'primary' dengan 'backgroundColor'
          foregroundColor:
              Colors.black, // Ganti 'onPrimary' dengan 'foregroundColor'
          side: BorderSide(color: Colors.black),
        ),
        child: Text('Akun', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget buildLogoutButton() {
    return Container(
      width: 150,
      child: ElevatedButton(
        onPressed: () {
          // Tambahkan logika logout di sini
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 15.0),
          backgroundColor:
              Colors.white, // Ganti 'primary' dengan 'backgroundColor'
          foregroundColor:
              Colors.black, // Ganti 'onPrimary' dengan 'foregroundColor'
          side: BorderSide(color: Colors.black),
        ),
        child: Text('LogOut', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
