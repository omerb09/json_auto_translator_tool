import 'dart:convert';
import 'dart:io';
import 'package:translator/translator.dart';

void main() async {
  final translator = GoogleTranslator();

  File willTranslateFile = File('will_translate.json');
  File translatedFile = File('translated.json');
  String fromLaunguage = 'tr';
  List translateLaunguages = ['en', 'nl', 'ru'];

  final willTranslateString = await willTranslateFile.readAsString();
  final Map<String, dynamic> willTranslateJson = jsonDecode(willTranslateString);

  Map<String, dynamic> newJson = {};

  for (var launguage in translateLaunguages) {
    int count = 1;
    for (var element in willTranslateJson.entries) {
      try {
        var translation = await translator.translate(element.value, from: fromLaunguage, to: launguage);
        newJson.addAll({element.key: translation.text});
        print('$count : $translation');
      } catch (e) {
        print(e.toString());
      }
      count++;
    }
    translatedFile = File('locales/$launguage.json');

    final encoded = getPrettyJSONString(newJson);
    await translatedFile.writeAsString(encoded);
  }
}

String getPrettyJSONString(jsonObject) {
  var encoder = new JsonEncoder.withIndent("     ");
  return encoder.convert(jsonObject);
}
