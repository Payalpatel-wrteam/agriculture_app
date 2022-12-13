import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  const RetryButton({required this.onPressed, this.title = 'Retry', Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).backgroundColor),
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
