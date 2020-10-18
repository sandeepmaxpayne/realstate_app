import 'package:flutter/material.dart';
import 'values/styles.dart';

class ChatCard extends StatelessWidget {
  final String title1;
  final String title2;
  final String desc;
  final Function onPress;
  ChatCard({this.title1, this.title2, this.desc, this.onPress});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xff85e5ff),
      clipBehavior: Clip.antiAlias,
      elevation: 5.0,
      shadowColor: Theme.of(context).primaryColor,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.arrow_drop_down_circle),
            title: Text(
              title1,
              style: Styles.customTextStyle2(
                  fontSize: 16.0,
                  color: Color(0xFF2F2F2F),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal),
            ),
            subtitle: Text(
              title2,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              desc,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          FlatButton(
            color: Theme.of(context).primaryColor,
            onPressed: onPress,
            child: Text(
              'Enter',
              style: Styles.customTextStyle2(
                  fontSize: 16.0,
                  color: Color(0xFF2F2F2F),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal),
            ),
          ),
        ],
      ),
    );
  }
}
