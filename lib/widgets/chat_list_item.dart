// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../constants/constant.dart';

class ChatListItem extends StatelessWidget {
  final String imageLink;
  final String userName;
  const ChatListItem({
    Key? key,
    required this.imageLink,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 90,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(userName),
          subtitle: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Message this user'),
              Text(''),
            ],
          ),
          leading: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(imageLink),
          ),
        ),
      ),
    );
  }
}
