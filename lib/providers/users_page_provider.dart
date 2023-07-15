import 'package:chatify/models/chat.dart';
import 'package:chatify/pages/chat_page.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/chat_user.dart';
import '../services/navigation_services.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider auth;

  late DatabaseServices database;
  late NavigationServices navigation;

  List<ChatUser>? users;
  late List<ChatUser> _selectedUsers;

  List<ChatUser> get selectedUsers {
    return _selectedUsers;
  }

  UsersPageProvider(this.auth) {
    _selectedUsers = [];
    database = GetIt.instance.get<DatabaseServices>();
    navigation = GetIt.instance.get<NavigationServices>();
    getUsers();
  }
  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    _selectedUsers = [];
    try {
      database
          .getUsers(
        name: name,
      )
          .then(
        (snapshot) {
          users = snapshot.docs.map(
            (doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data['uid'] = doc.id;
              return ChatUser.fromJson(data);
            },
          ).toList();
          notifyListeners();
        },
      );
    } catch (e) {
      print('Error');
      print(e);
    }
  }

  void updateSelectedUsers(ChatUser user) {
    if (_selectedUsers.contains(user)) {
      _selectedUsers.remove(user);
    } else {
      _selectedUsers.add(user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      List<String> membersIds =
          _selectedUsers.map((user) => user.uid!).toList();
      membersIds.add(auth.chatUser.uid!);
      bool isGroup = _selectedUsers.length > 1;
      DocumentReference? doc = await database.createChat(
        {
          'is_group': isGroup,
          'is_activity': false,
          'members': membersIds,
        },
      );
      List<ChatUser> members = [];
      for(var uid in membersIds){
        DocumentSnapshot userSnapshot = await database.getUser(uid);
        Map<String,dynamic> userData = userSnapshot.data() as Map<String,dynamic>;
        userData['uid'] = userSnapshot.id;
        members.add(ChatUser.fromJson(userData,),);
      }
      ChatPage chatPage = ChatPage(
          chat: Chat(
              uid: doc!.id,
              currentUserUid: auth.chatUser.uid!,
              members: members,
              messages: [],
              activity: false,
              group: isGroup,
          ));
      _selectedUsers = [];
      notifyListeners();
      navigation.navigateToPage(chatPage);
    } catch (e) {
      print(e);
    }
  }
}
