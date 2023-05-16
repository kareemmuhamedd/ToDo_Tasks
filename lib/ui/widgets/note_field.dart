import 'package:flutter/material.dart';

import '../theme.dart';

class AdjustableTextField extends StatefulWidget {
  final String hintText;
  final String title;
  final TextEditingController controller;

  AdjustableTextField({
    required this.title,
    required this.hintText,
    required this.controller,
  });

  @override
  _AdjustableTextFieldState createState() => _AdjustableTextFieldState();
}

class _AdjustableTextFieldState extends State<AdjustableTextField> {
  double _height = 50.0;
  final double _minHeight = 50.0;
  final double _maxHeight = 400.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: titleStyle,
          ),
          AnimatedContainer(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 14),
            duration: const Duration(milliseconds: 100),
            height: _height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: TextField(
              controller: widget.controller,
              maxLines: null,
              style: subTitleStyle,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintStyle: subTitleStyle,
                hintText: widget.hintText,
                border: InputBorder.none,
              ),
              onChanged: (value) {
                final textHeight = _calculateTextHeight(value);
                setState(() {
                  _height = textHeight.clamp(_minHeight, _maxHeight);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTextHeight(String text) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(fontSize: 16)),
      maxLines: null,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.height + 24; // Add some padding to the height
  }
}
