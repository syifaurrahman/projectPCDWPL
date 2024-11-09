import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'dart:convert';

class MailPage extends StatefulWidget {
  @override
  _MailPageState createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  String faceDetectionStatus = 'Waiting for detection...';
  CameraController? cameraController;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);

    await cameraController?.initialize();
    if (!mounted) return;

    setState(() {
      isCameraInitialized = true;
    });
  }

  Future<void> startFaceDetection() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.126.223:5000/detect'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          faceDetectionStatus = data[0]["status"];
        });
      } else {
        setState(() {
          faceDetectionStatus = 'Error in detection: ${response.statusCode}';
        });
      }
    } catch (e) {
      print("Error connecting to the server: $e");
      setState(() {
        faceDetectionStatus = 'Failed to connect to the server';
      });
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Pratinjau kamera layar penuh
          if (isCameraInitialized)
            Positioned.fill(
              child: CameraPreview(cameraController!),
            )
          else
            Center(child: CircularProgressIndicator()),

          // Panel status deteksi di tengah layar
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    faceDetectionStatus,
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: startFaceDetection,
                    child: Text("Refresh Detection"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
