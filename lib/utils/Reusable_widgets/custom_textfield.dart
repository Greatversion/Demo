import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLength; // Add max length property
  final int? maxLines;
  final bool isEnabled;
  final void Function(String)? onChanged; // Add onChanged property
  final bool readOnly;
  final VoidCallback? onTap;
  final bool wantValidator;
  final Widget? prefixIcon;
  final String? prefixText;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.maxLength,
    this.onChanged,
    this.maxLines,
    this.isEnabled = true,
    this.readOnly = false,
    this.wantValidator = true,
    this.onTap,
    this.prefixIcon,
    this.prefixText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText && _obscureText,
          maxLength: widget.maxLength,
          onChanged: widget.onChanged,
          enabled: widget.isEnabled,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          // style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: whiteColor),
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixText: widget.prefixText,
            // prefixStyle: const TextStyle(color: whiteColor),
            hintStyle: Theme.of(context).textTheme.bodyMedium!,
            // .copyWith(color: greyColor),
            labelStyle: Theme.of(context).textTheme.bodyLarge!,
            // .copyWith(color: whiteColor),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.red, width: 2.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.red, width: 2.0),
            ),
            errorStyle: const TextStyle(
              fontSize: 18, // Adjust the validator text size here
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: _obscureText
                        ? SvgPicture.asset(
                            'assets/icons/eye.svg',
                            colorFilter: const ColorFilter.mode(
                                Colors.grey, BlendMode.srcIn),
                          )
                        : SvgPicture.asset(
                            'assets/icons/eye-slash.svg',
                            colorFilter: const ColorFilter.mode(
                                Colors.pink, BlendMode.srcIn),
                          ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
          validator: widget.wantValidator
              ? widget.validator
              : (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ${widget.labelText}';
                  }
                  return null;
                },
        ),
      ],
    );
  }
}
