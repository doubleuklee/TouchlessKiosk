import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:touchless_kiosk_mobile/camera_view.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:torch/torch.dart';



List<CameraDescription> cameras;
final gServerIp = 'http://192.168.0.4:5000/';
String positionX, positionY;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(new MyApp());
}

Future<String> postReply() async {
  var addr = gServerIp + 'post';
  var response = await http.post(addr, body: {'dx': positionX, 'dy': positionY}); 

  // 200 ok. 정상 동작임을 알려준다.
  if (response.statusCode == 200) {
    return response.body;
  } else {
    print("error");
  }
    
  
  // 데이터 수신을 하지 못했다고 예외를 일으키는 것은 틀렸다.
  // 여기서는 코드를 간단하게 처리하기 위해.
  throw Exception('데이터 수신 실패!');
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

  var message = "sample";

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: () {
            },
            onTapDown: (TapDownDetails detail) {
              positionX = detail.globalPosition.dx.toStringAsFixed(0);
              positionY = (detail.globalPosition.dy - 150).toStringAsFixed(0);
              setState(() {
                message = "X : " + positionX + " / Y : " + positionY;
              });
              Future.delayed(Duration(milliseconds: 40), () => Torch.flash(Duration(milliseconds: 20)));
              Torch.flash(Duration(milliseconds: 20));
              try {
                postReply()
                .then((recvd) => print(recvd));
              } catch (e,s) {
                print(s);
              }
            },

            child: Container(
              child: CameraView(
                widget.cameras
              ),
            ),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 20),
          ),
        ]
      ),
    );
  }
}
