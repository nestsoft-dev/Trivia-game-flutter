import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/constant.dart';

class ChatBanner extends StatelessWidget {
  const ChatBanner({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: size.height * 0.27,
        padding: const EdgeInsets.all(15),
        width: size.width,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 165, 112, 255),
            borderRadius: BorderRadius.circular(25)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(imageUrl),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              children: [
                Text(
                  'FEATURED',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Chat with friends\nand other players',
                  style: GoogleFonts.poppins(color: Colors.grey[200]),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  height: 35,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.message_outlined,
                            color: defaultButton,
                          ),
                          const Text('Send Message')
                        ]),
                  ),
                )
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(imageUrl),
              )),
        ]),
      ),
    );
  }
}
