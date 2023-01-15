import 'package:url_launcher/url_launcher.dart';

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

launchContactNumber(String contactNumber) async {
  String url = "tel:" + contactNumber;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

String encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

launchEmail(String url, String subject) async {
  String urlWithSubject = "mailto:" + url + "?subject=" + subject;
  if (await canLaunch(urlWithSubject)) {
    await launch(urlWithSubject);
  } else {
    throw 'Could not launch $url';
  }
}
