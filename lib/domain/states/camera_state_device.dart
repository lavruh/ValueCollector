import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/camera_state.dart';
import 'package:rh_collector/domain/states/recognizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart';

import 'package:rh_collector/di.dart';

class CameraStateDevice extends GetxController implements CameraState {
  @override
  CameraController? camCtrl =
      CameraController(cameras[0], ResolutionPreset.max);
  final settings = Get.find<SharedPreferences>();

  FlashMode flashMode = FlashMode.off;
  @override
  final reading = "".obs;
  final rec = Get.find<Recognizer>();

  File tmpFile = File("$appDataPath/tmp.jpg");

  @override
  toggleFlashMode() {
    if ((flashMode.index + 1) == FlashMode.values.length) {
      flashMode = FlashMode.values.first;
    } else {
      flashMode = FlashMode.values[flashMode.index + 1];
    }
    camCtrl?.setFlashMode(flashMode);
    update();
  }

  @override
  takePhoto() async {
    Get.snackbar("Camera", "Take photo\n");
    if (!camCtrl!.value.isInitialized) {
      Get.snackbar("Camera", "Controller not init\n");
      initCamera();
      return null;
    }
    if (camCtrl!.value.isTakingPicture) {
      Get.snackbar("Camera", "CameraScreen busy\n");
      initCamera();
      return null;
    }
    try {
      XFile pic = await camCtrl!.takePicture();

      await prepareImage(pic);

      rec.inp = tmpFile;
      reading.value = rec.cleanString(await rec.recognizeReading());
    } on Exception catch (e) {
      Get.snackbar("Camera", e.toString());
    }
    update();
  }

  @override
  Future prepareImage(XFile pic) async {
    Image src = decodeImage(await pic.readAsBytes())!;

    Rect rect = Rect.fromCenter(
      center: Offset(src.width / 2, src.height / 2),
      width: src.width * 0.6,
      height: src.height * 0.072,
    );
    Image pImg = copyCrop(
      src,
      x: rect.topLeft.dx.toInt(),
      y: rect.topLeft.dy.toInt(),
      width: rect.width.toInt(),
      height: rect.height.toInt(),
    );
    await tmpFile.writeAsBytes(encodeJpg(pImg));
  }

  @override
  void disposeCamera() async {
    if (camCtrl != null) {
      await camCtrl!.dispose();
    }
  }

  @override
  void initCamera() async {
    camCtrl = CameraController(cameras[0], ResolutionPreset.max);

    camCtrl!.addListener(() {
      if (camCtrl!.value.hasError) {
        Get.snackbar(
            "Camera", 'Camera error ${camCtrl?.value.errorDescription}');
      }
    });

    try {
      await camCtrl!.initialize();
      await Future.wait([
        camCtrl!.setFlashMode(flashMode),
      ]);
    } on CameraException catch (e) {
      Get.snackbar("Camera", e.toString());
    }

    update();
  }

  @override
  saveState() async {}

  @override
  loadState() {
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadState();
  }
}
