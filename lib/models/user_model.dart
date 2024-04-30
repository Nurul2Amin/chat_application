import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? name;
  String? uuid;
  String? email;
  List<dynamic>? myChats;
  String? status;
  DateTime? lastOnline;

  UserData({
    this.name,
    this.uuid,
    this.email,
    this.myChats,
    this.status,
    this.lastOnline,
  });

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
    name: json["name"],
    uuid: json["uuid"],
    email: json["email"],
    myChats: json["my_chats"] == null ? [] : List<dynamic>.from(json["my_chats"].map((x) => x)),
    status: json["status"],
    lastOnline: json["lastOnline"] != null ? (json["lastOnline"] as Timestamp).toDate() : null,
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "uuid": uuid,
    "email": email,
    "my_chats": myChats == null ? [] : List<dynamic>.from(myChats!.map((x) => x)),
    "status": status,
    "lastOnline": lastOnline != null ? Timestamp.fromDate(lastOnline!) : null,
  };
}
