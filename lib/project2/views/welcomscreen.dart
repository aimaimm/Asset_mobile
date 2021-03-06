import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/project1/views/asset_detail.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  TextEditingController invencontroller = TextEditingController();
  String _scanBarcode = 'Unknown';
  int lost = 0;
  int normal = 0;
  int degraded = 0;
  final _formKey = GlobalKey<FormState>();

  var url_status = 'http://10.0.2.2:3000/status';
  Future<void> getstatus() async {
    Response response = await GetConnect().get(url_status);
    if (!response.isOk) {
      return Get.defaultDialog(
          title: 'Error', middleText: 'Database Status Error');
    }

    List data = response.body;
    print(data);
    setState(() {
      lost = data[0]['Item_Status'];
      normal = data[1]['Item_Status'];
      degraded = data[2]['Item_Status'];

      print(lost);
      print(normal);
      print(degraded);
    });
  }

  Future<void> inputinven() async {
    final prefs = await SharedPreferences.getInstance();
    String invennum = invencontroller.text;

    await prefs.setString('Inveninput', invennum);

    if (invennum.length == 15) {
      Get.to(Asset_detail());
    }
  }

  void clearinput() {
    setState(() {
      invencontroller.text = "";
    });
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
    // print(_scanBarcode);
    if (!mounted) return;
    await prefs.setString('Invennumber', _scanBarcode);

    if (barcodeScanRes != null || barcodeScanRes != '') {
      Get.to(Asset_detail());
    }
  }

  @override
  void initState() {
    getstatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0XFF0000D1),
          title: const Text('ITschool Asset Checking'),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Text('Summary of asset checking status'),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lost: ${lost}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      )),
                  SizedBox(width: 5),
                  Text('Normal: ${normal}',
                      style:
                          const TextStyle(fontSize: 15, color: Colors.green)),
                  const SizedBox(width: 5),
                  Text('Degraded: ${degraded}',
                      style: const TextStyle(fontSize: 15, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                thickness: 2,
                height: 20,
                indent: 20,
                endIndent: 10,
              ),
              Text('Choose asset checking method'),
              Text('1. Input 15-digit inventory number'),
              SizedBox(height: 13),
              Container(
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: invencontroller,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Inventory Number'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter Inventory number";
                            } else if (value.length != 15) {
                              return "Inventory number is 15 digits!";
                            } else
                              return null;
                          },
                        )
                      ],
                    )),
              ),
              const SizedBox(height: 10),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red[200]),
                      onPressed: clearinput,
                      child: Row(
                        children: const [
                          Icon(Icons.cancel_rounded),
                          Text('Clear'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        bool validate = _formKey.currentState!.validate();
                        inputinven();
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.check_box_outlined),
                          Text('Check'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(
                  thickness: 2, height: 20, indent: 20, endIndent: 10),
              const Text('OR'),
              const Text('2.Scan QR code of asset'),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0XFF0000D1)),
                  onPressed: () {
                    scanQR();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Scan QR'),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 24,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
