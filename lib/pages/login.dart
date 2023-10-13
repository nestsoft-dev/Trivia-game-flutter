import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import '../constants/constant.dart';
import '../firebase/firebase_functions.dart';
import '../screens/bottom_nav.dart';
import '../screens/home.dart';
import '../widgets/textinput.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _isPassword = true;
  bool _isAnimated = false;
  FirebaseFun firebaseFun = FirebaseFun();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Login'),
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
              'Welcome',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color.fromARGB(255, 35, 0, 82)),
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                    onPressed: () {}, child: const Text('Forget Password?'))
              ]),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: _isAnimated
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Loading')));
                    }
                    : () async {
                        if (_email.text == '' || _password.text == "") {
                        } else if (_password.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'password must be more than 6 characters')));
                        }else{
                           setState(() {
                            _isAnimated = true;
                          });

                          await firebaseFun.login(
                              context, _email.text, _password.text).then((value) {
                                  Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomNav()),
                                (route) => false);
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
                                  'Loading',
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
                            'Login',
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
                )
              ],
            ),
            GoogleAuthButton(
              style: const AuthButtonStyle(
                iconType: AuthIconType.outlined,
              ),
              onPressed: () {
                firebaseFun.signInWithGoogle(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
