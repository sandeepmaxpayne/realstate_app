import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:real_estate/modal/realtor_modal.dart';

class RealtorController {
  // Google App Script Web URL
  //TODO url
  static const String URL = "";

  static const STATUS_SUCCESS = "SUCCESS";

  ///async function which saves the form data , parses [FeedForm] parameters
  ///and sends HTTP GET request on [URL]. on success [callback] is called.

  void submitForm(RealtorModal feedForm, void Function(String) callback) async {
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
  Future<List<RealtorModal>> getFeedList() async {
    return await http.get(URL).then((response) {
      var jsonFeedResult = convert.jsonDecode(response.body) as List;
      print(
          "response: ${jsonFeedResult.map((v) => RealtorModal.fromJson(v).toJson())}");

      return jsonFeedResult.map((json) => RealtorModal.fromJson(json)).toList();
    });
  }
}
