import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      setState(() {
        if (_currentPage < 2) {
          _currentPage++;
        } else {
          _currentPage = 0; // Kembali ke halaman pertama
        }
      });

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 216, 216, 216), // Background body
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'SELAMAT DATANG DI PELAYANAN DESA',
                style: const TextStyle(
                  fontFamily: 'eracake', // Gaya font Vernon Adams Anton
                  fontSize: 30, // Ukuran font
                  fontWeight: FontWeight.w500, // Ketebalan teks
                  color: Color.fromARGB(255, 33, 33, 33), // Warna teks
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Color.fromARGB(120, 128, 128, 128),
                    ),
                  ],
                ),
                textAlign: TextAlign.center, // Menengahkan teks
              ),
              const SizedBox(height: 20), // Jarak antara teks dan container
              Container(
                width: 465,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 255, 255, 255)),
                  borderRadius:
                      BorderRadius.circular(20), // Mengatur radius sudut
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      20), // Sesuaikan border radius di sini juga
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 3, // Sesuaikan jumlah gambar
                    itemBuilder: (context, index) {
                      // Array path gambar
                      final images = [
                        'assets/images/image1.png',
                        'assets/images/image2.png',
                        'assets/images/image3.png',
                      ];
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          // Menghitung posisi
                          double value = 1.0;
                          if (_pageController.position.haveDimensions) {
                            value = _pageController.page! - index;
                            value = (value + 1).clamp(0.0, 1.0);
                          }
                          // Membuat efek fade dan scale
                          return Opacity(
                            opacity: value,
                            child: Transform(
                              transform: Matrix4.identity()
                                ..scale(value, value),
                              alignment: Alignment.center,
                              child:
                                  Image.asset(images[index], fit: BoxFit.cover),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 50), // Jarak di bawah container
            ],
          ),
        ),
      ),
    );
  }
}
