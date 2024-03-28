import 'package:flutter/material.dart';

class Commons {
  SnackBar snackBarMessage(String s, Color color) {
    return SnackBar(
      duration: const Duration(seconds: 4),
      backgroundColor: color,
      content: Text(
        s,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
