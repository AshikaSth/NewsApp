
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {

  final String newsImage, newsTitle, newsDate, author, description, content, source;
  const NewsDetailScreen({Key?key,
    required this.newsImage,
    required this.newsTitle,
    required this.newsDate,
    required this.author,
    required this.description,
    required this.content,
    required this.source,

  }): super(key: key);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final format = DateFormat('MMM dd, yyyy');
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(widget.newsDate);

    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: height * 0.45,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(40),
              ),
              child: CachedNetworkImage(
                // Validate if the image URL is not empty or null
                imageUrl: widget.newsImage.isNotEmpty
                    ? widget.newsImage
                    : 'https://via.placeholder.com/150', // Placeholder image if the URL is invalid

                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 50,
                ),
                fit: BoxFit.cover, // Ensure the image covers the container
              ),
            ),

          ),

          Container(
            height: height * .6,
            margin: EdgeInsets.only(top: height * .4),
            padding: EdgeInsets.only(top: 20, right: 20, left: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(40),
              ),
            ),
            child: ListView(
              children: [
                Text(widget.newsTitle, style:  GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),),

                SizedBox(height:  height * 0.02,),
                Row(
                  children: [
                    Expanded(
                      child: Text(widget.source,style:  GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),),
                    ),
                    Text(format.format(dateTime),style:  GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),),

                  ],
                ),
                SizedBox(
                  height: height * .03,
                ),
                Text(widget.description,style:  GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                SizedBox(
                  height: height * .03,),
                Text(widget.content,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: height * .03,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '- ',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.author,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )


              ],
            ),
          ),
        ],

      ),
    );
  }
}
