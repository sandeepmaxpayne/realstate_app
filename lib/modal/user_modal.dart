class UserModal {
  String name;
  String email;
  String phoneNo;
  String address;

  UserModal(this.name, this.email, this.phoneNo, this.address);

  factory UserModal.fromJson(dynamic json) {
    //parameters must be same as json String value from URL get
    return UserModal("${json['name']}", "${json['email']}",
        "${json['phoneNo']}", "${json['address']}");
  }

  //method to get parameters
  Map toJson() =>
      {'name': name, 'email': email, 'phoneNo': phoneNo, 'address': address};
}
