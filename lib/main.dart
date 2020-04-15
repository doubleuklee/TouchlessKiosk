import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:touchless_kiosk_mobile/camera_view.dart';
import 'dart:async';


List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(new MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Touchless Kiosk',
      debugShowCheckedModeBanner: false,
      home: new TouchlessKioskAppPage(cameras:cameras),
    );
  }
}

class TouchlessKioskAppPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  TouchlessKioskAppPage({this.cameras});

  @override
  _TouchlessKioskAppPageState createState() => _TouchlessKioskAppPageState();
}

class _TouchlessKioskAppPageState extends State<TouchlessKioskAppPage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("손대기 싫어요!")
      ),
      body: CameraView(
        widget.cameras
      )

    );
  }
}
