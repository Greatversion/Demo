// Description widget used in the tutorial
import 'package:flutter/material.dart';
import 'package:mambo/utils/app.styles.dart';

class CoachMarkDescription extends StatefulWidget {
  final String text;
  final String next;
  final void Function()? onNext;

  const CoachMarkDescription({
    super.key,
    required this.text,
    required this.next,
    this.onNext,
  });

  @override
  State<CoachMarkDescription> createState() => _CoachMarkDescriptionState();
}

class _CoachMarkDescriptionState extends State<CoachMarkDescription> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.text,
            style: AppStyles.boldText,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                  onPressed: widget.onNext,
                  child: Text(
                    widget.next,
                    style: AppStyles.semiBoldText,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
