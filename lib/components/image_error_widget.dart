import 'package:flutter/material.dart';

class ImageErrorWidget extends StatelessWidget {
  const ImageErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.error_rounded,
        color: Colors.white,
      ),
    );
  }
}
