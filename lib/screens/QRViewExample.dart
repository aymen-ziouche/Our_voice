import 'dart:developer';
import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:our_voice/main.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);
  static String id = "QRViewExample";


  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  static bool loading=false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }


  void makeCameraWork() async {
    await controller!.pauseCamera();
    await controller!.resumeCamera();
  }

  Future<void> openLink(BuildContext context,String link) async{
    if(!loading){
      loading=true;
      final dlink =await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(link));
      // openArt(dlink!.link.queryParameters['openArt']!);
      loading=false;
    }

  }

  // void openArt(String artCode){
  //   controller?.pauseCamera();
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return ArtDetails.fromNet(artKey: artCode,);
  //   }),
  //   ).then((value) => controller?.resumeCamera());
  // }


  @override
  Widget build(BuildContext context) {
    if(result!=null){
      if(result!.code!=null){
        if(result!.code!.contains('openArt=')){
          Uri uri=Uri.parse(result!.code!);
          // openArt(uri.queryParameters['openArt']!);
        }
        else if(result!.code!.contains('ouractionart.page.link')){
          openLink(context,result!.code!);
        }
      }


    }


    if(!loading){
      makeCameraWork();
    }
    else{
      controller!.stopCamera();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan art qr code'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
    makeCameraWork();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${TZDateTime.now(MyApp.algiers!).toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
