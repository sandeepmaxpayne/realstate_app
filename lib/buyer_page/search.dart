import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/controller/owner_controller.dart';
import 'package:real_estate/controller/realtor_controller.dart';
import 'package:real_estate/modal/owner_modal.dart';
import 'package:real_estate/modal/realtor_modal.dart';
import 'data.dart';
import 'detail.dart';
import 'filter.dart';

class Search extends StatefulWidget {
  static const id = "SearchPage";
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // List<Property> properties = getPropertyList();

  List<Property> properties = [];
  List<OwnerModal> ownerData = List<OwnerModal>();
  List<RealtorModal> realtorData = List<RealtorModal>();
  @override
  void initState() {
    super.initState();
    //Owner Controller
    OwnerController().getFeedList().then((ownerData) {
      setState(() {
        this.ownerData = ownerData;
        print("owner data: ${ownerData[0].toJson()}");
      });
    });
    //Realtor Controller
    RealtorController().getFeedList().then((realtorData) {
      setState(() {
        this.realtorData = realtorData;
        print("realtor Data: ${realtorData[0].toJson()}");
      });
    });
  }

  void getRealTimePropertyList() {
    // Add OwnerData List to Property List
    if (ownerData.length > 1) {
      for (int i = 0; i < ownerData.length - 1; i++) {
        properties.add(Property(
            label: "OWNER",
            ownerName: ownerData[i].name,
            name: ownerData[i].option,
            description: ownerData[i].amenity,
            frontImage: ownerData[i].imageLink,
            location: ownerData[i].location,
            place: ownerData[i].place,
            price: ownerData[i].price,
            review: "4.5",
            sqm: ownerData[i].area,
            contactNo: ownerData[i].phoneNo,
            images: [
              "assets/images/kitchen.jpg",
              "assets/images/bath_room.jpg",
              "assets/images/swimming_pool.jpg",
              "assets/images/bed_room.jpg",
              "assets/images/living_room.jpg",
            ]));
      }
    }
    // Add Realtor Data List to Property List
    if (realtorData.length > 1) {
      for (int i = 0; i < realtorData.length - 1; i++) {
        properties.add(Property(
          label: "REALTOR",
          ownerName: realtorData[i].name,
          name: realtorData[i].option,
          description: realtorData[i].amenity,
          frontImage: realtorData[i].imageUrl,
          location: realtorData[i].location,
          place: realtorData[i].place.split(' ')[0],
          price: realtorData[i].price,
          review: "4.5",
          sqm: realtorData[i].area,
          contactNo: realtorData[i].phoneNo,
          images: [
            "assets/images/kitchen.jpg",
            "assets/images/bath_room.jpg",
            "assets/images/swimming_pool.jpg",
            "assets/images/bed_room.jpg",
            "assets/images/living_room.jpg",
          ],
        ));
      }
    }
    properties = properties.toSet().toList();
  }

  final SearchBarController<Property> _searchBarController =
      SearchBarController();
  Future<List<Property>> _getALlPosts(String text) async {
    await Future.delayed(Duration(seconds: text.length == 4 ? 5 : 1));

    if (text.length > 15) throw Error();
    List<Property> posts = [];

    for (int i = 0; i < properties.length; i++) {
      posts.add(properties[i]);
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    getRealTimePropertyList();
    print("properties 1: $properties");
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchBar<Property>(
                  searchBarPadding: EdgeInsets.symmetric(horizontal: 16),
                  headerPadding: EdgeInsets.symmetric(horizontal: 16),
                  listPadding: EdgeInsets.symmetric(horizontal: 16),
                  onSearch: _getALlPosts,
                  searchBarController: _searchBarController,
                  placeHolder: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: 32,
                                child: Stack(
                                  children: [
                                    ListView(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        SizedBox(
                                          width: 24,
                                        ),
                                        buildFilter("Plot"),
                                        buildFilter("Apartment"),
                                        buildFilter("House"),
                                        SizedBox(
                                          width: 8,
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width: 28,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.centerRight,
                                            end: Alignment.centerLeft,
                                            stops: [0.0, 1.0],
                                            colors: [
                                              Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              Theme.of(context)
                                                  .scaffoldBackgroundColor
                                                  .withOpacity(0.0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                //    _showBottomSheet();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 16, right: 24),
                                child: Text(
                                  "Filters",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: 24, left: 24, top: 24, bottom: 12),
                        child: Row(
                          children: [
                            Text(
                              properties.length.toString(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Results found",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            children: buildProperties(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  cancellationWidget: Text("Cancel"),
                  emptyWidget: Center(
                      child: Text(
                    "No Results found",
                    style: TextStyle(fontSize: 24.0),
                  )),
                  header: Row(
                    children: <Widget>[
                      RaisedButton(
                        child: Text("sort"),
                        onPressed: () {
                          _searchBarController
                              .sortList((Property a, Property b) {
                            return a.price.compareTo(b.price);
                          });
                        },
                      ),
                      RaisedButton(
                        child: Text("Desort"),
                        onPressed: () {
                          _searchBarController.removeSort();
                        },
                      ),
                    ],
                  ),
                  onCancelled: () {
                    print("Cancelled triggered");
                  },
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  onItemFound: (Property property, int index) {
                    return ListTile(
                      title: buildProperty(property, index),
                    );
                  },
                  searchBarStyle: SearchBarStyle(
                      padding: EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(10.0)),
                  minimumChars: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilter(String filterName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          border: Border.all(
            color: Colors.grey[300],
            width: 1,
          )),
      child: Center(
        child: Text(
          filterName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  List<Widget> buildProperties() {
    List<Widget> list = [];
    for (var i = 0; i < properties.length; i++) {
      list.add(Hero(
          tag: properties[i].frontImage,
          child: buildProperty(properties[i], i)));
    }
    return list.toSet().toList();
  }

  Widget buildProperty(Property property, int index) {
    return GestureDetector(
      onTap: () {
        print("property : $property");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Detail(property: property)),
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 24),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Container(
          height: 210,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(property.frontImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          property.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          r"₹" + property.price,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              property.place,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
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
                              property.sqm + " sq/m",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow[700],
                              size: 14,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              property.review + " Reviews",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        builder: (BuildContext context) {
          return Wrap(
            children: [
              Filter(),
            ],
          );
        });
  }
}
