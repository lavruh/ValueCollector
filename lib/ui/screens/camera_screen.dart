import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/camera_state.dart';
import 'package:rh_collector/ui/widgets/cam_prev_widget.dart';

// TODO check if screen turned
// TODO text field decoration
class CameraScreen extends StatefulWidget {
  CameraScreen({Key? key})
      : state = Get.find<CameraState>(),
        super(key: key);
  CameraState state;
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  TextEditingController textCtrl = TextEditingController();
  @override
  void initState() {
    widget.state.initCamera();
    super.initState();
  }

  @override
  void dispose() {
    widget.state.disposeCamera();
    widget.state.saveState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dispose();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          // backgroundColor: Colors.black12,
          body: SingleChildScrollView(
            child: Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                CamPrevWidget(),
                FloatingActionButton(
                  child: const Icon(Icons.camera),
                  onPressed: () {
                    widget.state.takePhoto();
                  },
                ),
                ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width),
                    child: GetBuilder<CameraState>(
                      builder: (_) {
                        if (textCtrl.text != _.reading.value) {
                          textCtrl.text = _.reading.value;
                        }
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
        ),
      ),
    );
  }
}
