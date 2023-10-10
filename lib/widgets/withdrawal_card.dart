import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/constant.dart';

class WithdrawalBanner extends StatelessWidget {
  const WithdrawalBanner({
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
            color: Color.fromARGB(255, 114, 112, 255),
            borderRadius: BorderRadius.circular(25)),
        child: Column(
          children: [
            //paypal
            Image.asset(
              'assets/paypal.png',
              height: 100,
            ),
            const SizedBox(
              height: 5,
            ),

            //text
            Text(
              'Claim Rewards',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Cash Points Rewards to Paypal or GiftCards',
              style: GoogleFonts.poppins(color: Colors.grey[200]),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 35,
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                    Icons.send,
                    color: defaultButton,
                  ),
                  const Text('Withdraw')
                ]),
              ),
            ),

            //button
          ],
        ),
      ),
    );
  }
}
