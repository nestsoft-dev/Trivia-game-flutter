import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trival_game/constants/constant.dart';
import 'package:trival_game/widgets/textinput.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Ikenna'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          //chat List(
          Expanded(
              child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {},
          )),

          //massage),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(169, 214, 214, 214),
                    hintText: 'Enter Message',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: defaultButton, width: 2),
                        borderRadius: BorderRadius.circular(12)),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Message')));
                      },
                      child: Icon(
                        Icons.send,
                        color: defaultButton,
                      ),
                    ),
                  ),
                )),
                //  IconButton(onPressed: (){}, icon: Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}
