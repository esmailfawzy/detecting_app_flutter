import 'package:camera/camera.dart';
import 'package:detect_tflite/controller/scan_controller.dart';
import 'package:detect_tflite/controller/tts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key, required this.lang});

  final String lang;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
          init: ScanController(chosenLanguage: lang),
          builder: (controller) {
            return controller.isCameraInitialized
                ? Stack(
                    children: [
                      CameraPreview(controller.cameraController),
                      Positioned(
                        // top: (controller.y) * 700,
                        // right: (controller.x) * 500,
                        top: 200,
                        right: 100,
                        child: Container(
                          // width: controller.w * 100 * context.width / 100,
                          // height: controller.h * 100 * context.height / 100,
                          width: 300,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green, width: 4.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                color: Colors.white,
                                child: Text(controller.label),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(child: Text("Loading Preview..."));
          }),
    );
  }
}
