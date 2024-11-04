import 'package:flutter/material.dart';
import 'package:mambo/utils/app.colors.dart';

class ShopFilterButton extends StatelessWidget {
  final List<String> filterButtonLabels;
  final int index;
  final bool isSelected; // To indicate if this button is selected
  final VoidCallback onTap; // To handle tap

  const ShopFilterButton({
    super.key,
    required this.filterButtonLabels,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 7.0),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : Colors.transparent, // Change color if selected
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : Colors.black, // Change border color if selected
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              filterButtonLabels[index],
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.black, // Change text color if selected
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

class CustomFilterDropdownButton<T> extends StatefulWidget {
  final List<T> items; // Mandatory
  final T? value; // Mandatory
  final ValueChanged<T?>? onChanged; // Mandatory

  // Optional Parameters
  final String? hint;
  final Color? dropdownColor;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? iconSize;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextStyle? style;
  final bool isExpanded;
  final bool isDense;
  final double? borderRadius;

  const CustomFilterDropdownButton({
    super.key,
    required this.items, // Required
    this.value, // Required
    this.onChanged, // Required

    // Optional Parameters
    this.hint,
    this.dropdownColor,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.iconSize,
    this.elevation,
    this.padding,
    this.margin,
    this.style,
    this.isExpanded = false,
    this.isDense = false,
    this.borderRadius,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomFilterDropdownButtonState<T> createState() =>
      _CustomFilterDropdownButtonState<T>();
}

class _CustomFilterDropdownButtonState<T>
    extends State<CustomFilterDropdownButton<T>> {
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: DropdownButton<T>(
        value: _selectedValue,
        onChanged: (T? newValue) {
          setState(() {
            _selectedValue = newValue;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(newValue);
          }
        },
        items: widget.items.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(value.toString(), style: widget.style),
          );
        }).toList(),
        hint: widget.hint != null ? Text(widget.hint!) : null,
        dropdownColor: widget.dropdownColor,
        iconEnabledColor: widget.iconEnabledColor,
        iconDisabledColor: widget.iconDisabledColor,
        iconSize: widget.iconSize ?? 24.0,
        elevation: widget.elevation?.toInt() ?? 8,
        isDense: widget.isDense,
        isExpanded: widget.isExpanded,
        style: widget.style,
        borderRadius: widget.borderRadius != null
            ? BorderRadius.circular(widget.borderRadius!)
            : null,
      ),
    );
  }
}
