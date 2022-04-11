import 'package:flutter/material.dart';

class CircularTextField extends TextField {
  CircularTextField(
      {Key? key,
      TextEditingController? controller,
      String? hintText,
      IconData? prefixIcon,
      ValueChanged<String>? onSubmitted})
      : super(
            key: key,
            controller: controller,
            onSubmitted: onSubmitted,
            cursorColor: Colors.white54,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
                prefixIcon: Icon(
                  prefixIcon,
                  color: Colors.white54,
                ),
                hintText: hintText,
                //hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(36)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36), borderSide: const BorderSide(color: Colors.white)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36), borderSide: const BorderSide(color: Colors.white54)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36), borderSide: const BorderSide(color: Colors.white70))));
}
