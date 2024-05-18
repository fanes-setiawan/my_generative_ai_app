import 'package:bloc/bloc.dart';
import '../repositories/ai_repository.dart';
import 'ai_event.dart';
import 'ai_state.dart';

class AiBloc extends Bloc<AiEvent, AiState> {
  final AiRepository aiRepository;

  AiBloc({required this.aiRepository}) : super(AiInitial()) {
    on<GenerateContent>(_onGenerateContent);
  }
  Future<void> _onGenerateContent(
      GenerateContent event, Emitter<AiState> emit) async {
    emit(AiLoading());
    try {
      final content = await aiRepository.generateContent(event.prompt);
      emit(AiLoaded(content));
    } catch (e) {
      emit(AiError("Failed to generate content"));
    }
  }
}
