import 'package:flutter/material.dart';
import 'package:mambo/view%20models/category_view_model.dart';
import 'package:provider/provider.dart';

class ClearFilterButton extends StatefulWidget {
  const ClearFilterButton({super.key});

  @override
  State<ClearFilterButton> createState() => _ClearFilterButtonState();
}

class _ClearFilterButtonState extends State<ClearFilterButton> {
  @override
  Widget build(BuildContext context) {
    final CategoriesViewModel categoriesViewModel =
        Provider.of<CategoriesViewModel>(context);
    final BrandsViewModel brandsViewModel =
        Provider.of<BrandsViewModel>(context);
    return GestureDetector(
      onTap: () {
        categoriesViewModel.clear();
        brandsViewModel.clear();
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0), //Modified
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20)),
          child: const Padding(
            padding: EdgeInsets.all(10.0), //Modified
            child: Center(
              child: Text(
                "Clear Filters",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
