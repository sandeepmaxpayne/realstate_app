import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:real_estate/modal/interested_buyer_modal.dart';

class InterestedBuyerController {
  // Google App Script Web URL
  ///Interested buyer link
  static const String URL =
      "https://script.google.com/macros/s/AKfycbxbd_8tbr5KDCZc_0osXThHTn4JjIimW0X8R2DEy0zhR9EOSKL1/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  ///async function which saves the form data , parses [FeedForm] parameters
  ///and sends HTTP GET request on [URL]. on success [callback] is called.

  void submitForm(
      InterestedBuyerModal feedForm, void Function(String) callback) async {
    try {
      await http.post(URL, body: feedForm.toJson()).then((response) async {
        print("response code:${response.statusCode}");
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(url).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (ex) {
      print("exception occurred in webapp: $ex");
    }
  }

  //Method to get the users data
  Future<List<InterestedBuyerModal>> getFeedList() async {
    return await http.get(URL).then((response) {
      var jsonFeedResult = convert.jsonDecode(response.body) as List;
      print(
          "response: ${jsonFeedResult.map((v) => InterestedBuyerModal.fromJson(v).toJson())}");

      return jsonFeedResult
          .map((json) => InterestedBuyerModal.fromJson(json))
          .toList();
    });
  }
}
