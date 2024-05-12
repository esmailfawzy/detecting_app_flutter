import 'package:detect_tflite/controller/tts_controller.dart';
import 'package:flutter/material.dart';
import 'package:detect_tflite/views/camera_view.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class LangView extends StatelessWidget {
  // final ttsController = TTSController();

  // CustomButton({Key key, this.buttonType}) : super(key: key);

  const LangView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Choose a language'),
        ),
        body: GetBuilder<TTSController>(
            init: TTSController(),
            builder: (controller) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        controller.testTTS("Hello", "en-US");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CameraView(
                                    lang: "ar",
                                  )),
                        );
                      },
                      child: Text('Arabic'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CameraView(
                                    lang: "en-US",
                                  )),
                        );
                      },
                      child: Text('English'),
                    ),
                  ],
                ),
              );
            }));
  }
}
