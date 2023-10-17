import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trival_game/firebase/firebase_functions.dart';
import 'package:trival_game/model/user_model.dart';
import 'package:trival_game/widgets/my_shrimmer.dart';

import '../constants/constant.dart';
import '../widgets/chat_list_item.dart';
import 'message_screen.dart';

class MyChats extends StatefulWidget {
  const MyChats({super.key});

  @override
  State<MyChats> createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('users').get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userList = snapshot.data!.docs;
                return ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      // user = userList[index].data();
                     
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MessageScreen()));
                            },
                            child: ChatListItem(
                              imageLink: userList[index]['userImage'],
                              userName: userList[index]['name'],
                            )),
                      );
                    });

                /*
  
                */
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error'),
                );
              } else {
                return const MyShrimmer();
              }
            }));
  }
}
