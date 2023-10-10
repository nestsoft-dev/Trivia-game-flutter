// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:trival_game/constants/constant.dart';

class MyInputField extends StatelessWidget {
  String name;
  String hint;
  bool isPassword;
  TextInputType textInputType;
  TextEditingController textEditingController;
  void Function()? onTap;
  IconData icon;
  MyInputField({
    Key? key,
    required this.name,
    required this.hint,
    required this.isPassword,
    required this.textInputType,
    required this.textEditingController,
    this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name),
          SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: textEditingController,
            obscureText: isPassword,
            keyboardType: textInputType,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(169, 214, 214, 214),
              hintText: hint,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: defaultButton, width: 2),
                  borderRadius: BorderRadius.circular(12)),
              suffixIcon: GestureDetector(
                onTap: onTap,
                child: Icon(
                  icon,
                  color: defaultButton,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
