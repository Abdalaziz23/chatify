import 'dart:async';

import 'package:chatify/models/chat.dart';
import 'package:chatify/models/chat_message.dart';
import 'package:chatify/models/chat_user.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatsPageProvider extends ChangeNotifier
{
  AuthenticationProvider auth;

  late DatabaseServices db;

  List<Chat>? chats;

  late StreamSubscription chatsStream;

  ChatsPageProvider(this.auth){
    db = GetIt.instance.get<DatabaseServices>();
    getChats();
  }

  @override
  void dispose() {
    chatsStream.cancel();
    super.dispose();
  }

  void getChats() async
  {
    try{
      chatsStream = db.getChatsForUser(auth.chatUser.uid!).listen((snapshot) async {
        chats = await Future.wait(snapshot.docs.map((d) async {
          Map<String,dynamic> chatData = d.data() as Map<String,dynamic>;

          List<ChatUser> members = [];
          for(var uid in chatData['members']){
            DocumentSnapshot userSnapshot = await db.getUser(uid);
            Map<String,dynamic> userData = userSnapshot.data() as Map<String,dynamic>;
            userData['uid'] = userSnapshot.id;
            members.add(ChatUser.fromJson(userData),);
          }

          List<ChatMessage> messages = [];
          QuerySnapshot chatMessage = await db.getLastMessageForChat(d.id);
          if(chatMessage.docs.isNotEmpty){
            Map<String,dynamic> messageData = chatMessage.docs.first.data()! as Map<String,dynamic>;
            ChatMessage message = ChatMessage.fromJson(messageData);
            messages.add(message);
          }

          return Chat(
            uid: d.id,
            currentUserUid: auth.chatUser.uid!,
            members: members,
            messages: messages,
            activity: chatData['is_activity'],
            group: chatData['is_group'],
          );
        }).toList(),
        );
        notifyListeners();
      });
    }catch(e){
      print('Error getting chats');
      print(e);
    }
  }
}