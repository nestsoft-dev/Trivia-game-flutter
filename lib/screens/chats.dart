import 'package:flutter/material.dart';

import '../constants/constant.dart';
import '../widgets/chat_list_item.dart';

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
      body: ListView.builder(
          itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChatListItem(),
              )),
    );
  }
}
