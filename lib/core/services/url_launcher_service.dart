import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'locator.dart';

class UrlLauncherService {
  final _dialogService = locator<DialogService>();

  final _emailLaunchUri = Uri(scheme: 'mailto', path: 'kvsanal78@gmail.com');

  Future<void> launchEmailApp() async => _launchUrl(_emailLaunchUri.toString());

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url))
      await launch(url);
    else
      _showErrorDialog('Couldn\'t launch email app. Please send an email at ${_emailLaunchUri.path}');
  }

  Future<void> _showErrorDialog(String error) async {
    await _dialogService.showCustomDialog(
      title: 'Error',
      description: error,
    );
  }
}
