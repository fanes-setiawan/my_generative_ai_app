import 'package:equatable/equatable.dart';

abstract class AiEvent extends Equatable {
  const AiEvent();

  @override
  List<Object> get props => [];
}

class GenerateContent extends AiEvent {
  final String prompt;

  const GenerateContent(this.prompt);

  @override
  List<Object> get props => [prompt];
}
