// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String images;
  final String message;
   Timestamp timestamp;
  MessageModel({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.images,
    required this.message,
    required this.timestamp,
  });

  MessageModel copyWith({
    String? senderId,
    String? senderEmail,
    String? receiverId,
    String? images,
    String? message,
    Timestamp? timestamp,
  }) {
    return MessageModel(
      senderId: senderId ?? this.senderId,
      senderEmail: senderEmail ?? this.senderEmail,
      receiverId: receiverId ?? this.receiverId,
      images: images ?? this.images,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'images': images,
      'message': message,
      'timestamp': timestamp,
    };
  }


  String toJson() => json.encode(toMap());

 

  @override
  String toString() {
    return 'MessageModel(senderId: $senderId, senderEmail: $senderEmail, receiverId: $receiverId, images: $images, message: $message, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.senderId == senderId &&
      other.senderEmail == senderEmail &&
      other.receiverId == receiverId &&
      other.images == images &&
      other.message == message &&
      other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return senderId.hashCode ^
      senderEmail.hashCode ^
      receiverId.hashCode ^
      images.hashCode ^
      message.hashCode ^
      timestamp.hashCode;
  }
}
