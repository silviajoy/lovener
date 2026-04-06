import 'package:flutter/material.dart';

class GuessTableNumpad extends StatelessWidget {
  final void Function(int) onNumberTapped;

  const GuessTableNumpad({
    Key? key,
    required this.onNumberTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow([2, 3, 4]),
        const SizedBox(height: 12),
        _buildRow([5, 6, 7]),
        const SizedBox(height: 12),
        _buildRow([8, 9, 10]),
      ],
    );
  }

  Widget _buildRow(List<int> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numbers.map((number) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: _buildKey(number),
        );
      }).toList(),
    );
  }

  Widget _buildKey(int number) {
    return Material(
      color: Colors.blue.shade100,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => onNumberTapped(number),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 80,
          height: 60,
          alignment: Alignment.center,
          child: Text(
            number.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
