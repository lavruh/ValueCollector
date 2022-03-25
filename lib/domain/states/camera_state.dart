import 'package:camera/camera.dart';
import 'package:get/get.dart';

abstract class CameraState extends GetxController {
  final reading = "".obs;
  CameraController? camCtrl;

  toggleFlashMode();
  takePhoto();
  void prepareImage(XFile pic);
  void disposeCamera();
  void initCamera();
  saveState();
  loadState();
}
