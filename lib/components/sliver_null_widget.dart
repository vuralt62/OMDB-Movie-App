import 'package:flutter/material.dart';

class SliverNullWidget extends StatelessWidget {
  const SliverNullWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
        child: SizedBox(
      width: 0,
      height: 0,
    ));
  }
}
