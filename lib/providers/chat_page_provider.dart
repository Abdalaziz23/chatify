import 'dart:async';

import 'package:chatify/models/chat_message.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/cloud_storage_services.dart';
import 'package:chatify/services/database_services.dart';
import 'package:chatify/services/media_services.dart';
import 'package:chatify/services/navigation_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';
//eslam
class ChatPageProvider extends ChangeNotifier {
  late DatabaseServices db;
  late CloudStorageServices storage;
  late MediaServices media;
  late NavigationServices navigation;

  AuthenticationProvider auth;
  ScrollController messageListViewController;

  String chatID;
  List<ChatMessage>? messages;

  late StreamSubscription messagesStream;
  late StreamSubscription keyboardVisibilityStream;
  late KeyboardVisibilityController keyboardVisibilityController;

  String? _message;

  String get message {
    return message;
  }

  void set message(String value) {
    _message = value;
  }

  ChatPageProvider(this.chatID, this.auth, this.messageListViewController) {
    db = GetIt.instance.get<DatabaseServices>();
    storage = GetIt.instance.get<CloudStorageServices>();
    media = GetIt.instance.get<MediaServices>();
    navigation = GetIt.instance.get<NavigationServices>();
    keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
    listenToKeyboardChanges();
  }

  @override
  void dispose() {
    messagesStream.cancel();
    super.dispose();
  }

  void listenToMessages() {
    try {
      messagesStream = db.streamMessagesForChat(chatID).listen((snapshot) {
        List<ChatMessage> messagesChat = snapshot.docs.map(
          (m) {
            Map<String, dynamic> messageData = m.data() as Map<String, dynamic>;
            return ChatMessage.fromJson(messageData);
          },
        ).toList();
        messages = messagesChat;
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (messageListViewController.hasClients) {
            messageListViewController
                .jumpTo(messageListViewController.position.maxScrollExtent);
          }
        });
      });
    } catch (e) {
      print('Error getting messages');
      print(e);
    }
  }

  void listenToKeyboardChanges() {
    keyboardVisibilityStream =
        keyboardVisibilityController.onChange.listen((event) {
      db.updateChatData(
        chatID,
        {
          'is_activity':event,
        },
      );
    });
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage messageToSend = ChatMessage(
        senderID: auth.chatUser.uid!,
        type: MessageType.text,
        content: _message!,
        sendTime: DateTime.now(),
      );
      db.addMessageToChat(
        chatID,
        messageToSend,
      );
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? file = await media.pickImageFromLibrary();
      if (file != null) {
        String? downloadURL = await storage.saveChatImageToStorage(
          chatID,
          auth.chatUser.uid!,
          file,
        );
        ChatMessage messageToSend = ChatMessage(
          senderID: auth.chatUser.uid!,
          type: MessageType.image,
          content: downloadURL!,
          sendTime: DateTime.now(),
        );
        db.addMessageToChat(
          chatID,
          messageToSend,
        );
      }
    } catch (e) {
      print('Error getting messages');
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    db.deleteChat(chatID);
  }

  void goBack() {
    navigation.goBack();
  }
}
