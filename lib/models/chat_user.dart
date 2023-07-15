class ChatUser {
  String? uid;
  String? name;
  String? email;
  String? imageURL;
  late DateTime? lastActive;

  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageURL,
    required this.lastActive,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
        uid : json['uid'],
        name : json['name'],
        email : json['email'],
        imageURL : json['image'],
        lastActive : json['last_active'].toDate(),
    );
    // uid = json['uid'];
    // name = json['name'];
    // email = json['email'];
    // imageURL = json['image'];
    // lastActive = json['last_active'].toDate();
  }
  Map<String, dynamic> toMap()
  {
    return {
      'email':email,
      'name':name,
      'last_active':lastActive,
      'image':imageURL,
    };
  }
  String lastDayActive()
  {
    return "${lastActive!.month}/${lastActive!.day}/${lastActive!.year}";
  }

  bool wasRecentlyActive()
  {
    return DateTime.now().difference(lastActive!).inHours < 2;
  }
}
