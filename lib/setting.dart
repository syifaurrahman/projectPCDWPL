import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 216, 216, 216),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                buildAccountButton(),
                buildAccountButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAccountButton() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.symmetric(
              horizontal:
                  BorderSide(color: const Color.fromARGB(255, 232, 232, 232))),
        ),
        child: Text(
          'Akun',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
