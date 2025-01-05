import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class TranslationService {
  TranslationService({@visibleForTesting Client? client})
      : _client = client ?? Client();

  final Client _client;

  Future<String> getSentenceFrom({required int tatoebaKey}) async {
    final response = await _client
        .get(Uri.parse('https://tatoeba.org/en/api_v0/sentence/$tatoebaKey'));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(response.body);
    }

    final parsedResponse = json.decode(response.body) as Map<String, dynamic>;
    final List translations = parsedResponse['translations'];
    final translationGroupContainingEngTranslation =
        translations.firstWhereOrNull(
      (translation) => translation
          .where(
            (translation) => translation['lang'] == 'eng',
          )
          .isNotEmpty,
    );

    if (translationGroupContainingEngTranslation == null) {
      throw Exception('No English translation found');
    }

    final translation = translationGroupContainingEngTranslation
        .where((translation) => translation['lang'] == 'eng')
        .first['text'] as String;

    return translation;
  }
}
