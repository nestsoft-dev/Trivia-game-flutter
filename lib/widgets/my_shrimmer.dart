import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class MyShrimmer extends StatelessWidget {
  const MyShrimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
        child: ListView.separated(
          itemBuilder: (_, i) {
            final delay = (i * 300);
            return Container(
              decoration: BoxDecoration(
                  color:  Colors.white,
                  borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  FadeShimmer.round(
                    size: 60,
                    fadeTheme:  FadeTheme.light,
                    millisecondsDelay: delay,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeShimmer(
                        height: 8,
                        width: 150,
                        radius: 4,
                        millisecondsDelay: delay,
                        fadeTheme:
                        FadeTheme.light,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      FadeShimmer(
                        height: 8,
                        millisecondsDelay: delay,
                        width: 170,
                        radius: 4,
                        fadeTheme:
                       FadeTheme.light,
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          itemCount: 20,
          separatorBuilder: (_, __) => SizedBox(
            height: 16,
          ),
        ),
      );
  }
}