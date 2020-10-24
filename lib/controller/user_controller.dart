import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:real_estate/modal/user_modal.dart';

class UserController {
  // Google App Script Web URL
  //TODO url
  static const String URL =
      "https://script.google.com/macros/s/AKfycbzGAWi6BdApz9IDTKVCVY82xLoLP6bJzb3G3oA7Vt3V9imgBwk/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  ///async function which saves the form data , parses [FeedForm] parameters
  ///and sends HTTP GET request on [URL]. on success [callback] is called.

  void submitForm(UserModal feedForm, void Function(String) callback) async {
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
  Future<List<UserModal>> getFeedList() async {
    return await http.get(URL).then((response) {
      var jsonFeedResult = convert.jsonDecode(response.body) as List;
      print(
          "response: ${jsonFeedResult.map((v) => UserModal.fromJson(v).toJson())}");

      return jsonFeedResult.map((json) => UserModal.fromJson(json)).toList();
    });
  }
}
