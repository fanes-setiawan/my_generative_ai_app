import 'package:equatable/equatable.dart';

abstract class AiState extends Equatable {
  const AiState();

  @override
  List<Object> get props => [];
}

class AiInitial extends AiState {}

class AiLoading extends AiState {}

class AiLoaded extends AiState {
  final String content;

  const AiLoaded(this.content);

  @override
  List<Object> get props => [content];
}

class AiError extends AiState {
  final String message;

  const AiError(this.message);

  @override
  List<Object> get props => [message];
}
