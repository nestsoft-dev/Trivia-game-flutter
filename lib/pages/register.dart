import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trival_game/constants/constant.dart';
import 'package:trival_game/pages/login.dart';
import 'package:trival_game/widgets/textinput.dart';
import 'package:auth_buttons/auth_buttons.dart';

import '../firebase/firebase_functions.dart';
import '../model/user_model.dart';
import '../screens/bottom_nav.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _isPassword = true;
  bool _isAnimated = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Signup'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color.fromARGB(255, 214, 192, 248),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            const Text(
              'Please fill the form with the needed details',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color.fromARGB(255, 35, 0, 82)),
            ),
            const SizedBox(
              height: 15,
            ),
            MyInputField(
              name: "Full Name",
              hint: 'Enter Full name',
              isPassword: false,
              textInputType: TextInputType.name,
              textEditingController: _name,
              icon: Icons.person,
            ),
            SizedBox(
              height: 15,
            ),
            MyInputField(
              name: "Email",
              hint: 'Enter Email',
              isPassword: false,
              textInputType: TextInputType.emailAddress,
              textEditingController: _email,
              icon: Icons.mail,
            ),
            SizedBox(
              height: 15,
            ),
            MyInputField(
              name: "Password",
              hint: 'Create password',
              isPassword: _isPassword,
              textInputType: TextInputType.name,
              textEditingController: _password,
              icon: _isPassword ? Icons.remove_red_eye_outlined : Icons.lock,
              onTap: () {
                setState(() {
                  _isPassword = !_isPassword;
                });
              },
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: _isAnimated
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Registering')));
                      }
                    : () async {
                        if (_name.text == '' ||
                            _email.text == '' ||
                            _password.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please Provide input')));
                        } else if (_password.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Please Password must be more than 6 characters')));
                        } else {
                          setState(() {
                            _isAnimated = true;
                          });

                          final firebaseFun =
                              Provider.of<FirebaseFun>(context, listen: false);

                          await firebaseFun
                              .register(context, _name.text, _email.text,
                                  _password.text)
                              .then((value) {
                            setState(() {
                             
                              _isAnimated = false;
                            });
                          });
                        }
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: 55,
                  width: _isAnimated ? size.width / 2 : size.width,
                  decoration: BoxDecoration(
                      color: _isAnimated ? Colors.green : defaultButton,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: _isAnimated
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(
                                  'Registering',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 10),
                                CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              ])
                        : const Text(
                            'Register',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: Text('Login')),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Text('OR'),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ],
            ),
            GoogleAuthButton(
              style: const AuthButtonStyle(
                iconType: AuthIconType.outlined,
              ),
              onPressed: () {
                final firebaseFun =
                    Provider.of<FirebaseFun>(context, listen: false);
                firebaseFun.signInWithGoogle(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
