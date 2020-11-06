import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/controller/intersrted_buyer_controller.dart';
import 'package:real_estate/modal/interested_buyer_modal.dart';
import 'package:real_estate/user_chat/change_email_address.dart';
import 'package:real_estate/user_chat/chat.dart';

import 'data.dart';

class Detail extends StatefulWidget {
  final Property property;

  Detail({@required this.property});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int tagChange = 0;

  List<String> interest = ['not interested', 'interested'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.property.frontImage,
            child: Container(
              height: size.height * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.property.frontImage)
                          .toString()
                          .contains('http')
                      ? NetworkImage(widget.property.frontImage)
                      : AssetImage('assets/images/default_property.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.4, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: size.height * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.property.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.favorite,
                            color: Colors.pink,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 8,
                    bottom: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            widget.property.location,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Icon(
                            Icons.zoom_out_map,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            widget.property.sqm,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    widget.property.ownerName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Property Owner",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  ChipsChoice<int>.single(
                                    value: tagChange,
                                    onChanged: (val) => setState(() {
                                      tagChange = val;
                                      // print(options[tag]);
                                    }),
                                    choiceItems: C2Choice.listFrom<int, String>(
                                      source: interest,
                                      value: (i, v) => i,
                                      label: (i, v) => v,
                                    ),
                                  ),
                                  tagChange == 1
                                      ? InkWell(
                                          onTap: () {
                                            InterestedBuyerModal
                                                interestedBuyerForm =
                                                InterestedBuyerModal(
                                                    Provider.of<ChangeEmailAddress>(
                                                            context,
                                                            listen: false)
                                                        .emailAddress,
                                                    widget.property.name,
                                                    widget.property.place,
                                                    widget.property.location);
                                            InterestedBuyerController
                                                interestedBuyerController =
                                                InterestedBuyerController();
                                            //save the interested user to sheet
                                            interestedBuyerController
                                                .submitForm(interestedBuyerForm,
                                                    (String response) {
                                              print(
                                                  "interested buyer response: $response");
                                              if (response ==
                                                  InterestedBuyerController
                                                      .STATUS_SUCCESS) {
                                                print(
                                                    "Interested Buyer data saved successfully");
                                              } else {
                                                print(
                                                    "Error saving interested Buyer Data");
                                              }
                                            });

                                            Navigator.pushNamed(
                                                context, ChatScreen.id);
                                          },
                                          child: Text(
                                            'Chat with Admin',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.blueAccent),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                          //TODO Write the Phone No and link it to AutoLauncher
                        ],
                      ),
                    ),
//                    Padding(
//                      padding: EdgeInsets.only(
//                        right: 24,
//                        left: 24,
//                        bottom: 24,
//                      ),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: [
//                          buildFeature(Icons.hotel, "3 Bedroom"),
//                          buildFeature(Icons.wc, "2 Bathroom"),
//                          buildFeature(Icons.kitchen, "1 Kitchen"),
//                          buildFeature(Icons.local_parking, "2 Parking"),
//                        ],
//                      ),
//                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: 24,
                        left: 24,
                        bottom: 16,
                      ),
                      child: Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: 24,
                        left: 24,
                        bottom: 24,
                      ),
                      child: Text(
                        widget.property.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
//                    Padding(
//                      padding: EdgeInsets.only(
//                        right: 24,
//                        left: 24,
//                        bottom: 16,
//                      ),
//                      child: Text(
//                        "Photos",
//                        style: TextStyle(
//                          fontSize: 20,
//                          fontWeight: FontWeight.bold,
//                        ),
//                      ),
//                    ),
//                    Expanded(
//                      child: Padding(
//                        padding: EdgeInsets.only(
//                          bottom: 24,
//                        ),
//                        child: ListView(
//                          physics: BouncingScrollPhysics(),
//                          scrollDirection: Axis.horizontal,
//                          shrinkWrap: true,
//                          children: buildPhotos(widget.property.images),
//                        ),
//                      ),
//                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFeature(IconData iconData, String text) {
    return Column(
      children: [
        Icon(
          iconData,
          color: Colors.blue,
          size: 28,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  List<Widget> buildPhotos(List<String> images) {
    List<Widget> list = [];
    list.add(SizedBox(
      width: 24,
    ));

    for (var i = 0; i < images.length; i++) {
      list.add(buildPhoto(images[i]));
    }

    return list;
  }

  Widget buildPhoto(String url) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Container(
        margin: EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          image: DecorationImage(
            image: AssetImage(url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
