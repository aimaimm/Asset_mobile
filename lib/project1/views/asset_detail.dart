import 'package:flutter/material.dart';
import 'package:flutter_application_1/project2/views/welcomscreen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Asset_detail extends StatefulWidget {
  const Asset_detail({Key? key}) : super(key: key);

  @override
  State<Asset_detail> createState() => _Asset_detailState();
}

class _Asset_detailState extends State<Asset_detail> {
  TextEditingController Text_building = TextEditingController();
  TextEditingController Text_room = TextEditingController();
  var url = 'http://192.168.100.12:3000/getitem';
  var url_update = 'http://192.168.100.12:3000/updateitem';
  String numinven = '';
  String nameinven = '';
  String invenlocation = '';
  String invenroom = '';
  String checkTxt = '';
  int status = 0;
  int dateend = 0;
  int _radioValue = 0;
  bool evaluate = false;

  Future<void> datadb() async {
    final prefs = await SharedPreferences.getInstance();
    final String? invennumber = prefs.getString('Invennumber');
    final String? inveninput = prefs.getString('Inveninput');
    // print(invennumber);
    Response response =
        await GetConnect().post(url, {'inventorynumber': invennumber , 'inventorynumber': inveninput});
    if (!response.status.isOk) {
      return Get.defaultDialog(title: 'Error', middleText: 'DB Error');
    }


    List data = response.body;
    if (data.length != 1) {
      return Get.defaultDialog(title: 'Error', middleText: 'Asset not found in our system' , onConfirm:() { Get.offAll(WelcomeScreen());});
    }

    setState(() {
      // Get data to ตัวแปร
      numinven = data[0]['Inventory_Number'];
      nameinven = data[0]['Asset_Description'];
      invenlocation = data[0]['Location'];
      invenroom = data[0]['Room'];
      status = data[0]['Status'];
      dateend = data[0]['DATEDIFFS'];
      // Set Radio
      if (status != 0 || dateend < 0) {
        _radioValue = 1;
      } else {
        _radioValue = 0;
      }

      // Fill data in textfield
      Text_building.text = invenlocation;
      Text_room.text = invenroom;
    });
  }

//Radio button
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
   
    datadb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color(0XFF0000D1),
        title: const Text('Asset detail'),
      ),
      body: Container(
        margin:const EdgeInsets.only(top: 15),
        padding:const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
           const Text(
              'Inventory number:',
              style: TextStyle(color: Colors.black45),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              numinven,
              style:const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(nameinven),
            const SizedBox(
              height: 13,
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 62,
              child: TextField(
                enabled: status == 0 && dateend >= 0 ? true : false,
                style:const TextStyle(fontSize: 15),
                controller: Text_building,
                // autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Building'),
                maxLines: 99,
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            SizedBox(
              height: 62,
              child: TextField(
                enabled: status == 0 && dateend >= 0 ? true : false,
                style: const TextStyle(fontSize: 15),
                controller: Text_room,
                // autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Room'),
                maxLines: 99,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Row(
                children: [
                  Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: status == 0 && dateend >= 0 ?  _handleRadioValueChange: null),
                 const Text('Lost')
                ],
              ),
              Row(
                children: [
                  Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: status == 0 && dateend >= 0 ? _handleRadioValueChange: null),
                 const Text('Normal')
                ],
              ),
              Row(
                children: [
                  Radio(
                      value: 2,
                      groupValue: _radioValue,
                      onChanged: status == 0 && dateend >= 0 ? _handleRadioValueChange: null),
                 const Text('Degraded')
                ],
              ),
            ]),
            const SizedBox(
              height: 20,
            ),
            status == 0 && dateend >= 0
                ? SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 45,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary:const Color(0XFF0000D1)),
                      onPressed: updateinven,
                      child: const Text('Check'),
                    ),
                  )
                : const Text(
                    'Not in checking in period or this asset is checked',
                    style: TextStyle(fontSize: 20, color: Color(0XFF0000D1)),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> updateinven() async {
    final prefs = await SharedPreferences.getInstance();
    final String? invennumber = prefs.getString('Invennumber');
    final String? inveninput = prefs.getString('Inveninput');

    final building = Text_building.text;
    final room = Text_room.text;

    if (_radioValue != 1) {
      print('Please Select Normal');
    } else {
      Response response = await GetConnect().post(url_update,
          {'location': building, 'room': room, 'inventorynum': invennumber , 'inventorynum' : inveninput});
      // If Error
      if (!response.isOk) {
        return Get.defaultDialog(title: 'Error', middleText: response.body);
      } else {
        return Get.defaultDialog(title: 'Success', middleText: response.body , onConfirm: () {Get.offAll(WelcomeScreen());});
      }
    }
  }
}
