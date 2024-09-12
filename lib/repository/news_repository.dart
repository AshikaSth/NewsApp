
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';

import '../models/search_news_model.dart';


class NewsRepository{
  Future <NewsChannelHeadlinesModel> fetchNewChannelHeadlinesApi(String channelName)async{

    String apiKey = dotenv.env['API_KEY'] ?? 'default_api_key';
    if (apiKey == 'default_api_key') {
      throw Exception('API key is missing');
    }
    String url = 'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }
  Future <CategoriesNewsModel> fetchCategoriesNewsApi(String category)async{

    String apiKey = dotenv.env['API_KEY'] ?? 'default_api_key';
    if (apiKey == 'default_api_key') {
      throw Exception('API key is missing');
    }
    String url = 'https://newsapi.org/v2/everything?q=${category}&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<SearchNewsModel> fetchSearchNewsApi(String search, String date) async {
    String apiKey = dotenv.env['API_KEY'] ?? 'default_api_key';
    if (apiKey == 'default_api_key') {
      throw Exception('API key is missing');
    }

    // Construct the URL using the `date` parameter for flexibility
    String url = 'https://newsapi.org/v2/everything?q=${search}&from=${date.split(':')[0]}&to=${date.split(':')[1]}&sortBy=popularity&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return SearchNewsModel.fromJson(body);
    }

    throw Exception('Error fetching news data');
  }

}