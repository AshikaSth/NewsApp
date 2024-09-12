
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Assuming you use this for the spinner
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/categories_screen.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/news_detail_screen.dart';
import 'package:news_app/search_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:intl/intl.dart';
import 'models/news_channel_headlines_model.dart';

enum FilterList { bbcNews, aryNews, cnn, reuters, independent, alJazeera }

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  String name = 'bbc-news';
  final format = DateFormat('MMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoriesScreen()),
            );
          },
          icon: Image.asset(
            'images/category_icon.png',
            height: 30,
            width: 30,
          ),
        ),
        centerTitle: true,
        title: Text(
          'News',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (FilterList item) {
              setState(() {
                selectedMenu = item;
                switch (item) {
                  case FilterList.bbcNews:
                    name = 'bbc-news';
                    break;
                  case FilterList.cnn:
                    name = 'cnn';
                    break;
                  case FilterList.reuters:
                    name = 'reuters';
                    break;
                  case FilterList.independent:
                    name = 'independent';
                    break;
                  case FilterList.alJazeera:
                    name = 'al-jazeera-english';
                    break;
                  case FilterList.aryNews:
                    name = 'ary-news';
                    break;
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              PopupMenuItem<FilterList>(
                value: FilterList.bbcNews,
                child: Text('BBC News'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.cnn,
                child: Text('CNN'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.reuters,
                child: Text('Reuters'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.alJazeera,
                child: Text('AlJazeera News'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.aryNews,
                child: Text('Ary News'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: height * .55,
            width: width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder<NewsChannelHeadlinesModel>(
                future: newsViewModel.fetchNewChannelHeadlinesApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.articles!.isEmpty) {
                    return Center(
                      child: Text('No articles available'),
                    );
                  } else {
                    return Row(
                      children: List.generate(
                        snapshot.data!.articles!.length,
                            (index) {
                          DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDetailScreen(
                                    newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                    newsTitle: snapshot.data!.articles![index].title.toString(),
                                    newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                    author: snapshot.data!.articles![index].author.toString(),
                                    description: snapshot.data!.articles![index].description.toString(),
                                    content: snapshot.data!.articles![index].content.toString(),
                                    source: snapshot.data!.articles![index].source!.name.toString(),
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                              Container(
                                height: height * 0.6,
                                width: width * 0.9,
                                margin: EdgeInsets.symmetric(horizontal: height * .02),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => spinKit2,
                                    errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                                  ),
                                ),
                              ),
                                Positioned(
                                  bottom: 20,
                                  left: 0,
                                  right: 0,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      width: width * 0.7,
                                      alignment: Alignment.bottomCenter,
                                      height: height * 0.18,
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.7,
                                            child: Text(
                                              snapshot.data!.articles![index].title.toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: width * 0.7,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    snapshot.data!.articles![index].source!.name.toString(),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  format.format(dateTime),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi('General'),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.articles!.isEmpty) {
                  return Center(
                    child: Text('No articles available'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Prevent scrolling within this ListView
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailScreen(
                                newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                newsTitle: snapshot.data!.articles![index].title.toString(),
                                newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                author: snapshot.data!.articles![index].author.toString(),
                                description: snapshot.data!.articles![index].description.toString(),
                                content: snapshot.data!.articles![index].content.toString(),
                                source: snapshot.data!.articles![index].source!.name.toString(),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                  fit: BoxFit.cover,
                                  height: height * .18,
                                  width: width * .3,
                                  placeholder: (context, url) => spinKit2,
                                  errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: height * .18,
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.articles![index].title.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              snapshot.data!.articles![index].source!.name.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            format.format(dateTime),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

const spinKit2 = Center(
  child: SpinKitFadingCircle(
    size: 50,
    color: Colors.blue,
  ),
);
