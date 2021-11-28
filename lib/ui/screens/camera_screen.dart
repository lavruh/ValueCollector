import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/camera_state.dart';
import 'package:rh_collector/ui/widgets/cam_prev_widget.dart';

// TODO check if screen turned
// TODO flutter issue no cursor on text field
// TODO text field decoration
class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  TextEditingController textCtrl = TextEditingController();
  @override
  void initState() {
    Get.find<CameraState>().initCamera();
    super.initState();
  }

  @override
  void dispose() {
    Get.find<CameraState>().disposeCamera();
    Get.find<CameraState>().saveState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dispose();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: SingleChildScrollView(
          child: Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CamPrevWidget(),
              ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width),
                  child: GetBuilder<CameraState>(
                    builder: (_) {
                      textCtrl.text = _.reading.value;
                      print("set val build");
                      return TextField(
                        controller: textCtrl,
                        showCursor: true,
                        keyboardType: TextInputType.number,
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                        onSubmitted: (String val) {
                          _.reading.value = val;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            suffix: IconButton(
                                onPressed: () {
                                  Navigator.pop(context, _.reading.value);
                                },
                                icon: const Icon(Icons.check))),
                      );
                    },
                  )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.camera),
          onPressed: () {
            Get.find<CameraState>().takePhoto();
          },
        ),
      ),
    );
  }
}
