import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/recognizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart';

import 'package:rh_collector/di.dart';

class CameraState extends GetxController {
  CameraController? camCtrl =
      CameraController(cameras[0], ResolutionPreset.max);
  final settings = Get.find<SharedPreferences>();

  FlashMode flashMode = FlashMode.off;
  final reading = "".obs;
  File tmpFile = File("/storage/emulated/0/tmp.jpg");

  toggleFlashMode() {
    if ((flashMode.index + 1) == FlashMode.values.length) {
      flashMode = FlashMode.values.first;
    } else {
      flashMode = FlashMode.values[flashMode.index + 1];
    }
    camCtrl?.setFlashMode(flashMode);
    update();
  }

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

      prepareImage(pic);

      final rec = Get.find<Recognizer>();
      rec.inp = tmpFile;
      reading.value = rec.cleanString(await rec.recognizeReading());
    } on Exception catch (e) {
      Get.snackbar("Camera", e.toString());
    }
    update();
  }

  void prepareImage(XFile pic) async {
    Image src = decodeImage(await pic.readAsBytes())!;
    double widthRatio = 1;
    double heightRatio = 1;
    Size? ps = camCtrl!.value.previewSize;
    if (ps != null) {
      widthRatio = (src.width / 350);
      heightRatio = (src.height / 350);
    }
    Rect rect = Rect.fromCenter(
      center: Offset(src.width / 2, src.height / 2),
      width: 200 * widthRatio,
      height: 50 * heightRatio,
    );
    Image pImg = copyCrop(
      src,
      rect.topLeft.dx.toInt(),
      rect.topLeft.dy.toInt(),
      rect.width.toInt(),
      rect.height.toInt(),
    );
    await tmpFile.writeAsBytes(encodeJpg(pImg));
  }

  void disposeCamera() async {
    if (camCtrl != null) {
      await camCtrl!.dispose();
    }
  }

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

  saveState() async {}

  loadState() {
    update();
  }

  @override
  void onInit() {
    loadState();
    super.onInit();
  }
}
