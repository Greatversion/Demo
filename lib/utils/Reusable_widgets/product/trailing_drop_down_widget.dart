import 'package:flutter/material.dart';
import 'package:mambo/utils/app.styles.dart';

class TrailingDropdownWidget extends StatefulWidget {
  final String label;
  final String content;
  const TrailingDropdownWidget(
      {super.key, l, required this.label, required this.content});

  @override
  State<TrailingDropdownWidget> createState() => _TrailingDropdownWidgetState();
}

class _TrailingDropdownWidgetState extends State<TrailingDropdownWidget> {
  double _animatedHeight = 0.0;
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // const Divider(
        //   thickness: 1,
        // ),
        GestureDetector(
          onTap: () => setState(() {
            _animatedHeight != 100.0
                ? _animatedHeight = 100.0
                : _animatedHeight = 0.0;

            isTapped = !isTapped;
          }),
          child: Container(
            padding: const EdgeInsets.only(bottom: 14),
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label,
                  style: AppStyles.semiBoldText.copyWith(fontSize: 16),
                ),
                Icon(!isTapped
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.keyboard_arrow_up_rounded)
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: _animatedHeight,
          width: double.maxFinite,
          child: Text(
            widget.content,
            style: const TextStyle(fontSize: 15),
            textAlign: TextAlign.justify,
          ),
        )
      ],
    );
  }
}
