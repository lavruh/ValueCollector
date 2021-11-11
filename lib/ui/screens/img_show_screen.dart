import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/camera_state.dart';

class ImgShowScreen extends StatefulWidget {
  const ImgShowScreen({Key? key}) : super(key: key);

  @override
  _ImgShowScreenState createState() => _ImgShowScreenState();
}

class _ImgShowScreenState extends State<ImgShowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CameraState>(builder: (_) {
        if (_.tmpFile != null) {
          return Center(child: Image.file(_.tmpFile));
        } else {
          return Container();
        }
      }),
    );
  }
}
