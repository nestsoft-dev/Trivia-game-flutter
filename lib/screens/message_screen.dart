// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:trival_game/constants/constant.dart';
import 'package:trival_game/widgets/my_snack.dart';
import 'package:trival_game/widgets/textinput.dart';

import '../firebase/message_services.dart';
import '../widgets/my_shrimmer.dart';

class MessageScreen extends StatefulWidget {
  final DocumentSnapshot data;
  final String receiverUserEmail;
  final String receiverUserid;
  const MessageScreen({
    Key? key,
    required this.data,
    required this.receiverUserEmail,
    required this.receiverUserid,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController messageController = TextEditingController();
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MessagesServices messagesServices = MessagesServices();

  _sendMessage(String message) {
    if (message.isNotEmpty) {
      messagesServices.sendMessage(widget.receiverUserid, message);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('${widget.data['name']}'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('${widget.data['userImage']}'),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          //chat List(
          Flexible(
            child: messageList(),
          ),

          //massage),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(169, 214, 214, 214),
                    hintText: 'Enter Message',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: defaultButton, width: 2),
                        borderRadius: BorderRadius.circular(12)),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _sendMessage(messageController.text);
                      },
                      child: Icon(
                        Icons.send,
                        color: defaultButton,
                      ),
                    ),
                  ),
                )),
                //  IconButton(onPressed: (){}, icon: Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget messageList() {
    List<String> ids = [widget.receiverUserid, _auth.currentUser!.uid];
    ids.sort();
    String chatRoomId = ids.join('_');
    return FutureBuilder(
        future: _firebaseFirestore
            .collection('chats')
            .doc(chatRoomId)
            .collection('messages')
            .orderBy('timestamp', descending: false)
            .get(),
        // MessagesServices()
        //  .getMessage(widget.receiverUserid, _auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error');
          } else if (snapshot.hasData) {
            final userList = snapshot.data!.docs;
            return ListView(
              children: userList.map((e) => messageItem(e)).toList(),
            );
          } else {
            return MyShrimmer();
          }
        });
  }

  Widget messageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool _isSender =
        (data['senderId'] == FirebaseAuth.instance.currentUser!.uid);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            _isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: _isSender ? Colors.blueAccent : defaultButton,
                borderRadius: _isSender
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        topRight: Radius.circular(15.0))
                    : const BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0),
                      )),
            child: Text('${data['message']}',
                style: const TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  const ChatMessage({
    Key? key,
    required this.text,
    required this.isUserMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: isUserMessage ? Colors.blueAccent : defaultButton,
                borderRadius: isUserMessage
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        topRight: Radius.circular(15.0))
                    : const BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0),
                      )),
            child: Text(text, style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
