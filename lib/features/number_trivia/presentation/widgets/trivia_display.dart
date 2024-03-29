import 'package:clean_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter/material.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplay({required this.numberTrivia, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          children: [
            Text(
              numberTrivia.number.toString(),
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(numberTrivia.text,
                      style: const TextStyle(fontSize: 25),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          ],
        ));
  }
}
