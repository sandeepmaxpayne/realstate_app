class AdminAddPropertyModal {
  String imageLink;
  String name;
  String phoneNo;
  String email;
  String location;
  String place;
  String option;
  String area;
  String price;
  String amenity;

  AdminAddPropertyModal(
      this.imageLink,
      this.name,
      this.phoneNo,
      this.email,
      this.location,
      this.place,
      this.option,
      this.area,
      this.price,
      this.amenity);

  factory AdminAddPropertyModal.fromJson(dynamic json) {
    //parameters must be same as json String value from URL get
    return AdminAddPropertyModal(
      "${json['imageLink']}",
      "${json['name']}",
      "${json['phoneNo']}",
      "${json['email']}",
      "${json['location']}",
      "${json['place']}",
      "${json['option']}",
      "${json['area']}",
      "${json['price']}",
      "${json['amenity']}",
    );
  }

  //method to get parameters
  Map toJson() => {
        'imageLink': imageLink,
        'name': name,
        'phoneNo': phoneNo,
        'email': email,
        'location': location,
        'place': place,
        'option': option,
        'area': area,
        'price': price,
        'amenity': amenity,
      };
}
