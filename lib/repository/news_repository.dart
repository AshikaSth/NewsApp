
import 'package:flutter_dotenv/flutter_dotenv.dart';



class NewsRepository{


  Future <void> fetchNewChannelHeadlinesApi()async{
    String apiKey = dotenv.env['API_KEY'] ?? 'default_api_key';
    String url = 'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=$apiKey';
  }
}