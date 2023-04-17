import 'package:clean_flutter/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:clean_flutter/features/number_trivia/presentation/bloc/number_trivia/number_trivia_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({super.key});

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final textController = TextEditingController();
  late String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'input a number'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              inputStr = value;
            },
            onSubmitted: (_) {
              addGetConcreteNumberTriviaEvent();
            }),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: addGetConcreteNumberTriviaEvent,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.secondary),
                    ),
                    child: const Text('Search'))),
            const SizedBox(width: 10),
            Expanded(
                child: ElevatedButton(
                    onPressed: addGetRandomNumberTriviaEvent,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                    child: const Text(
                      'Get random trivia',
                      style: TextStyle(color: Colors.black),
                    ))),
          ],
        )
      ],
    );
  }

  void addGetConcreteNumberTriviaEvent() {
    textController.clear();

    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetConcreteNumberTriviaEvent(inputStr));
  }

  void addGetRandomNumberTriviaEvent() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetRandomNumberTriviaEvent());
  }
}
