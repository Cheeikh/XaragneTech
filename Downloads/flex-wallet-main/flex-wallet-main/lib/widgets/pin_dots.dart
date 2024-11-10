import 'package:flutter/material.dart';

class PinDots extends StatelessWidget {
  final int length;
  final int filledCount;

  const PinDots({
    Key? key,
    required this.length,
    required this.filledCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < filledCount
                ? Theme.of(context).primaryColor
                : Colors.grey.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
