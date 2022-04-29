import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/asset_detail.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Scan extends StatefulWidget {
  const Scan({Key? key}) : super(key: key);

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  String _scanBarcode = 'Unknown';

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    final prefs = await SharedPreferences.getInstance();
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    if (!mounted) return;
    await prefs.setString('Invennumber', _scanBarcode);

    if (barcodeScanRes != null || barcodeScanRes != '') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Asset_detail()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[200]),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: const [
                          Text(
                            'Scan QR Code',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          Text('Scan for check inventory of',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black54)),
                          SizedBox(height: 6),
                          Text("information technology school's assets",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black54))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  Icon(
                    Icons.qr_code_2_outlined,
                    size: MediaQuery.of(context).size.height * 0.35,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: 50,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Color(0XFF0000D1)),
                      onPressed: () {
                        scanQR();
                      },
                      child: const Text('Scan QR'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
