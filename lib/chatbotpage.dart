import 'package:flutter/material.dart';
import 'package:project/browseropener.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BrowserOpener(
                            url: "https://chatbot.page/ZUNEDy",
                          )));
            },
            child: Container(
              width: 200, // Atur lebar container
              height: 200, // Atur tinggi container
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image:
                      AssetImage('assets/images/Chatbot.jpeg'), // Path gambar
                  fit: BoxFit.cover, // Gambar menyesuaikan ukuran container
                ),
                borderRadius: BorderRadius.circular(25), // Radius border
              ),
            ),
          ),
        ),
      ),
    );
  }
}
