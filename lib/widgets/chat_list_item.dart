import 'package:flutter/material.dart';

import '../constants/constant.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 90,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text('Hello'),
          subtitle: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Hello bro'),
              Text('12:30pm'),
            ],
          ),
          leading: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
      ),
    );
  }
}
