import 'package:chatify/models/chat_message.dart';
import 'package:chatify/models/chat_user.dart';

class Chat
{
  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  List<ChatMessage> messages;

  late final List<ChatUser> _recipients;

  Chat({
    required this.uid,
    required this.currentUserUid,
    required this.members,
    required this.messages,
    required this.activity,
    required this.group,
}){
    _recipients = members.where((i) => i.uid != currentUserUid).toList();
  }

  List<ChatUser> recipients()
  {
    return _recipients;
  }

  String? title()
  {
    return !group ? _recipients.first.name : _recipients.map((user) => user.name).join(", ");
  }

  String? imageURL()
  {
    return !group ? _recipients.first.imageURL : "https://img.freepik.com/free-photo/portrait-american-football-player-sports-equipment-isolated-black_155003-42264.jpg?w=740&t=st=1684946794~exp=1684947394~hmac=f68cd72078f733222d47df73a5e7eed06c0d41ca898498bffeb751e529bd9d70";
  }
}