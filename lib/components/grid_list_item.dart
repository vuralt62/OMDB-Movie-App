import 'package:flutter/material.dart';
import 'package:movie_app/components/image_error_widget.dart';

class GridListItem extends StatelessWidget {
  const GridListItem({
    Key? key,
    required this.poster,
    required this.onTap,
    required this.padding,
  }) : super(key: key);

  final String poster;
  final void Function()? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTap: onTap,
          child: Image.network(
            poster,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
            errorBuilder: (context, object, stacktrace) => const ImageErrorWidget(),
          ),
        ),
      ),
    );
  }
}
