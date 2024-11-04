import 'package:flutter/material.dart';
import 'package:mambo/utils/app.colors.dart';

class SelectionWidget extends StatefulWidget {
  final String? selectedAttribute1;
  final List<String>? selecteOptions;
  final Function(String attribute, String option) onOptionSelected;

  const SelectionWidget({
    Key? key,
    required this.selectedAttribute1,
    required this.selecteOptions,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  _SelectionWidgetState createState() => _SelectionWidgetState();
}

class _SelectionWidgetState extends State<SelectionWidget> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = widget.selecteOptions!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.selectedAttribute1!.replaceFirst(
              widget.selectedAttribute1!.characters.first,
              widget.selectedAttribute1!.characters.first.toUpperCase()),
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dropdownItems.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedValue = dropdownItems[index];
                  });
                  widget.onOptionSelected(
                      widget.selectedAttribute1!, dropdownItems[index]);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedValue == dropdownItems[index]
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(dropdownItems[index]),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
