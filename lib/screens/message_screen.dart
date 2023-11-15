// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:trival_game/constants/constant.dart';
import 'package:trival_game/widgets/my_snack.dart';
import 'package:trival_game/widgets/textinput.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../firebase/message_services.dart';
import '../services/admob__ads.dart';
import '../widgets/my_shrimmer.dart';

class MessageScreen extends StatefulWidget {
  final DocumentSnapshot data;
  final String receiverUserEmail;
  final String receiverUserid;
  const MessageScreen({
    Key? key,
    required this.data,
    required this.receiverUserEmail,
    required this.receiverUserid,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController messageController = TextEditingController();
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MessagesServices messagesServices = MessagesServices();

  _sendMessage(String message) {
    if (message.isNotEmpty) {
      messagesServices.sendMessage(widget.receiverUserid, message);
      messageController.clear();

      calculateCount();
    }
  }

  int click = 0;
  calculateCount() async {
    click--;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', click!);
    setState(() {});
  }

  loadCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? counter = prefs.getInt('counter') ?? 5;
    setState(() {
      click = counter!;
    });
  }

  resetCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', 10);
    loadCount();
  }

  bool _isRewardedLoaded = false;
  RewardedAd? _rewardedAd;
  loadRewardsAds() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-6987059332386190/1312504711',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            setState(() {
              _isRewardedLoaded = true;
            });
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCount();
  }

  showAds() {
    _rewardedAd!.show(onUserEarnedReward: (adview, reward) {
      resetCounter();
    });
    MySnack(context, 'Show Ads', Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('${widget.data['name']}'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('${widget.data['userImage']}'),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          //chat List(
          Expanded(
            child: messageList(),
          ),

          //massage),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: messageController,
                    obscureText: false,
                    maxLength: 45,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(169, 214, 214, 214),
                      hintText: 'Enter Message',
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: defaultButton, width: 2),
                          borderRadius: BorderRadius.circular(12)),
                      suffixIcon: GestureDetector(
                        onTap: click < 0
                            ? () {
                                _isRewardedLoaded
                                    ? showAds()
                                    :// MySnack(context, 'No ads available', Colors.red)
                                     UnityAds.showVideoAd(
                                        placementId: 'Rewarded_Android',
                                        onFailed: (adUnitId, error, message) {},
                                        onStart: (adUnitId) {},
                                        onClick: (adUnitId) {},
                                        onComplete: (reward) => setState(() {
                                          resetCounter();
                                        }),
                                      );
                                ;
                              }
                            : () {
                                _sendMessage(messageController.text);
                              },
                        child: Icon(
                          click < 0 ? FontAwesomeIcons.video : Icons.send,
                          color: defaultButton,
                        ),
                      ),
                    ),
                  ),
                ),
                //  IconButton(onPressed: (){}, icon: Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget messageList() {
    List<String> ids = [widget.receiverUserid, _auth.currentUser!.uid];
    ids.sort();
    String chatRoomId = ids.join('_');
    return StreamBuilder(
        stream: _firebaseFirestore
            .collection('chats')
            .doc(chatRoomId)
            .collection('messages')
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            final userList = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  //  ListView.builder(itemBuilder: (context, index){}),
                  ListView(
                children: userList.map((e) => messageItem(e)).toList(),
              ),
            );
          } else {
            return const MyShrimmer();
          }
        });
  }

  Widget messageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool _isSender =
        (data['senderId'] == FirebaseAuth.instance.currentUser!.uid);
    return Container(
      // alignment: _isSender? Alignment.le,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            _isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Align(
            alignment: _isSender ? Alignment.topRight : Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: _isSender ? Colors.blueAccent : defaultButton,
                  borderRadius: _isSender
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(15.0))
                      : const BorderRadius.only(
                          topRight: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0),
                          topLeft: Radius.circular(15.0),
                        )),
              child: Text('${data['message']}',
                  style: const TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  const ChatMessage({
    Key? key,
    required this.text,
    required this.isUserMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: isUserMessage ? Colors.blueAccent : defaultButton,
                borderRadius: isUserMessage
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        topRight: Radius.circular(15.0))
                    : const BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0),
                      )),
            child: Text(text, style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
