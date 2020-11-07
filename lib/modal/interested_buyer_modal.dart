class InterestedBuyerModal {
  String interestedBuyerEmail;
  String interestedPropertyName;
  String interestedPropertyPlace;
  String interestedPropertyLocation;
  String plotSize;

  InterestedBuyerModal(
      this.interestedBuyerEmail,
      this.interestedPropertyName,
      this.interestedPropertyPlace,
      this.interestedPropertyLocation,
      this.plotSize);

  factory InterestedBuyerModal.fromJson(dynamic json) {
    //parameters must be same as json String value from URL get
    return InterestedBuyerModal(
        "${json['interestedBuyerEmail']}",
        "${json['interestedPropertyName']}",
        "${json['interestedPropertyPlace']}",
        "${json['interestedPropertyLocation']}",
        "${json['plotSize']}");
  }

  //method to get parameters
  Map toJson() => {
        'interestedBuyerEmail': interestedBuyerEmail,
        'interestedPropertyName': interestedPropertyName,
        'interestedPropertyPlace': interestedPropertyPlace,
        'interestedPropertyLocation': interestedPropertyLocation,
        'plotSize': plotSize
      };
}
