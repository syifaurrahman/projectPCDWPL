import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:project/chatbotmail.dart';
import 'package:project/chatbotpage.dart';
import 'package:project/homepage.dart';
import 'package:project/chatbotverif.dart';
import 'package:project/setting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _pages = [
    SettingPage(),
    ChatBotPage(),
    HomePage(),
    MailPage(),
    ChatBotMail(),
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat Bot',
          style: TextStyle(
            color: Color.fromARGB(255, 43, 41, 43),
            fontSize: 20,
            fontFamily: 'eracake',
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        animationDuration: const Duration(milliseconds: 200),
        height: 60,
        backgroundColor: const Color.fromARGB(255, 216, 216,
            216), // Sesuaikan background dari CurvedNavigationBar
        color: const Color.fromARGB(255, 255, 255, 255),
        items: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 216, 216, 216),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(Icons.settings,
                color: const Color.fromARGB(255, 43, 41, 43), size: 24),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 216, 216, 216),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(Icons.message_outlined,
                color: const Color.fromARGB(255, 43, 41, 43), size: 24),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 216, 216, 216),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(Icons.account_circle_sharp,
                color: const Color.fromARGB(255, 43, 41, 43), size: 24),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 216, 216, 216),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(Icons.camera_alt,
                color: const Color.fromARGB(255, 43, 41, 43), size: 24),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 216, 216, 216),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(Icons.mail,
                color: const Color.fromARGB(255, 43, 41, 43), size: 24),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
