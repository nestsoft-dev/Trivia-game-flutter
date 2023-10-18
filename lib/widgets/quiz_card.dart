import 'package:flutter/material.dart';

class QuizCard extends StatefulWidget {
  Map<String, dynamic> question;
  int currentIndex;

  QuizCard({required this.question, required this.currentIndex});

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  String selectedOption = '';
  // Add a listener for currentIndex changes
  @override
  void didUpdateWidget(covariant QuizCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentIndex != oldWidget.currentIndex) {
      setState(() {
        selectedOption = ''; // Reset selected option on index change
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.question['question']),
            SizedBox(height: 16),
            ...widget.question['option'].entries.map((entry) {
              final optionKey = entry.key;
              final optionValue = entry.value;
              return ListTile(
                title: Text(optionValue),
                leading: Radio(
                    value: optionKey,
                    groupValue: selectedOption, // question['answer'],
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value as String;
                      });
                    }),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
