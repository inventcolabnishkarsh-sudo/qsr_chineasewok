import 'package:flutter/material.dart';

enum KeyboardType { numeric, alphanumeric }

class QwertyKeyboard extends StatelessWidget {
  final KeyboardType type;
  final ValueChanged<String> onKeyTap;
  final VoidCallback onBackspace;
  final VoidCallback onShift;

  const QwertyKeyboard({
    super.key,
    required this.onKeyTap,
    required this.onBackspace,
    required this.onShift,
    this.type = KeyboardType.alphanumeric,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: type == KeyboardType.numeric
          ? _numericRows()
          : _alphaNumericRows(),
    );
  }

  // ---------------- 🔢 NUMERIC ----------------

  List<Widget> _numericRows() {
    return [
      _row(['1', '2', '3']),
      _row(['4', '5', '6']),
      _row(['7', '8', '9']),
      _row(['0'], endIcon: Icons.backspace_outlined),
    ];
  }

  // ---------------- 🔠 ALPHANUMERIC (NUMBERS + LETTERS) ----------------

  List<Widget> _alphaNumericRows() {
    return [
      // 🔢 NUMBERS
      _row(['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']),

      // 🔠 LETTERS (CAPS ONLY)
      _row(['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P']),
      _row([
        'A',
        'S',
        'D',
        'F',
        'G',
        'H',
        'J',
        'K',
        'L',
      ], endIcon: Icons.backspace_outlined),
      _row(['Z', 'X', 'C', 'V', 'B', 'N', 'M']),
    ];
  }

  // ---------------- ROW BUILDER ----------------

  Widget _row(List<String> keys, {IconData? startIcon, IconData? endIcon}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            if (startIcon != null) _iconKey(startIcon, onShift),

            ...keys.map((k) => _letterKey(k)),

            if (endIcon != null) _iconKey(endIcon, onBackspace),
          ],
        ),
      ),
    );
  }

  // ---------------- KEYS ----------------

  Widget _letterKey(String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: GestureDetector(
          onTap: () => onKeyTap(label),
          child: _keyBox(
            child: Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconKey(IconData icon, VoidCallback onTap) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: GestureDetector(
          onTap: onTap,
          child: _keyBox(child: Icon(icon, size: 20)),
        ),
      ),
    );
  }

  Widget _keyBox({required Widget child}) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: child,
    );
  }
}
