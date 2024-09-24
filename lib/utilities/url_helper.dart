import 'package:url_launcher/url_launcher.dart' as url_launcher;

class UrlHelper {
  const UrlHelper();

  Future<bool> launchWiktionaryPageFor(String word) {
    return launchUrl(
        'https://en.wiktionary.org/wiki/${word.toLowerCase().replaceAll(RegExp(r'[,.?!]'), '')}#Russian');
  }

  Future<bool> launchUrl(String url) async {
    return await url_launcher.launchUrl(Uri.parse(url));
  }
}
