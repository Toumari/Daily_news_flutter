import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_app/services/dio_client.dart';
import 'package:news_app/services/news_api.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

DioClient _dio = DioClient();

class _HomePageState extends State<HomePage> {
  bool onPressedValue = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily News',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade900),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Headlines from around the world',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w700),
            ),
            Divider(
              color: Colors.black,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                child: FutureBuilder<List<Article>>(
                  future: _dio.getNews(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<Article>? newsArticle = snapshot.data;
                      return ListView.builder(
                        itemCount: newsArticle?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.all(7),
                            child: ListTile(
                              onTap: () async {
                                await canLaunch(newsArticle![index].url)
                                    ? await launch(newsArticle[index].url)
                                    : throw 'Could not launch ${newsArticle[index].url}';
                              },
                              title: Text(
                                newsArticle![index].title.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                newsArticle[index].description,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: newsArticle[index].urlToImage != null
                                  ? Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  newsArticle[index]
                                                      .urlToImage
                                                      .toString()))),
                                    )
                                  : null,
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
