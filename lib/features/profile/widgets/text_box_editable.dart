import 'package:flutter/material.dart';

class TextBoxEditable extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const TextBoxEditable({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Section name.
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[500]),
              ),

              // Edit button.
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.edit,
                  color: Colors.grey[400],
                )
              ),
            ],
          ),
          // Text.
          Text(text),
        ]),
    );
  }
}