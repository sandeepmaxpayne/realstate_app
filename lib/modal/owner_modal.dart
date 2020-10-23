class OwnerModal {
  String imageLink;
  String name;
  String phoneNo;
  String email;
  String otherDoc;
  String location;
  String place;
  String option;
  String area;
  String price;
  String amenity;

  OwnerModal(
      this.imageLink,
      this.name,
      this.phoneNo,
      this.email,
      this.otherDoc,
      this.location,
      this.place,
      this.option,
      this.area,
      this.price,
      this.amenity);

  factory OwnerModal.fromJson(dynamic json) {
    //parameters must be same as json String value from URL get
    return OwnerModal(
      "${json['imageLink']}",
      "${json['name']}",
      "${json['phoneNo']}",
      "${json['email']}",
      "${json['otherDoc']}",
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
        'otherDoc': otherDoc,
        'location': location,
        'place': place,
        'option': option,
        'area': area,
        'price': price,
        'amenity': amenity,
      };
}
