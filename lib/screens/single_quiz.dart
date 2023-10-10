import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class SingleQuizScreen extends StatefulWidget {
  const SingleQuizScreen({super.key});

  @override
  State<SingleQuizScreen> createState() => _SingleQuizScreenState();
}

class _SingleQuizScreenState extends State<SingleQuizScreen> {
   final CardSwiperController controller = CardSwiperController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  
  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $currentIndex was undod from the ${direction.name}',
    );
    return true;
  }
 
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:ListView(children:[
        SizedBox(height: 50,width: 
        size.width,),
        Container(
          height: size.height*0.75,
          child: 
           Flexible(
              child: CardSwiper(
                controller: controller,
                cardsCount: 5,
                onSwipe: _onSwipe,
                onUndo: _onUndo,
                numberOfCardsDisplayed: 3,
                backCardOffset: const Offset(40, 40),
                padding: const EdgeInsets.all(24.0),
                cardBuilder: (
                  context,
                  index,
                  horizontalThresholdPercentage,
                  verticalThresholdPercentage,
                ) =>
                    Text(index.toString()),
              ),
            ),
        )

      ]),
    );
  }
}