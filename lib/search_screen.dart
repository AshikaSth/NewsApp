

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/news_detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

import 'models/search_news_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('yyyy-MM-dd');
  final TextEditingController _searchController = TextEditingController();
  String search = 'Apple';

  // Set the initial date range for today's date
  String date = '';

  @override
  void initState() {
    super.initState();
    // Set today's date as the initial date
    date = '${format.format(DateTime.now())}:${format.format(DateTime.now())}';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Perform search and adjust the date to 30 days ago to today
  void _performSearch() {
    setState(() {
      search = _searchController.text.isNotEmpty ? _searchController.text : 'general';

      // Update the date range to 30 days ago to today when search is pressed
      DateTime now = DateTime.now();
      DateTime thirtyDaysAgo = now.subtract(Duration(days: 30));
      date = '${format.format(thirtyDaysAgo)}:${format.format(now)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _performSearch,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0), // Height of the search bar
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<SearchNewsModel>(
        future: newsViewModel.fetchSearchNewsApi(search, date),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
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
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(15),
                        //   child: CachedNetworkImage(
                        //     imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                        //     fit: BoxFit.cover,
                        //     height: height * .18,
                        //     width: width * .3,
                        //     placeholder: (context, url) => Container(
                        //       child: Center(
                        //         child: SpinKitCircle(
                        //           size: 50,
                        //           color: Colors.blue,
                        //         ),
                        //       ),
                        //     ),
                        //     errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                        //   ),
                        // ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            // Check if the URL is null or not a valid URL
                            imageUrl: (snapshot.data!.articles![index].urlToImage != null && snapshot.data!.articles![index].urlToImage!.isNotEmpty)
                                ? snapshot.data!.articles![index].urlToImage.toString()
                                : 'https://via.placeholder.com/150', // Use a placeholder image when URL is invalid

                            fit: BoxFit.cover,
                            height: height * .18,
                            width: width * .3,

                            // Show a loading spinner while the image is loading
                            placeholder: (context, url) => Container(
                              alignment: Alignment.center,
                              child: SpinKitCircle(
                                size: 50,
                                color: Colors.blue,
                              ),
                            ),

                            // Show an error icon if the image fails to load
                            errorWidget: (context, url, error) => Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 50,
                            ),
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
    );
  }
}
