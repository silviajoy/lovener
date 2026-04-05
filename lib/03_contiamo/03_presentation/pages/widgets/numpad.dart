import 'package:flutter/material.dart';

class NumericKeypad extends StatelessWidget {
  final ValueChanged<int> onNumberTapped;
  final VoidCallback onBackspace;
  final VoidCallback onSubmit;

  const NumericKeypad({
    super.key,
    required this.onNumberTapped,
    required this.onBackspace,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [1, 2, 3].map((number) => _buildKey(number.toString(), () => onNumberTapped(number))).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [4, 5, 6].map((number) => _buildKey(number.toString(), () => onNumberTapped(number))).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [7, 8, 9].map((number) => _buildKey(number.toString(), () => onNumberTapped(number))).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKey('⌫', onBackspace, icon: Icons.backspace, color: Colors.red[300]),
              _buildKey('0', () => onNumberTapped(0)),
              _buildKey('✓', onSubmit, icon: Icons.check_circle, color: Colors.green[400]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String label, VoidCallback onTap, {IconData? icon, Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: onTap,
          child: icon != null 
              ? Icon(icon, size: 28) 
              : Text(label, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
