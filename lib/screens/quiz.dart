import 'package:flutter/material.dart';
import 'package:projet_ia/classes/quiz.dart';
import 'package:projet_ia/data/quiz.dart';

class QuizScreen extends StatefulWidget {
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  List<String> selectedCategories = [];

  void nextQuestion(String category) {
    selectedCategories.add(category);
    if (currentIndex < quizQuestions.length - 1) {
      setState(() => currentIndex++);
    } else {
      final result = getQuizResult(selectedCategories);
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("Résultat"),
              content: Text(result),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Fermer"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = quizQuestions[currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text("Quel est ton langage de l’amour ?")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question.text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...question.answers.map(
              (ans) => ElevatedButton(
                onPressed: () => nextQuestion(ans.category),
                child: Text(ans.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
