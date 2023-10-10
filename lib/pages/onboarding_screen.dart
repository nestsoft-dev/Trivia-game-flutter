import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../constants/constant.dart';
import 'login.dart';
import 'register.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _pageController = PageController(
    initialPage: 0,
  );
  int _currentPage = 0;
  int pageIndex = 0;
  bool _isAnimated = false;
  @override
  void dispose() {
    _isAnimated = false;
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        width: size.width,
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purple],
                begin: Alignment.bottomRight)),
        child: Column(
          children: [
            //first child
            Expanded(
                flex: 2,
                child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        pageIndex = index;
                        _currentPage = index;
                      });
                    },
                    itemCount: onBoardingList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 15),
                            child: Image.asset(
                              onBoardingList[index]['image'],
                              height: 200,
                              width: 200,
                            ),
                          ),
                          Text(
                            onBoardingList[index]['title'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            onBoardingList[index]['des'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey[100]),
                          ),
                        ],
                      );
                    })),
            Expanded(
                child: pageIndex + 1 == 6
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 800),
                          height: _isAnimated ? 50 : size.height * 0.25,
                          width: _isAnimated ? size.width * 0.1 : size.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: _isAnimated
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Column(children: [
                                  Text(
                                    'Take Part in challenges with friends',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.mochiyPopPOne(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 25,
                                        color: Color.fromARGB(255, 35, 0, 82)),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isAnimated = true;
                                        });
                                        Future.delayed(
                                                Duration(milliseconds: 700))
                                            .then((value) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const RegisterPage()),
                                          );
                                          setState(() {
                                            _isAnimated = false;
                                          });
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        height: 55,
                                        width: _isAnimated
                                            ? size.width / 2
                                            : size.width,
                                        decoration: BoxDecoration(
                                            color: _isAnimated
                                                ? Colors.green
                                                : defaultButton,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Center(
                                          child: _isAnimated
                                              ? const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                      Text(
                                                        'Welcome',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(width: 10),
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                      )
                                                    ])
                                              : const Text(
                                                  'SignUp',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Flexible(
                                          child: Text(
                                            'Already have an Account?',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginPage()),
                                            );
                                          },
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                                color: defaultButton,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                        ),
                      )
                    : Column(
                        children: [
                          SmoothPageIndicator(
                              controller: _pageController,
                              count: onBoardingList.length,
                              effect: const ExpandingDotsEffect(
                                // dotColor: Colors.grey[200],
                                dotHeight: 10,
                                // dotWidth: 5,
                                activeDotColor: Colors.white,
                              ),
                              onDotClicked: (index) {}),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                pageIndex == 0
                                    ? Container()
                                    : ElevatedButton(
                                        onPressed: () {
                                          _pageController.animateToPage(
                                              pageIndex - 1,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.bounceInOut);
                                        },
                                        child: Text(
                                          'Prev',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              color: defaultButton),
                                        )),
                                ElevatedButton(
                                    onPressed: () {
                                      _pageController.animateToPage(
                                          pageIndex + 1,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.bounceInOut);
                                    },
                                    child: Text(
                                      'Next',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: defaultButton),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      )),
          ],
        ),
      ),
    );
  }
}
