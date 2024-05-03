import 'package:camera/camera.dart';
import 'package:detect_tflite/controller/tts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:permission_handler/permission_handler.dart';

FlutterTts flutterTts = FlutterTts();

class CurrencyController extends GetxController {
  CurrencyController({required this.chosenLanguage});

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initCamera();
    initTFLite();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Tflite.close();
    cameraController.stopImageStream();
    cameraController.dispose();
  }

  String chosenLanguage = "en-US";
  String chosenModel = "currency";

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var isCameraInitialized = false;
  var cameraCount = 0;

  var x, y, w, h = 0.0;
  var label = "Default Label";

  initCamera() async {
    this.testTTS("Detecting", "en-US");
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.max,
      );

      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
      });

      isCameraInitialized = true;
      update();
    } else {
      print("Permission denied");
    }
  }

  initTFLite() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
      isAsset: true,
      numThreads: 2,
      useGpuDelegate: false,
    );

    print("init tflite");
  }

  testTTS(String speakText, String lang) async {
    List<dynamic> languages = await flutterTts.getLanguages;

    print(languages);

    await flutterTts.setLanguage(lang);

    await flutterTts.setSpeechRate(0.3);

    await flutterTts.setVolume(1.0);

    // await flutterTts.setPitch(1.0);

    await flutterTts.speak(speakText);
    // await flutterTts.isLanguageAvailable("en-US");

    // // iOS, Android and Web only
    // //see the "Pausing on Android" section for more info
    // await flutterTts.pause();

    // // iOS, macOS, and Android only
    // // await flutterTts.synthesizeToFile("Hello World", Platform.isAndroid ? "tts.wav" : "tts.caf");
    // await flutterTts.synthesizeToFile("Hello World", "tts.wav");

    // await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});

    // // iOS only
    // await flutterTts.setSharedInstance(true);

    // // Android only
    // await flutterTts.setSilence(2);

    // await flutterTts.getEngines;

    // await flutterTts.getDefaultVoice;

    // await flutterTts.isLanguageInstalled("en-AU");

    // await flutterTts.areLanguagesInstalled(["en-AU", "en-US"]);

    await flutterTts.setQueueMode(1);
    // await flutterTts.getMaxSpeechInputLength;
  }

  objectDetector(CameraImage image) async {
    print("this.chosenLanguage: $chosenLanguage");
    var detector = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((e) {
        return e.bytes;
      }).toList(),
      asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 2,
      rotation: 90,
      threshold: 0.1,
    );

    if (detector != null) {
      var ourDetectedObject = detector.first;
      print("Result is: $detector");
      if ((ourDetectedObject['confidence'] * 100) > 45) {
        label = ourDetectedObject['label'].toString();
        // h = ourDetectedObject['rect']['h'];
        // w = ourDetectedObject['rect']['w'];
        // x = ourDetectedObject['rect']['x'];
        // y = ourDetectedObject['rect']['y'];
      }
      print(ourDetectedObject);
      this.testTTS(ourDetectedObject['label'].toString(), this.chosenLanguage);
      // await Tflite.close();
      update();
    }
  }
}
