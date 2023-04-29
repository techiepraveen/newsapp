//@dart=2.8
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/screens/newsscreen.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double height = 50;
  double width = 50;
  double height1 = 50;
  double width1 = 300;

  Color color = Colors.transparent;
  final searchController = TextEditingController();

  final List navBarItem = [
    "Top News",
    "India",
    "World",
    "Sports",
    "finanace",
    "health",
    "jokes"
  ];

  String stringResponse;
  Map mapResponse;
  Map dataResponse;
  List listResponse = [];

  Future apiCall() async {
    http.Response response;
    String url =
        "https://newsapi.org/v2/everything?q=apple&from=2023-04-06&to=2023-04-06&sortBy=popularity&apiKey=6772e04b9e0f46b3af019188966bbbc3";
    response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        stringResponse = response.body;
        mapResponse = json.decode(response.body);
        // dataResponse = mapResponse['articles'];
        listResponse = mapResponse['articles'];
      });
    } else {
      print("error in loading");
    }
  }

  @override
  void initState() {
    apiCall();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  //color: Colors.blue,
                  height: height1,
                  width: width1,
                  duration: const Duration(seconds: 0),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: Text(
                      "Breaking News",
                      style:
                          TextStyle(fontSize: 40, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: color),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  // final random = Random();
                                  height = 50.0;
                                  width = 400.0;
                                  color = Colors.amber;
                                  height1 = 0.0;
                                  width1 = 0.0;
                                  setState(() {});
                                },
                                onDoubleTap: () {
                                  height = height;
                                  width = width;

                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.search,
                                )),
                            Expanded(
                              child: TextField(
                                  textInputAction: TextInputAction.search,
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 50,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: navBarItem.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text(navBarItem[index])),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.amber,
                  image: DecorationImage(
                    image: NetworkImage == null
                        ? CircularProgressIndicator()
                        : NetworkImage(
                            listResponse[0]['urlToImage'],
                          ),
                    fit: BoxFit.cover,
                  )),

              // child: ImageSlideshow(
              //   autoPlayInterval: 3000,
              //   isLoop: true,
              //   children: [
              //     ListView.builder(
              //         itemCount: listResponse.length,
              //         itemBuilder: (context, index) {
              //           return Image.network(listResponse[index]['urlToImage']);
              //         }),
              //     ListView.builder(
              //         itemCount: listResponse.length,
              //         itemBuilder: (context, index) {
              //           return Image.network(listResponse[index]['urlToImage']);
              //         }),
              //     ListView.builder(
              //         itemCount: listResponse.length,
              //         itemBuilder: (context, index) {
              //           return Image.network(listResponse[index]['urlToImage']);
              //         })
              //   ],
              // ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: listResponse.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewsScreen(
                                        img: listResponse[index]['urlToImage'],
                                        description: listResponse[index]
                                            ['description'],
                                        author: listResponse[index]['author'],
                                        title: listResponse[index]['title'],
                                      )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.amber,
                          ),
                          height: 100,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        image: NetworkImage == null
                                            ? CircularProgressIndicator()
                                            : NetworkImage(
                                                listResponse[index]
                                                    ['urlToImage'],
                                              ),
                                        fit: BoxFit.cover)),
                                // child: Image.network(
                                //     listResponse[index]['urlToImage'],
                                //     fit: BoxFit.fill),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        style: TextStyle(color: Colors.black),
                                        text: listResponse == null
                                            ? CircularProgressIndicator()
                                            : listResponse[index]
                                                ['description']),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
