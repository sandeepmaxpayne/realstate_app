class GroupChatModal {
  String whatsAppLink;

  GroupChatModal(this.whatsAppLink);

  factory GroupChatModal.fromJson(dynamic json) {
    //parameters must be same as json String value from URL get
    return GroupChatModal("${json['whatsAppLink']}");
  }

  //method to get parameters
  Map toJson() => {'whatsAppLink': whatsAppLink};
}
