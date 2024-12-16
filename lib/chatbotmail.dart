import 'package:flutter/material.dart';
import 'package:project/configuration/configuration.dart';

class ChatBotMail extends StatefulWidget {
  const ChatBotMail({super.key});

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotMail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.BG,
      body: Center(
        child: Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 1,
                      color: Colors.black, // Ubah warna border menjadi hitam
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LAPORAN',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'ID : 12345',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8), // Memberikan jarak antara teks
                      const Text(
                        'Nama : John Doe',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Waktu : 17 Desember 2024, 15:30',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                          height: 8), // Memberikan jarak sebelum gambar
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://i.pinimg.com/736x/7b/9f/44/7b9f442dcea032fe7801e39cc4ea4b40.jpg', // Ganti dengan link gambar yang diinginkan
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Text('Gambar tidak dapat dimuat'),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
