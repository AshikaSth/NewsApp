


import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';
import 'package:news_app/repository/news_repository.dart';

import '../models/search_news_model.dart';

class NewsViewModel{
  final _rep= NewsRepository();

  Future<NewsChannelHeadlinesModel> fetchNewChannelHeadlinesApi(String channelName)async{
    final response = await _rep.fetchNewChannelHeadlinesApi(channelName);
    return response;
  }
  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category)async{
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }
  Future<SearchNewsModel> fetchSearchNewsApi(String search, String date)async{
    final response = await _rep.fetchSearchNewsApi(search,date);
    return response;
  }
}