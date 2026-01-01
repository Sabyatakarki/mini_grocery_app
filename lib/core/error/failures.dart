import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  final String message;

  const Failures(this.message);

  @override
  List<Object?> get props => [message];
}
class LocalDataBaseFailure extends Failures {
  const LocalDataBaseFailure({
    String message='local database operation failed',
  }) : super(message);
}

class ApiFailure extends Failures {
  final int? statusCode;
  
  const ApiFailure({
   required String message,
    this.statusCode,
  }) : super(message);

  @override
  List<Object?> get props => [message, statusCode];
}