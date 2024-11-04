import 'package:flutter/material.dart';
import 'package:mambo/utils/app.colors.dart';

class CategoryListWidget extends StatefulWidget {
  final List<String> listOfCategories;
  final ValueChanged<List<String>> onSelectionChanged;

  const CategoryListWidget({
    super.key,
    required this.listOfCategories,
    required this.onSelectionChanged,
  });

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  final List<int> _selectedCategories = [];

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedCategories.contains(index)) {
        _selectedCategories.remove(index);
      } else {
        _selectedCategories.add(index);
      }
    });
    List<String> selectedCategories = _selectedCategories
        .map((index) => widget.listOfCategories[index])
        .toList();
    widget.onSelectionChanged(selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.36, //Modified
      width: double.maxFinite,
      child: Builder(
        builder: (context) => Scrollbar(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              itemCount: widget.listOfCategories.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _selectedCategories.contains(index)
                        ? AppColors.black
                        : Colors.grey[300],
                    borderRadius:
                        BorderRadius.circular(15), // Apply borderRadius here
                  ),
                  child: ListTile(
                    onTap: () => _toggleSelection(index),
                    leading: Checkbox(
                      value: _selectedCategories.contains(index),
                      onChanged: (value) {
                        _toggleSelection(index);
                      },
                    ),
                    title: Text(
                      widget.listOfCategories[index],
                      style: TextStyle(
                        color: _selectedCategories.contains(index)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
