import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mambo/utils/helper/Helper.dart';

class SwipeExamplePage extends StatefulWidget {
  const SwipeExamplePage({super.key});

  @override
  State<SwipeExamplePage> createState() => _SwipeExamplePageState();
}

class _SwipeExamplePageState extends State<SwipeExamplePage> {
  int currentindex = 0;

  Color defaultcolor = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultcolor,
        centerTitle: true,
        title: const Text(
          'Cards Swipe',
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      backgroundColor: defaultcolor,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 650,
        child: CardSwiper(
          cardsCount: Helper.productImageUrls.length,

          cardBuilder: (context, index, x, y) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: Helper.productImageUrls[index],
                fit: BoxFit.cover,
              ),
            );
          },

          // allowedSwipeDirection: AllowedSwipeDirection.only(right: true),

          // numberOfCardsDisplayed: 4,

          // isLoop: false,

          // backCardOffset: Offset(50,50),

          onSwipe: (prevoius, current, direction) {
            currentindex = current!;

            if (direction == CardSwiperDirection.right) {
              Fluttertoast.showToast(
                  msg: '🔥', backgroundColor: Colors.white, fontSize: 28);
            } else if (direction == CardSwiperDirection.left) {
              Fluttertoast.showToast(
                  msg: '😖', backgroundColor: Colors.white, fontSize: 28);
            }
            return true;
          },
        ),
      ),
    );
  }
}