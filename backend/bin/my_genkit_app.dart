import 'dart:convert';

import 'package:genkit/genkit.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';
import 'package:genkit_shelf/genkit_shelf.dart';
import 'package:schemantic/schemantic.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

part 'my_genkit_app.g.dart';

@Schema()
abstract class $ContentInput {
  @Field(description: 'The main topic or theme for the content')
  String get contentTopic;

  @Field(description: 'Any specific keywords to include in the content')
  String? get keywords;
}

// Define output schema
@Schema()
abstract class $Content {
  String get title;
  String get subtitle;
  String get content;
  List<String> get seoText;
  List<String> get tags;
}

void main() async {
  final ai = Genkit(plugins: [googleAI()]);

  final contentGenerator = ai.defineFlow(
    name: 'contentGenerator',
    inputSchema: ContentInput.$schema,
    outputSchema: Content.$schema,
    // inputSchema: SchemanticType.string(),
    // outputSchema: SchemanticType.string(),
    fn: (ContentInput input, _) async {
      final response = await ai.generate(
        model: googleAI.gemini('gemini-2.5-flash'),
        config: GeminiOptions(temperature: 0.8),
        prompt:
            'Generate a blog post about ${input.contentTopic}. Include the following keywords: ${input.keywords ?? 'none'}. Format the output as JSON with the following structure: { "title": string, "subtitle": string, "content": string, "seoText": [string], "tags": [string] }',
        outputSchema: Content.$schema,
      );

      if (response.output == null) {
        throw Exception('Failed to generate content');
      }
      return response.output!;
    },
  );

  // Run the content generator flow
  final content = await contentGenerator(
    ContentInput(
      contentTopic: 'The benefits of meditation',
      keywords: 'meditation, mindfulness, mental health',
    ),
  );

  // Print the generated content
  print(JsonEncoder.withIndent('  ').convert(content));

  // Router() creates a request router that maps URLs to handlers:
  final router = Router()
    ..post('/contentGenerator', shelfHandler(contentGenerator));

  // A chain of middleware + a final handler:
  final handler = Pipeline()
      .addMiddleware(corsHeaders())
      .addHandler(router.call);

  // Start the HTTP server — binds to localhost:3400 and listens for incoming
  // requests:
  await io.serve(handler, 'localhost', 3400);

  print('Serving at http://localhost:3400');
}
