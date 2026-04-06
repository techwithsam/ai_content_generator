import 'package:flutter/foundation.dart';
import '../shared/services/content_service.dart';
import 'home_page.dart'; // To reuse GeneratedContent if it exists there

class HomeController extends ChangeNotifier {
  final ContentService _contentService = ContentService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GeneratedContent? _generatedContent;
  GeneratedContent? get generatedContent => _generatedContent;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> generateContent({
    required String topic,
    String? keywords,
  }) async {
    if (topic.trim().isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _contentService.generateContent(
        topic: topic,
        keywords: keywords,
      );

      // Map the strongly-typed response to GeneratedContent model
      _generatedContent = GeneratedContent(
        title: response.title,
        subtitle: response.subtitle,
        bodyParagraphs: response.content
            .split('\n\n')
            .where((p) => p.trim().isNotEmpty)
            .toList(),
        seoOptimizations: response.seoText,
        tags: response.tags,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearContent() {
    _generatedContent = null;
    _errorMessage = null;
    notifyListeners();
  }
}
