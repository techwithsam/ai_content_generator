import 'package:genkit/client.dart';
import '../models/content_models.dart';

class ContentService {
  final _action = defineRemoteAction(
    url: 'http://localhost:3400/contentGenerator',
    inputSchema: ContentInput.$schema,
    outputSchema: Content.$schema,
  );

  Future<Content> generateContent({
    required String topic,
    String? keywords,
  }) async {
    try {
      final input = ContentInput(contentTopic: topic, keywords: keywords);
      final result = await _action(input: input);
      return result;
    } catch (e) {
      throw Exception(
        'Failed to communicate with content generator backend: $e',
      );
    }
  }
}
