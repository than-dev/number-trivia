import 'dart:convert';

import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  factory NumberTriviaModel.fromJson(String jsonString) {
    final jsonDecoded = json.decode(jsonString);

    return NumberTriviaModel(
      text: jsonDecoded['text'],
      number: (jsonDecoded['number']).toInt(),
    );
  }

  String toJson() {
    return json.encode({
      "text": text,
      "number": number,
    });
  }

  const NumberTriviaModel({
    required String text,
    required int number,
  }) : super(
          text: text,
          number: number,
        );
}
