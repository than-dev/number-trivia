import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List<dynamic> properties;

  const Failure({this.properties = const []});

  @override
  List<dynamic> get props => properties;
}

// general failures

class ServerFailure extends Failure {
  const ServerFailure({super.properties});
}

class CacheFailure extends Failure {
  const CacheFailure({super.properties});
}

// strings

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
