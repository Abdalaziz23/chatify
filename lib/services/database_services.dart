import 'package:chatify/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String userCollection = "Users";
const String chatCollection = "Chats";
const String messagesCollection = "messages";

class DatabaseServices {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  DatabaseServices();

  Future<void> createUser(
      String uid, String email, String name, String imageURL) async {
    try {
      await db.collection(userCollection).doc(uid).set({
        'email': email,
        'image': imageURL,
        'last_active': DateTime.now().toUtc(),
        'name': name,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String uid) {
    return db.collection(userCollection).doc(uid).get();
  }

  Stream<QuerySnapshot> getChatsForUser(String uid) {
    return db
        .collection(chatCollection)
        .where(
          'members',
          arrayContains: uid,
        )
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String chatID) {
    return db
        .collection(chatCollection)
        .doc(chatID)
        .collection(messagesCollection)
        .orderBy(
          'sent_time',
          descending: true,
        )
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String chatID) {
    return db
        .collection(chatCollection)
        .doc(chatID)
        .collection(messagesCollection)
        .orderBy(
          'sent_time',
          descending: false,
        )
        .snapshots();
  }

  Future<void> addMessageToChat(String chatID, ChatMessage message) async {
    try {
      await db
          .collection(chatCollection)
          .doc(chatID)
          .collection(messagesCollection)
          .add(
            message.toJson(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateChatData(String chatID, Map<String, dynamic> data) async {
    try {
      await db.collection(chatCollection).doc(chatID).update(data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserLastSeenTime(String uid) async {
    try {
      await db.collection(userCollection).doc(uid).update({
        'last_active': DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteChat(String chatID) async {
    try {
      await db.collection(chatCollection).doc(chatID).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<QuerySnapshot> getUsers({String? name}) {
    Query query = db.collection(userCollection);
    if (name != null) {
      query = query
          .where('name', isGreaterThanOrEqualTo: name,)
          .where('name', isLessThanOrEqualTo: name + '2',);
    }
    return query.get();
  }

  Future<DocumentReference?> createChat(Map<String,dynamic> data) async {
    try {
      DocumentReference chat = await db.collection(chatCollection).add(data);
      return chat;
    } catch(e){
      print(e);
    }
  }
}
