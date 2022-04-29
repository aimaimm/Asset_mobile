import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Asset_detail extends StatefulWidget {
  const Asset_detail({Key? key}) : super(key: key);

  @override
  State<Asset_detail> createState() => _Asset_detailState();
}

class _Asset_detailState extends State<Asset_detail> {
  var inventory_number = 580500100260002;
  TextEditingController Text_building = TextEditingController();
  TextEditingController Text_room = TextEditingController();
  bool _value = false;
  var url = 'http://10.0.2.2:3000/getitem';
  var url_update = 'http://10.0.2.2:3000/updateitem';
  String numinven = '';
  String nameinven = '';
  String invenlocation = '';
  String invenroom = '';
  int _radioValue = 0;

  Future<void> datadb() async {
    Response response =
        await GetConnect().post(url, {'inventorynumber': inventory_number});
    if (!response.status.isOk) {
      return Get.defaultDialog(title: 'Error', middleText: response.body);
    }

    List data = response.body;
    if (data.length != 1) {
      return Get.defaultDialog(title: 'Error', middleText: 'No Data');
    }

    setState(() {
      // Get data to ตัวแปร
      numinven = data[0]['Inventory_Number'];
      nameinven = data[0]['Asset_Description'];
      invenlocation = data[0]['Location'];
      invenroom = data[0]['Room'];

      // Fill data in textfield
      Text_building.text = invenlocation;
      Text_room.text = invenroom;
    });
  }

  void _handleRadioValueChange(int? value) {
    setState(() {
      _radioValue = value!;

      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    datadb();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset detail'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Text(numinven),
            Text(nameinven),
            SizedBox(
              height: 13,
            ),
            SizedBox(
              height: 62,
              child: TextField(
                style: TextStyle(fontSize: 15),
                controller: Text_building,
                // autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Building'),
                maxLines: 99,
              ),
            ),
            SizedBox(
              height: 13,
            ),
            SizedBox(
              height: 62,
              child: TextField(
                style: TextStyle(fontSize: 15),
                controller: Text_room,
                // autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Room'),
                maxLines: 99,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Row(
                children: [
                  Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange),
                  Text('Lost')
                ],
              ),
              Row(
                children: [
                  Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange),
                  Text('Normal')
                ],
              ),
              Row(
                children: [
                  Radio(
                      value: 2,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange),
                  Text('Degraded')
                ],
              ),
            ]),
            ElevatedButton(
              onPressed: updateinven ,
              child: Text('Check'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateinven() async {
    final building = Text_building.text;
    final room = Text_room.text;

    if (_radioValue != 1) {
      print('Please Select Normal');
    } else {
      Response response = await GetConnect().post(url_update, {
        'location': building,
        'room': room,
        'inventorynum': inventory_number
      });
      // If Error
      if (!response.isOk) {
        return Get.defaultDialog(title: 'Error', middleText: response.body);
      }
      else{
        return Get.defaultDialog(title: 'Success', middleText: response.body);
      }
    }
  }
}
