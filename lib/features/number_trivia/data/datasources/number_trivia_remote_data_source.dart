import 'package:http/http.dart' as http;

import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTrivia> getConcreteNumberTrivia(int number);
  Future<NumberTrivia> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) {
    client.get(
      Uri.http('numbersapi.com', '/$number'),
      headers: {'Content-Type': 'application/json'},
    );

    return Future.value(const NumberTrivia(text: '', number: 1));
  }

  @override
  Future<NumberTrivia> getRandomNumberTrivia() {
    return Future.value('' as NumberTrivia);
  }
}
