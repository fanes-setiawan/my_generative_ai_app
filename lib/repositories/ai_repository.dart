import 'package:google_generative_ai/google_generative_ai.dart';

class AiRepository {
  final String apiKey;

  AiRepository({required this.apiKey});

  Future<String> generateContent(String prompt) async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text ?? "No content generated";
  }
}
