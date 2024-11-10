import 'package:flutter/material.dart';

class PinKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onDelete;
  final bool showBiometric;
  final VoidCallback? onBiometricPressed;

  const PinKeyboard({
    Key? key,
    required this.onKeyPressed,
    required this.onDelete,
    this.showBiometric = false,
    this.onBiometricPressed,
  }) : super(key: key);

  Widget _buildKey(String text, [Color? textColor]) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: InkWell(
          onTap: () => onKeyPressed(text),
          borderRadius: BorderRadius.circular(50),
          child: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteKey() {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: InkWell(
          onTap: onDelete,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.1),
            ),
            child: const Center(
              child: Icon(
                Icons.backspace_outlined,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricKey() {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: InkWell(
          onTap: onBiometricPressed,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.1),
            ),
            child: const Center(
              child: Icon(
                Icons.fingerprint,
                color: Colors.blue,
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildKey('1'),
            _buildKey('2'),
            _buildKey('3'),
          ],
        ),
        Row(
          children: [
            _buildKey('4'),
            _buildKey('5'),
            _buildKey('6'),
          ],
        ),
        Row(
          children: [
            _buildKey('7'),
            _buildKey('8'),
            _buildKey('9'),
          ],
        ),
        Row(
          children: [
            showBiometric ? _buildBiometricKey() : const Expanded(child: SizedBox()),
            _buildKey('0'),
            _buildDeleteKey(),
          ],
        ),
      ],
    );
  }
}
