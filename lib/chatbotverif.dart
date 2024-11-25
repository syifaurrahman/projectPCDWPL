import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'dart:convert';
import 'dart:async';

class MailPage extends StatefulWidget {
  @override
  _MailPageState createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  String faceDetectionStatus = 'Ready to start detection';
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  int selectedCameraIndex = 1; // Default to front camera
  List<Map<String, dynamic>> boundingBoxes = [];
  List<Map<String, dynamic>> eyeBoxes = [];
  Timer? detectionTimer;
  bool isDetecting = false;
  bool showSuccessMessage = false;
  bool showErrorMessage = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    if (cameras!.isNotEmpty) {
      // Use front camera as default
      await setCamera(selectedCameraIndex);
    } else {
      setState(() {
        faceDetectionStatus = 'No cameras available';
      });
    }
  }

  Future<void> setCamera(int index) async {
    if (cameraController != null) {
      detectionTimer?.cancel();
      await cameraController!.dispose();
    }

    cameraController = CameraController(
      cameras![index],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await cameraController!.initialize();
      if (!mounted) return;

      setState(() {
        selectedCameraIndex = index;
        isCameraInitialized = true;
      });
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  void toggleDetection() {
    if (!isDetecting) {
      setState(() {
        isDetecting = true;
        faceDetectionStatus = 'Detection started';
        boundingBoxes.clear();
        eyeBoxes.clear();
        showSuccessMessage = false;
        showErrorMessage = false;
      });
      startRealtimeDetection();
    } else {
      setState(() {
        isDetecting = false;
        faceDetectionStatus = 'Detection stopped';
        boundingBoxes.clear();
        eyeBoxes.clear();
      });
      detectionTimer?.cancel();
    }
  }

  void startRealtimeDetection() {
    detectionTimer?.cancel();
    detectionTimer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      if (mounted &&
          isCameraInitialized &&
          cameraController!.value.isInitialized &&
          isDetecting) {
        try {
          final image = await cameraController!.takePicture();
          await detectFaces(image.path);
        } catch (e) {
          print("Error capturing image: $e");
          showError("Error capturing image");
        }
      }
    });
  }

  void showSuccess(String message) {
    setState(() {
      showSuccessMessage = true;
      showErrorMessage = false;
      faceDetectionStatus = message;
    });
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showSuccessMessage = false;
        });
      }
    });
  }

  void showError(String message) {
    setState(() {
      showErrorMessage = true;
      showSuccessMessage = false;
      faceDetectionStatus = message;
    });
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showErrorMessage = false;
        });
      }
    });
  }

  Future<void> detectFaces(String imagePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.56.1:5000/detect'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imagePath,
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(responseData);
        if (mounted) {
          setState(() {
            boundingBoxes.clear();
            eyeBoxes.clear();

            for (var item in data) {
              if (item['bounding_box'] != null) {
                boundingBoxes.add(item['bounding_box']);
                if (item['eyes'] != null) {
                  eyeBoxes
                      .addAll(List<Map<String, dynamic>>.from(item['eyes']));
                }

                if (item['saved'] == true) {
                  showSuccess("Face successfully captured!");
                  isDetecting = false;
                  detectionTimer?.cancel();
                }
              }
            }
          });
        }
      }
    } catch (e) {
      showError("Connection error: Please check server connection");
      isDetecting = false;
      detectionTimer?.cancel();
    }
  }

  @override
  void dispose() {
    detectionTimer?.cancel();
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview with original aspect ratio
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: cameraController!.value.aspectRatio,
              child: CameraPreview(cameraController!),
            ),
          ),

          // Face Bounding Boxes
          ...boundingBoxes.map((box) {
            return Positioned(
              left: box['x'].toDouble(),
              top: box['y'].toDouble(),
              child: Container(
                width: box['w'].toDouble(),
                height: box['h'].toDouble(),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 3),
                ),
              ),
            );
          }).toList(),

          // Eye Bounding Boxes
          ...eyeBoxes.map((box) {
            return Positioned(
              left: box['x'].toDouble(),
              top: box['y'].toDouble(),
              child: Container(
                width: box['w'].toDouble(),
                height: box['h'].toDouble(),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                ),
              ),
            );
          }).toList(),

          // Success Message
          if (showSuccessMessage)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  faceDetectionStatus,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Error Message
          if (showErrorMessage)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  faceDetectionStatus,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Control Panel
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
                  ElevatedButton(
                    onPressed: toggleDetection,
                    child: Text(
                        isDetecting ? 'Stop Detection' : 'Start Detection'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDetecting ? Colors.red : Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
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
