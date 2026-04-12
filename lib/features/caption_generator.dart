import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CaptionGenerator extends StatefulWidget {
  const CaptionGenerator({super.key});

  @override
  State<CaptionGenerator> createState() => _CaptionGeneratorState();
}

class _CaptionGeneratorState extends State<CaptionGenerator> {
  late final TextEditingController _captionController;
  late String _generatedCaption;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _generatedCaption = '';
    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _generateCaption() async {
    if (_captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a description to generate a caption.'),
        ),
      );
      return;
    }
    try {
      setState(() => _isGenerating = true);

      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-3.1-flash-lite-preview',
        generationConfig: GenerationConfig(
          maxOutputTokens: 50,
          temperature: 0.7,
        ),
        systemInstruction: Content.system(
          'You generate concise captions that are catchy and engaging, suitable for social media posts or advertisements.'
          'Do not use markdown, bullet points, headings, code blocks, or JSON.',
        ),
      );

      final response = await model.generateContent([
        Content.text(_captionController.text),
      ]);

      setState(() => _generatedCaption = response.text!);
    } catch (e) {
      print('Error generating caption: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error generating caption: $e')));
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caption Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                labelText: 'Enter brand or product name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isGenerating ? null : _generateCaption,
              child: _isGenerating
                  ? const CircularProgressIndicator()
                  : const Text('Generate Caption'),
            ),
            const SizedBox(height: 16),
            if (_generatedCaption.isNotEmpty)
              Row(
                children: [
                  Text(
                    'Generated Caption:\n$_generatedCaption',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _generatedCaption));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Caption copied to clipboard!'),
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
