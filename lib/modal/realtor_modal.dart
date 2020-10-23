class RealtorModal {
  String imageUrl;
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

  RealtorModal(
    this.imageUrl,
    this.name,
    this.phoneNo,
    this.email,
    this.otherDoc,
    this.location,
    this.place,
    this.option,
    this.area,
    this.price,
    this.amenity,
  );

  factory RealtorModal.fromJson(dynamic json) {
    //parameters must be same as json String value from URL get
    return RealtorModal(
      "${json['imageUrl']}",
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
        'imageUrl': imageUrl,
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
