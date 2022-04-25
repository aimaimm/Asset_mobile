import 'package:flutter/material.dart';

class Asset_detail extends StatefulWidget {
  const Asset_detail({Key? key}) : super(key: key);

  @override
  State<Asset_detail> createState() => _Asset_detailState();
}

class _Asset_detailState extends State<Asset_detail> {
  var inventory_number = 41205555;
  TextEditingController Text_building = TextEditingController();
  TextEditingController Text_room = TextEditingController();
  bool _value = false;
  int val = 1;

  int _radioValue = 0;

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
            Text('Inventory number:'),
            Text('$inventory_number'),
            Text('Aseet description'),
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
              onPressed: () {},
              child: Text('Check'),
            ),
          ],
        ),
      ),
    );
  }
}
