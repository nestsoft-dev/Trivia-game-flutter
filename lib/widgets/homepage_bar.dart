// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constant.dart';

class HomePageBar extends StatelessWidget {
  String greetings;
  IconData icon;
   HomePageBar({
    Key? key,
    required this.greetings,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: 90,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    greetings,
                    style: GoogleFonts.lato(color: Colors.grey),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text('Ikenna',
                  style: GoogleFonts.podkova(color: Colors.white, fontSize: 18))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            ),
          )
        ]),
      ),
    );
  }
}
