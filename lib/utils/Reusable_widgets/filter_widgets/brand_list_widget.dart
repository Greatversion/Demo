import 'package:flutter/material.dart';
import 'package:mambo/utils/app.colors.dart';

class BrandListWidget extends StatefulWidget {
  final List<String> listOfBrands;
  final ValueChanged<List<String>> onSelectionChanged;

  const BrandListWidget({
    super.key,
    required this.listOfBrands,
    required this.onSelectionChanged,
  });

  @override
  State<BrandListWidget> createState() => _BrandListWidgetState();
}

class _BrandListWidgetState extends State<BrandListWidget> {
  final List<int> _selectedBrands = [];

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedBrands.contains(index)) {
        _selectedBrands.remove(index);
      } else {
        _selectedBrands.add(index);
      }
    });

    List<String> selectedBrands =
        _selectedBrands.map((index) => widget.listOfBrands[index]).toList();
    widget.onSelectionChanged(selectedBrands);
  }

  void _resetSelection() {
    setState(() {
      _selectedBrands.clear();
    });

    widget.onSelectionChanged([]);
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
              itemCount: widget.listOfBrands.length,
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3),
                child: Container(
                  decoration: BoxDecoration(
                    color: _selectedBrands.contains(index)
                        ? AppColors.black
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    onTap: () => _toggleSelection(index),
                    leading: Checkbox(
                      value: _selectedBrands.contains(index),
                      onChanged: (value) {
                        _toggleSelection(index);
                      },
                    ),
                    title: Text(
                      widget.listOfBrands[index],
                      style: TextStyle(
                        color: _selectedBrands.contains(index)
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
