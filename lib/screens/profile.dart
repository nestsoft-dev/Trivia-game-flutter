import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trival_game/model/user_model.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
//import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/constant.dart';
import '../firebase/firebase_functions.dart';
import '../pages/onboarding_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/admob__ads.dart';
import '../services/in_app_review.dart';
import '../widgets/my_shrimmer.dart';
import '../widgets/my_snack.dart';
import '../widgets/profile_select.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseFun _firebaseFun = FirebaseFun();
  final storage = FirebaseStorage.instance;
  String? userImageLink;

  //pick image
  final ImagePicker picker = ImagePicker();
  late Permission _permission;
  File? _image;
  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _isUploading = true;
      _image = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  Future<void> _uploadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    final storage = FirebaseStorage.instance;
    final Reference storageReference =
        storage.ref().child('user_images/${user?.uid}.jpg');

    final UploadTask uploadTask = storageReference.putFile(_image!);
    await uploadTask.whenComplete(() {
      getImageUrl();
      MySnack(context, 'Image uploaded', Colors.green);
    });
  }

  Future<String> getImageUrl() async {
    final user = FirebaseAuth.instance.currentUser;
    final storageReference =
        FirebaseStorage.instance.ref().child('user_images/${user?.uid}.jpg');
    final imageUrl = await storageReference.getDownloadURL();
    setState(() {
      _isUploading = false;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'userImage': imageUrl});
    return imageUrl;
  }

  Future<void> selectImage() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // You can request the permission if it is currently undetermined.
      var result = await Permission.storage.request();
      if (result.isGranted) {
        _pickImage().then((value) async => _uploadImage());
        // Permission granted, you can now access the internal storage.
        // Place your file reading code here.
      }
    } else if (status.isGranted) {
      _pickImage().then((value) async => _uploadImage());
      // Permission is already granted, you can access the internal storage.
      // Place your file reading code here.
    } else {
      // Permission denied, you can inform the user about the necessity of the permission.
      // You can also open app settings to allow the user to grant the permission manually.
      openAppSettings();
    }
  }

  bool _isUploading = false;
  MyInAppReview review = MyInAppReview();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBanner();
  }

  BannerAd? _bannerAd;
  bool _isLoaded = false;
  loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-6987059332386190/2817158072',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  final Uri _url = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.netsoftdevelopers.trival_game');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: defaultButton,
        floatingActionButton: FloatingActionButton(
          onPressed: () async => FirebaseFun().signOut(),
          child: Icon(FontAwesomeIcons.signOut),
        ),
        body: StreamBuilder(
            stream: FirebaseFun().getuserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> gottenData =
                    snapshot.data!.data() as Map<String, dynamic>;
                UserModel userModel = UserModel.fromMap(gottenData);
                return ListView(
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
                                    userModel.name,
                                    style: GoogleFonts.lato(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(userModel.email.toString(),
                                      style: GoogleFonts.podkova(
                                          color: Colors.white, fontSize: 18))
                                ],
                              ),
                              _isUploading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      child: GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            _isUploading = true;
                                          });
                                          await selectImage().then((value) {
                                            setState(() {
                                              _isUploading = false;
                                            });
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(imageUrl),
                                            ),
                                            const Positioned(
                                                bottom: 10,
                                                child: Text('Edit',
                                                    style: TextStyle(
                                                        color: Colors.grey)))
                                          ],
                                        ),
                                      ),
                                    )
                            ]),
                      ),
                    ),

                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    GestureDetector(
                      onTap: () async {
                        MySnack(context, 'Deleting account', Colors.red);
                        await _firebaseFun.deleteUser(context).then((value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const OnBoardingScreen()),
                              (route) => false);
                        });
                      },
                      child: ProfileSelect(
                        title: 'Delete Account',
                        des: 'Delete your details',
                        leadingIcon: Icons.delete,
                        trialing: Icons.delete,
                        backgroundColor: Colors.redAccent.withOpacity(0.7),
                      ),
                    ),

                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'Netsoftdevelopers@gmail.com',
                          query: 'Please I need help....',
                        );

                        launchUrl(emailLaunchUri);
                      },
                      child: ProfileSelect(
                        title: 'Contact Support',
                        des: 'Contact us for account help',
                        leadingIcon: Icons.support_agent,
                        trialing: FontAwesomeIcons.message,
                        backgroundColor: Colors.green.withOpacity(0.7),
                      ),
                    ),

                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await FlutterShare.share(
                            title: 'Join us and Learn',
                            text:
                                'Join the winning team and earn cool rewards of giftscards and paypals funds using this promo code ${userModel.referralCode}',
                            linkUrl:
                                'https://play.google.com/store/apps/details?id=com.netsoftdevelopers.trival_game',
                            chooserTitle: 'Join And Earn');
                      },
                      child: ProfileSelect(
                        title: 'Refer a friend',
                        des: 'Refer a friend and earn free 50💎',
                        leadingIcon: Icons.share,
                        trialing: FontAwesomeIcons.users,
                        backgroundColor: Colors.blue.withOpacity(0.7),
                      ),
                    ),

                    SizedBox(
                      height: size.height * 0.02,
                    ),

                    ProfileSelect(
                      onTap: () =>
                          MySnack(context, 'Nothing to Set yet', Colors.red),
                      title: 'Settings',
                      des: 'Set the app to match you',
                      leadingIcon: Icons.settings,
                      trialing: FontAwesomeIcons.hand,
                      backgroundColor: Colors.brown.withOpacity(0.7),
                    ),

                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () {
                        review.showRating();
                      },
                      child: ProfileSelect(
                        onTap: () async {
                          if (!await launchUrl(_url)) {
                            throw Exception('Could not launch $_url');
                          }
                          await launchUrl(_url);
                        },
                        title: 'Rate App',
                        des: 'Rate app on playstore for more points',
                        leadingIcon: Icons.rate_review,
                        trialing: FontAwesomeIcons.star,
                        backgroundColor: Colors.yellow.withOpacity(0.7),
                      ),
                    ),

                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    _isLoaded
                        ? SizedBox(
                            width: _bannerAd!.size.width.toDouble(),
                            height: _bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd!),
                          )
                        : //SizedBox.shrink(),
                         UnityBannerAd(
                            placementId: 'Banner_Android',
                            onLoad: (adUnitId) =>
                                print('Banner loaded: $adUnitId'),
                            onClick: (adUnitId) =>
                                print('Banner clicked: $adUnitId'),
                            onFailed: (adUnitId, error, message) => print(
                                'Banner Ad $adUnitId failed: $error $message'),
                          ),
                    ProfileSelect(
                      onTap: () => MySnack(context, 'Coming soon', Colors.red),
                      title: 'Follow us',
                      des: 'Follow us on social media for updates.',
                      leadingIcon: Icons.follow_the_signs_outlined,
                      trialing: FontAwesomeIcons.link,
                      backgroundColor: Colors.redAccent.withOpacity(0.7),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Something Went wrong'),
                );
              } else {
                return const MyShrimmer();
              }
            }));
  }
}
