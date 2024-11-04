import 'package:flutter/material.dart';

class ApplyFilterButton extends StatelessWidget {
  final VoidCallback onTap;

  const ApplyFilterButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0), //Modified
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black87,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20)),
          child: const Padding(
            padding: EdgeInsets.all(10.0), //Modified
            child: Center(
              child: Text(
                "Apply Filters",
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
