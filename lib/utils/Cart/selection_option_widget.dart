// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';

// class SelectionOptionCartWidget extends StatefulWidget {
//   final List<String> optionList;
//   final String optionLabel;
//   final Function(String attribute, String option) onOptionSelected;
//   const SelectionOptionCartWidget({
//     super.key,
//     required this.optionList,
//     required this.optionLabel,
//     required this.onOptionSelected,
//   });

//   @override
//   State<SelectionOptionCartWidget> createState() =>
//       _SelectionOptionCartWidgetState();
// }

// class _SelectionOptionCartWidgetState extends State<SelectionOptionCartWidget> {
//   String? _selected;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           DropdownButton<String>(
//             alignment: Alignment.centerLeft,
//             underline: const SizedBox(),
//             padding: const EdgeInsets.symmetric(horizontal: 5),
//             hint: Text(widget.optionLabel),
//             // icon: Icon(Icons.keyboard_arrow_down),
//             isDense: true,
//             value: _selected,
//             items: widget.optionList.map((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//             onChanged: (value) {
//               _selected = value!;
//               debugPrint(value);
//               setState(() {});
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SelectionOptionCartWidget extends StatefulWidget {
  final List<String> optionList;
  final String optionLabel;
  final Function(String option) onOptionSelected;

  const SelectionOptionCartWidget({
    super.key,
    required this.optionList,
    required this.optionLabel,
    required this.onOptionSelected,
  });

  @override
  State<SelectionOptionCartWidget> createState() =>
      _SelectionOptionCartWidgetState();
}

class _SelectionOptionCartWidgetState extends State<SelectionOptionCartWidget> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Text(widget.optionLabel),
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  hint: Text(widget.optionLabel),
                  value: _selected,
                  items: widget.optionList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selected = value!;
                    });
                    print(value);
                    widget.onOptionSelected(value!);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
