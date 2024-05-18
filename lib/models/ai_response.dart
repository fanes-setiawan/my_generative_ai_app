class AiResponse {
  final String text;

  AiResponse({required this.text});

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      text: json['text'],
    );
  }
}
