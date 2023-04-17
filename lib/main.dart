import 'package:clean_flutter/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';

import 'injection_container.dart' as dependency_injection;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependency_injection.init();

  runApp(const MyApp());
}

final ThemeData theme = ThemeData();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
              primary: Colors.green.shade800,
              secondary: Colors.green.shade600)),
      debugShowCheckedModeBanner: false,
      home: const NumberTriviaPage(),
    );
  }
}
