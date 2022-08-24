import 'package:flutter/material.dart';

showSnackBar({required String message, required context}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(child: Text(message)),
    ),
  );
}
