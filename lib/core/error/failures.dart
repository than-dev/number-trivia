import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List<dynamic> properties;

  const Failure({required this.properties});

  @override
  List<dynamic> get props => properties;
}
