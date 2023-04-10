import 'package:clean_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTrivia> getConcreteNumberTrivia(int number);
  Future<NumberTrivia> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) async {
    final response = await client.get(
      Uri.http('numbersapi.com', '/$number'),
      headers: {'Content-Type': 'application/json'},
    );

    return NumberTriviaModel.fromJson(response.body);
  }

  @override
  Future<NumberTrivia> getRandomNumberTrivia() {
    return Future.value('' as NumberTrivia);
  }
}
