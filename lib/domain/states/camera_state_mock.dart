import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/camera_state.dart';

class CameraStateMock extends GetxController implements CameraState {
  @override
  final reading = "".obs;
  @override
  CameraController? camCtrl;

  @override
  toggleFlashMode() {}
  @override
  takePhoto() async {}
  @override
  void prepareImage(XFile pic) async {}
  @override
  void disposeCamera() async {}
  @override
  void initCamera() async {}
  @override
  saveState() async {}
  @override
  loadState() {}
}
