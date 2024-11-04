import 'package:flutter/material.dart';

class PriceRangeTextfieldWidget extends StatelessWidget {
  final TextEditingController rangeController;
  const PriceRangeTextfieldWidget({
    super.key,
    required this.rangeController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: rangeController,
      cursorHeight: 22,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(22))),
    );
  }
}