import 'package:flutter/material.dart';

class TextFormFieldLogin extends StatelessWidget {
  const TextFormFieldLogin({
    super.key,
    required TextEditingController nameControll,
  }) : _nameControll = nameControll;

  final TextEditingController _nameControll;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _nameControll,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your name ";
        }
        return null;
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Rounded corners
          borderSide: BorderSide.none, // No visible border
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              10.0), // Rounded corners when there's an error
          borderSide: BorderSide
              .none, // No visible border when there's an error
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              10.0), // Rounded corners when focused
          borderSide:
              BorderSide.none, // No visible border when focused
        ),
        prefixIcon: const Icon(
          Icons.account_circle_rounded,
          color: Colors.grey,
        ),
        hintText: "Enter Your Name",
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}
