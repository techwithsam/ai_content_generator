import 'package:schemantic/schemantic.dart';

base class ContentInput {
  factory ContentInput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  ContentInput._(this._json);

  ContentInput({required String contentTopic, String? keywords}) {
    _json = {'contentTopic': contentTopic, 'keywords': ?keywords};
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<ContentInput> $schema =
      _ContentInputTypeFactory();

  String get contentTopic {
    return _json['contentTopic'] as String;
  }

  set contentTopic(String value) {
    _json['contentTopic'] = value;
  }

  String? get keywords {
    return _json['keywords'] as String?;
  }

  set keywords(String? value) {
    if (value == null) {
      _json.remove('keywords');
    } else {
      _json['keywords'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _ContentInputTypeFactory extends SchemanticType<ContentInput> {
  const _ContentInputTypeFactory();

  @override
  ContentInput parse(Object? json) {
    return ContentInput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'ContentInput',
    definition: $Schema
        .object(
          properties: {
            'contentTopic': $Schema.string(
              description: 'The main topic or theme for the content',
            ),
            'keywords': $Schema.string(
              description: 'Any specific keywords to include in the content',
            ),
          },
          required: ['contentTopic'],
        )
        .value,
    dependencies: [],
  );
}

base class Content {
  factory Content.fromJson(Map<String, dynamic> json) => $schema.parse(json);

  Content._(this._json);

  Content({
    required String title,
    required String subtitle,
    required String content,
    required List<String> seoText,
    required List<String> tags,
  }) {
    _json = {
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'seoText': seoText,
      'tags': tags,
    };
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<Content> $schema = _ContentTypeFactory();

  String get title {
    return _json['title'] as String;
  }

  set title(String value) {
    _json['title'] = value;
  }

  String get subtitle {
    return _json['subtitle'] as String;
  }

  set subtitle(String value) {
    _json['subtitle'] = value;
  }

  String get content {
    return _json['content'] as String;
  }

  set content(String value) {
    _json['content'] = value;
  }

  List<String> get seoText {
    return (_json['seoText'] as List).cast<String>();
  }

  set seoText(List<String> value) {
    _json['seoText'] = value;
  }

  List<String> get tags {
    return (_json['tags'] as List).cast<String>();
  }

  set tags(List<String> value) {
    _json['tags'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _ContentTypeFactory extends SchemanticType<Content> {
  const _ContentTypeFactory();

  @override
  Content parse(Object? json) {
    return Content._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'Content',
    definition: $Schema
        .object(
          properties: {
            'title': $Schema.string(),
            'subtitle': $Schema.string(),
            'content': $Schema.string(),
            'seoText': $Schema.list(items: $Schema.string()),
            'tags': $Schema.list(items: $Schema.string()),
          },
          required: ['title', 'subtitle', 'content', 'seoText', 'tags'],
        )
        .value,
    dependencies: [],
  );
}
