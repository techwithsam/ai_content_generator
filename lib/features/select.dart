import 'package:content_generator/features/caption_generator.dart';
import 'package:content_generator/features/home_page.dart';
import 'package:flutter/material.dart';

class Selection extends StatelessWidget {
  const Selection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CaptionGenerator(),
                  ),
                );
              },
              child: const Text('Firebase AI Logic'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text('Genkit Dart'),
            ),
          ],
        ),
      ),
    );
  }
}
