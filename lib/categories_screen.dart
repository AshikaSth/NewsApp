

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/news_detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  NewsViewModel newsViewModel = NewsViewModel();

  final format = DateFormat('MMM dd, yyyy');
  String categoryName= 'general';

  List<String> categoriesList =[
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
    'Bitcoin'
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(),
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        categoryName = categoriesList[index];
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: categoryName == categoriesList[index]? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Center( child: Text(categoriesList[index].toString(), style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white
                            ),)),
                          )
                        ),
                      ),
                    );
                  },
              )
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(categoryName),
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
                        // final article = snapshot.data!.articles![index];
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
                                    imageUrl: (snapshot.data!.articles![index].urlToImage != null && snapshot.data!.articles![index].urlToImage!.isNotEmpty)
                                        ? snapshot.data!.articles![index].urlToImage.toString()
                                        : 'https://via.placeholder.com/150', // Use a placeholder image when URL is invalid // Use a placeholder image when URL is invalid
                                    fit: BoxFit.cover,
                                    height: height * .18,
                                    width : width * .3,
                                    placeholder: (context, url) => Container(child: Center(
                                       child: SpinKitCircle(
                                           size: 50,
                                           color: Colors.blue,
                                           ),
                                    ),),

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
                                      children: [
                                        Text(snapshot.data!.articles![index].title.toString(),
                                          maxLines: 2,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded( // Use Expanded or Flexible to allow text to wrap
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
                                            SizedBox(width: 8), // Optional: Add some spacing between texts
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
                                        )

                                      ],
                                    ),

                                  ),
                                )
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
      ),
    );
  }
}

