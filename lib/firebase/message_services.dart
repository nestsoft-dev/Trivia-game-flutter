import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/message_model.dart';

class MessagesServices extends ChangeNotifier {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  //send message
  Future<void> sendMessage(String receiverId, String message) async {
    //get current user info
    String currentUserId = _auth.currentUser!.uid;
    String currentUserEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //new message
    MessageModel messageModel = MessageModel(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        images: '',
        message: message,
        timestamp: timestamp);

    //chat room id
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoom = ids.join('_');

    // add new message
    await _firebaseFirestore
        .collection('chats')
        .doc(chatRoom)
        .collection('messages')
        .add(messageModel.toMap());
  }

  Future<void> getMessage(String userId, String otherUserId) {
    //check room id
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _firebaseFirestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get();
  }
}
