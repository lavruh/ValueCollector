import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:rh_collector/domain/states/camera_state.dart';

class CamPrevWidget extends StatelessWidget {
  CamPrevWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 350,
      child: GetBuilder<CameraState>(builder: (_) {
        if ((_.camCtrl != null) & (!_.camCtrl!.value.isInitialized)) {
          return Container(
            color: Colors.indigo,
            child: const Center(
              child: Text(
                "Camera not init",
              ),
            ),
          );
        } else {
          CameraController controller = _.camCtrl!;
          controller.unlockCaptureOrientation();
          return AspectRatio(
              aspectRatio: 1,
              child: CameraPreview(
                controller,
                child: CustomPaint(
                  painter: SelectorRect(),
                ),
              ));
        }
      }),
    );
  }
}

class SelectorRect extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: 200,
          height: 50,
        ),
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.redAccent
          ..strokeWidth = 3.0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
