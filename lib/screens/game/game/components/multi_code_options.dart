import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MultiCodeOptions extends StatelessWidget {
  const MultiCodeOptions({super.key, required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              // You can also show a snackbar or toast to indicate that the text has been copied.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Text copied to clipboard'),
                ),
              );
            },
            icon: const Icon(Icons.copy)),
        // IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code)),
        // IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
      ],
    );
  }
}
