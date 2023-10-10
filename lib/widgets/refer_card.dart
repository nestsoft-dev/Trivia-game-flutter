import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/constant.dart';

class ReferralBanner extends StatelessWidget {
  const ReferralBanner({
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
        padding: const EdgeInsets.all(20),
        width: size.width,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 0, 146, 24),
            borderRadius: BorderRadius.circular(25)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/share.png'),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              children: [
                Text(
                  'Get Diamonds Rewards 💎',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Get 30💎 Rewards for Referrals ',
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
                            Icons.share,
                            color: defaultButton,
                          ),
                          const Text('Share')
                        ]),
                  ),
                )
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/share.png'),
              )),
        ]),
      ),
    );
  }
}
