import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utilities/show_snack_bar.dart';

const String apiKey = "c36b3cb8208a856ade6ee27c3789383d";

class APIService {
  Future getData(
      {required context, required double long, required double lat}) async {
    String url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apiKey&units=metric";

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      //var code = response.statusCode;
      String data = response.body;

      return jsonDecode(data);
    } else {
      showSnackBar(
        message: "Error occurred code: ${response.statusCode}",
        context: context,
      );
    }
  }
}
