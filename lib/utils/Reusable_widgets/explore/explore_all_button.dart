import 'package:flutter/material.dart';

import 'package:mambo/providers/explore_action_provider.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:provider/provider.dart';

class ExploreAllButton extends StatefulWidget {
  const ExploreAllButton({super.key});

  @override
  State<ExploreAllButton> createState() => _ExploreAllButtonState();
}

class _ExploreAllButtonState extends State<ExploreAllButton> {
  @override
  Widget build(BuildContext context) {
    final exploreActionProvider =
        Provider.of<ExploreactionProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: GestureDetector(
        onTap: () {
          exploreActionProvider.exploreAllButtonTapped();
        },
        child: Container(
          height: 40,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(25)),
          child: Center(
              child: Text(
            "Explore all",
            style: AppStyles.whiteColoredText
                .copyWith(fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}