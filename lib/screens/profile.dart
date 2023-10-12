import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/constant.dart';
import '../widgets/profile_select.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: defaultButton,
      body: ListView(
        children: [
          SizedBox(
            height: size.height * 0.1,
          ),
          //display user email n name with image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              height: 90,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ikenna',
                          style: GoogleFonts.lato(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text('Obettaikenna19@gmail.com',
                            style: GoogleFonts.podkova(
                                color: Colors.white, fontSize: 18))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                          const Positioned(
                              bottom: 10,
                              child: Text('Edit',
                                  style: TextStyle(color: Colors.grey)))
                        ],
                      ),
                    )
                  ]),
            ),
          ),

          SizedBox(
            height: size.height * 0.05,
          ),
          ProfileSelect(
            title: 'Delete Account',
            des: 'Delete your details',
            leadingIcon: Icons.delete,
            trialing: Icons.delete,
            backgroundColor: Colors.redAccent.withOpacity(0.7),
          ),

          SizedBox(
            height: size.height * 0.02,
          ),
          ProfileSelect(
            title: 'Contact Support',
            des: 'Contact us for account help',
            leadingIcon: Icons.support_agent,
            trialing: FontAwesomeIcons.message,
            backgroundColor: Colors.green.withOpacity(0.7),
          ),

          SizedBox(
            height: size.height * 0.02,
          ),
          ProfileSelect(
            title: 'Refer a friend',
            des: 'Refer a friend and earn free 50💎',
            leadingIcon: Icons.share,
            trialing: FontAwesomeIcons.users,
            backgroundColor: Colors.blue.withOpacity(0.7),
          ),

          SizedBox(
            height: size.height * 0.02,
          ),
          ProfileSelect(
            title: 'Settings',
            des: 'Set the app to match you',
            leadingIcon: Icons.settings,
            trialing: FontAwesomeIcons.hand,
            backgroundColor: Colors.brown.withOpacity(0.7),
          ),

          SizedBox(
            height: size.height * 0.02,
          ),
          ProfileSelect(
            title: 'Rate App',
            des: 'Rate app on playstore for more points',
            leadingIcon: Icons.rate_review,
            trialing: FontAwesomeIcons.star,
            backgroundColor: Colors.yellow.withOpacity(0.7),
          ),

          SizedBox(
            height: size.height * 0.02,
          ),
          ProfileSelect(
            title: 'Follow us',
            des: 'Follow us on social media for updates.',
            leadingIcon: Icons.follow_the_signs_outlined,
            trialing: FontAwesomeIcons.link,
            backgroundColor: Colors.redAccent.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}
