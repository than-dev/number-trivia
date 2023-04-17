import 'package:clean_flutter/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:clean_flutter/features/number_trivia/presentation/bloc/number_trivia/number_trivia_state.dart';
import 'package:clean_flutter/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:clean_flutter/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:clean_flutter/features/number_trivia/presentation/widgets/trivia_controls_widget.dart';
import 'package:clean_flutter/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:clean_flutter/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              //* Top
              const SizedBox(height: 10),

              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                if (state is NumberTriviaEmptyState) {
                  return const MessageDisplay(message: 'start searching!');
                } else if (state is NumberTriviaLoadingState) {
                  return const LoadingWidget();
                } else if (state is NumberTriviaLoadedState) {
                  return TriviaDisplay(numberTrivia: state.trivia);
                } else if (state is NumberTriviaErrorState) {
                  return MessageDisplay(message: state.message);
                }

                return const Text('');
              }),
              const SizedBox(height: 20),

              //* Bottom
              const TriviaControls()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Number Trivia")),
        body: SingleChildScrollView(child: buildBody(context)));
  }
}
