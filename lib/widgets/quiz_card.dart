import 'package:flutter/material.dart';

class QuizCard extends StatelessWidget {
  final Map<String, dynamic> question;

  QuizCard({required this.question});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question['question']),
            SizedBox(height: 16),
            ...question['option'].entries.map((entry) {
              final optionKey = entry.key;
              final optionValue = entry.value;
              return ListTile(
                title: Text(optionValue),
                leading: Radio(
                  value: optionKey,
                  groupValue: question['answer'],
                  onChanged: null,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
