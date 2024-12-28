import 'package:flutter/material.dart';
import 'package:project/browseropener.dart';
import 'package:project/configuration/configuration.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.BG,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Teks di luar gambar
              Text(
                'Tap Gambar untuk melanjutkan',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10), // Jarak antara teks dan gambar
              // Gambar yang bisa diklik
              Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
