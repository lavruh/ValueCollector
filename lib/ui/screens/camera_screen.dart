import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/camera_state.dart';
import 'package:rh_collector/ui/widgets/cam_prev_widget.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({super.key, this.meterName})
      : state = Get.find<CameraState>();
  final CameraState state;
  final String? meterName;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  TextEditingController textCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    widget.state.initCamera();
  }

  @override
  void dispose() {
    super.dispose();
    widget.state.disposeCamera();
    widget.state.saveState();
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
          appBar: AppBar(
            title: Text(widget.meterName ?? ""),
          ),
          body: SingleChildScrollView(
            child: Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const CamPrevWidget(),
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
                          textAlign: TextAlign.center,
                          onSubmitted: _setValue,
                          onChanged: _setValue,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
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

  _setValue(String val) {
    widget.state.reading.value = val;
  }
}
