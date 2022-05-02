import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/project1/views/asset_detail.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController invencontroller = TextEditingController();
  String _scanBarcode = 'Unknown';

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
  void dispose() {
    invencontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF0000D1),
        title: const Text('ITschool Asset Checking'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Text('Summary of asset checking status'),
            Row(
              children: [
                Text('Lost: '),
                Text('Normal: '),
                Text('Degraded: '),
              ],
            ),
            Divider(),
            Text('Choose asset checking method'),
            Text('1. Input 15-digit inventory number'),
            SizedBox(
              height: 62,
              child: TextFormField(
                style: const TextStyle(fontSize: 15),
                controller: invencontroller,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Text is empty';
                  }
                  return null;
                },
                // autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Inventory Number'),
                maxLines: 99,
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(Icons.remove),
                      Text('Clear'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final isValid = _formKey.currentState?.validate();
                    setState(() {
                      if (isValid!) {
                        return;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.check_box_outline_blank_outlined),
                      Text('Check'),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Text('OR'),
            Text('2.Scan QR code of asset'),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.1,
              height: 50,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(primary: const Color(0XFF0000D1)),
                onPressed: () {
                  scanQR();
                },
                child: const Text('Scan QR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
