import 'package:flutter/material.dart';

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qscan/base/tost_utils.dart';
import 'package:qscan/base/util/string_utils.dart';
import 'package:qscan/home/bloc/home_bloc.dart';
import 'package:qscan/home/bloc/home_events.dart';
import 'package:qscan/home/bloc/home_state.dart';
import 'package:qscan/view_records/view/view_records.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../base/base_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  final myController = TextEditingController();

  bool isVerified = false;

  bool isLoaderVisisble = false;

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

  @override
  initState() {
    super.initState();
    // ignore: avoid_print
    print("initState Called");
    myController.addListener(() {
      BlocProvider.of<HomeBloc>(context).add(CheckRecordsValidation(myController.text));
      // isValidData(myController.text).then((value) {
      //   setState(() {
      //     isVerified = value;
      //   });
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();

      myController.text = '${result!.code}';
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('QScan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Move To View Records',
            onPressed: () {
              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This is a snackbar')));
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewRecords()));
            },
          )
        ],
      ),
      body: Container(
        color: Colors.pink.shade50,
        child: BlocListener<HomeBloc, BaseBlocState>(
          listener: (bloc, state) async {
            setState(() {
              isLoaderVisisble = state is StateContentLoading;
            });

            if (state is SaveRecordsSuccess) {
              state.message.showAsToast();
            }
            if (state is SaveRecordsError) {
              state.message.showAsToast();
            }
            if (state is RecordsValidationSuccess) {
              await AudioPlayer().play(AssetSource('audio/beep-08b.mp3'));
              setState(() {
                 isVerified = true;
              });
            }
            if (state is RecordsValidationError) {
              await AudioPlayer().play(AssetSource('audio/beep-03.mp3'));
              setState(() {
                 isVerified = false;
              });
            }
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.pink.shade100,
                  ),
                  child: Column(
                    children: [
                      Expanded(child: _buildQrView(context)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: buttonControls(context),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      const Text('QR Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 1),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.pinkAccent, width: 1),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: TextField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  enabled: false,
                                  controller: myController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                ),
                              ),
                              if (result != null)
                                Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Container(
                                          height: 1,
                                          color: Colors.grey,
                                        )),
                                    Image(
                                      height: 50,
                                      image: AssetImage(
                                        isVerified ? 'assets/images/approved.png' : 'assets/images/rejected.png',
                                      ),
                                    )
                                  ],
                                )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              Container(
                height: 40,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (isVerified) {
                      BlocProvider.of<HomeBloc>(context).add(SaveRecords(myController.text.toFormattedString()));
                    } else {
                      "Record Not Valid!".showAsToast();
                    }
                  },
                  child: FutureBuilder(
                    builder: (context, snapshot) {
                      return const Text('Submit');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 30,
          margin: const EdgeInsets.all(4),
          child: ElevatedButton(
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
              child: FutureBuilder(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  return Text('Flash: ${snapshot.data == true ? 'On' : 'Off'}');
                },
              )),
        ),
        Container(
          height: 30,
          margin: const EdgeInsets.all(4),
          child: ElevatedButton(
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {});
              },
              child: FutureBuilder(
                future: controller?.getCameraInfo(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Text('${describeEnum(snapshot.data!).toTitleCase()} Camera');
                  } else {
                    return const Text('loading');
                  }
                },
              )),
        ),
        Container(
          height: 30,
          margin: const EdgeInsets.all(4),
          child: ElevatedButton(
            onPressed: () async {
              await controller?.pauseCamera();
            },
            child: const Text('Pause'),
          ),
        ),
        Container(
          height: 30,
          margin: const EdgeInsets.all(4),
          child: ElevatedButton(
            onPressed: () async {
              await controller?.resumeCamera();
            },
            child: const Text('Resume'),
          ),
        )
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 350 || MediaQuery.of(context).size.height < 350) ? 150.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
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
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    myController.dispose();
    super.dispose();
  }
}
