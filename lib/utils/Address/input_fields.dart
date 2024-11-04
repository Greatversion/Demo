import 'package:flutter/material.dart';

Widget StringInput(String heading, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        TextFormField(
          style: const TextStyle(fontSize: 18),
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            errorStyle: TextStyle(color: Colors.red), // Error text style
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            // Adjust padding
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty'; // Error message
            }
            return null;
          },
        ),
      ],
    ),
  );
}

Widget NumericInput(String heading, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        TextFormField(
          style: const TextStyle(fontSize: 18),
          keyboardType: TextInputType.number,
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            errorStyle: TextStyle(color: Colors.red), // Error text style
            contentPadding: EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 8.0), // Adjust padding
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty'; // Error message
            }
            if (int.tryParse(value) == null) {
              return 'Please enter a valid number'; // Additional validation for numeric input
            }
            return null;
          },
        ),
      ],
    ),
  );
}

Widget AddressInput(String heading, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        TextFormField(
          maxLines: 2,
          style: const TextStyle(fontSize: 18),
          keyboardType: TextInputType.streetAddress,
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            errorStyle: TextStyle(color: Colors.red), // Error text style
            contentPadding: EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 8.0), // Adjust padding
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty'; // Error message
            }
            return null;
          },
        ),
      ],
    ),
  );
}
