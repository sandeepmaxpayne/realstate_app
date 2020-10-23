class BuyerModal {
  String name;
  String phoneNo;
  String email;
  String location;
  String place;
  String plotOption;
  String plotSize;
  String buyerOption;
  String startBudget;
  String endBudget;

  BuyerModal(
    this.name,
    this.phoneNo,
    this.email,
    this.location,
    this.place,
    this.plotOption,
    this.plotSize,
    this.buyerOption,
    this.startBudget,
    this.endBudget,
  );

  factory BuyerModal.fromJson(dynamic json) {
    //parameters must be same as json String value from URL get
    return BuyerModal(
      "${json['name']}",
      "${json['phoneNo']}",
      "${json['email']}",
      "${json['location']}",
      "${json['place']}",
      "${json['plotOption']}",
      "${json['plotSize']}",
      "${json['buyerOption']}",
      "${json['startingPrice']}",
      "${json['endPrice']}",
    );
  }

  //method to get parameters
  Map toJson() => {
        'name': name,
        'phoneNo': phoneNo,
        'email': email,
        'location': location,
        'place': place,
        'plotOption': plotOption,
        'plotSize': plotSize,
        'buyerOption': buyerOption,
        'startingPrice': startBudget,
        'endPrice': endBudget,
      };
}
