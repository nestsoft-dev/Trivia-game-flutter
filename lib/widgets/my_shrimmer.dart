import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class MyShrimmer extends StatelessWidget {
  const MyShrimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const FadeShimmer(
        height: 8,
        width: 150,
        radius: 4,
        highlightColor: Color(0xffF9F9FB),
        baseColor: Color(0xffE6E8EB),
      );
  }
}