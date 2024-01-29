import 'dart:convert';
import '/model/news_model.dart';
import 'package:http/http.dart' as http;
class NewService{

  Future<NewsModel?> fetchNews(String category)async{
    final response = await http.get(
      Uri.parse("https://api.collectapi.com/news/getNews?country=tr&tag=$category"),
      headers: {
        "content-type": "application/json",
        "authorization": "apikey 67y5Cyf89dYC5EHT9851Cj:5Z62PU8picRaDDBTPvk6wY",
      },
    );

    if (response.statusCode == 200) {
      var jsonBody = NewsModel.fromJson(jsonDecode(response.body));
      return jsonBody;
    } else {
      print("Error: ${response.statusCode}");
    }
  }

}