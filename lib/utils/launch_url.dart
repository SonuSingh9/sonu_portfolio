import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in a new tab / external app. No-op if it can't be launched.
Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
