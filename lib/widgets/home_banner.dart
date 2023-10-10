// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class BannerHome extends StatelessWidget {
  const BannerHome({
    Key? key,
    required this.size,
    required this.diamonds,
  }) : super(key: key);

  final Size size;
  final int diamonds;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.all(13),
        width: size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
                colors: [Colors.pink, Colors.pinkAccent],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Earned Points',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[350]),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '2553',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.yellow),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diamonds',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[350]),
                ),
                const SizedBox(
                  height: 10,
                ),
                diamonds < 1
                    ? ElevatedButton(
                        onPressed: () {
                          //TODO:implement purchase
                        },
                        child: const Text('Buy Diamonds'))
                    : Text(
                        '💎$diamonds',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
