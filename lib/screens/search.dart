import 'package:flutter/material.dart';

import '../constants/constant.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(children: [
        Align(
          alignment: Alignment(1, -1),
          child: Container(
            height: 250,
            width: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lighBlue.withOpacity(0.8),
            ),
          ),
        ),
        Align(
          alignment: Alignment(1, 0),
          child: Container(
            height: 250,
            width: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: darkblue.withOpacity(0.8),
            ),
          ),
        ),
        Align(
          alignment: Alignment(-1, 1),
          child: Container(
            height: 250,
            width: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: darkblue.withOpacity(0.8),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Center(
            child: Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.yellow),
                  color: Color.fromARGB(255, 162, 87, 248),
                  borderRadius: BorderRadius.circular(25)),
              child: GridView.builder(
                  gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) => Text(index.toString())),
            ),
          ),
        )
      ]),
    );
  }
}
