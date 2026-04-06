import 'package:flutter/material.dart';

import '../shared/theme/app_colors.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = HomeController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _keywordsController = TextEditingController();

  @override
  void dispose() {
    _homeController.dispose();
    _topicController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1152),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 48),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return ListenableBuilder(
                      listenable: _homeController,
                      builder: (context, child) {
                        if (constraints.maxWidth > 1024) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 5, child: _buildInputSection()),
                              const SizedBox(width: 48),
                              Expanded(
                                flex: 7,
                                child: _buildOutputSection(
                                  _homeController.generatedContent,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              _buildInputSection(),
                              const SizedBox(height: 48),
                              _buildOutputSection(
                                _homeController.generatedContent,
                              ),
                            ],
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Architect AI',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF312E81), // indigo-900 rough equivalent
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Create Masterpieces.',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
            height: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Leverage the power of Editorial AI to curate high-end narratives and digital experiences in seconds.',
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF191C1E).withValues(alpha: 0.06),
                offset: const Offset(0, 12),
                blurRadius: 40,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.edit_note, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Configuration',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildInputLabel('CONTENT TOPIC'),
              const SizedBox(height: 8),
              _buildTextField(
                'e.g., The future of AI in content creation',
                1,
                _topicController,
              ),
              const SizedBox(height: 24),
              _buildInputLabel('KEYWORDS'),
              const SizedBox(height: 8),
              _buildTextField(
                'AI, content, future, technology...',
                4,
                _keywordsController,
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      offset: const Offset(0, 10),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _homeController.isLoading
                        ? null
                        : () async {
                            if (_topicController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please enter a content topic.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                              return;
                            }
                            await _homeController.generateContent(
                              topic: _topicController.text,
                              keywords: _keywordsController.text,
                            );
                            if (!mounted) return;
                            if (_homeController.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _homeController.errorMessage!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: _homeController.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: AppColors.onPrimary,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Generate Content',
                                style: TextStyle(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAc20EYcjE3VvEbSXuRi5wDPGSLpC8c3kH2_UUzqPx2B9-Pakc8exJTxl73upM07mua30EDhMEqxDd1kgsp2oInSshVxHyct6CR1SasXRtt2btuKyI3_q61bnlpHa01QVJFGWhYxWt0vSA1fCpXxbfr1IE9grHDvWi4kwjeQrT2bYd_pGNtRhpwWpsEJ_KO4pZD8DyYjbalhY2jHXnTJKzA4DN7BXVEIibZguUBNvSIERUD9oaCVu-PIzzlpURsQNvkHHZbwsufxg64',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey[200]),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 24),
                    Icon(
                      Icons.tips_and_updates_outlined,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pro Tip',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Use specific adjectives in your topic for more nuanced editorial tone.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey, // text-slate-500 equivalent
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    int maxLines,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildOutputSection(GeneratedContent? content) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF191C1E).withValues(alpha: 0.04),
            offset: const Offset(0, 12),
            blurRadius: 40,
          ),
        ],
      ),
      child: content == null
          ? _buildEmptyOutputSection()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.content_copy,
                        size: 20,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.download,
                        size: 20,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.share,
                        size: 20,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'DRAFT GENERATED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSecondaryContainer,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  content.title,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  content.subtitle,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 32),
                ...content.bodyParagraphs.map(
                  (paragraph) => Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Text(
                      paragraph,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(
                  color: AppColors.surfaceContainerLow,
                  thickness: 1,
                ),
                const SizedBox(height: 32),
                const Text(
                  'SEO OPTIMIZATION',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                ...content.seoOptimizations.map((seo) => _buildSeoItem(seo)),
                const SizedBox(height: 24),
                const Text(
                  'TAGS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: content.tags.map((tag) => _buildTag(tag)).toList(),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyOutputSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.auto_awesome, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Content Generated Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Fill out the configuration and click "Generate Content"\nto see your architectural masterpiece here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeoItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondaryFixed,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.onSecondaryFixed,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class GeneratedContent {
  final String title;
  final String subtitle;
  final List<String> bodyParagraphs;
  final List<String> seoOptimizations;
  final List<String> tags;

  const GeneratedContent({
    required this.title,
    required this.subtitle,
    required this.bodyParagraphs,
    required this.seoOptimizations,
    required this.tags,
  });
}
