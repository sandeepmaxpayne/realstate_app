import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/values/styles.dart';

class BuyerSearchPage extends StatefulWidget {
  @override
  _BuyerSearchPageState createState() => _BuyerSearchPageState();
}

class _BuyerSearchPageState extends State<BuyerSearchPage> {
  int tag = 0;
  List<String> interest = ['not interested', 'interested'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Icon(Icons.image),
          ),
          SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'price: ₹ 100',
              style: Styles.customTextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Location: ',
              style: Styles.customTextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Place: ',
              style: Styles.customTextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Square ft: ',
              style: Styles.customTextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ChipsChoice<int>.single(
              value: tag,
              onChanged: (val) => setState(() {
                tag = val;
                // print(options[tag]);
              }),
              choiceItems: C2Choice.listFrom<int, String>(
                source: interest,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          tag == 1
              ? Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: FlatButton(
                    onPressed: () {},
                    child: Text('Chat'),
                    color: Theme.of(context).accentColor,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
