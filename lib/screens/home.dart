import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Show>> shows;

  @override
  void initState() {
    super.initState();
    shows = fetchShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyAnimeList')),
      body: Center(
        child: FutureBuilder(
          future: shows,
          builder: (context, AsyncSnapshot<List<Show>> snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.only(top: 30, left: 24),
                      width: 300,
                      height: 300,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(21),
                            child: Image.network(
                              snapshot.data![index].images.jpg.image_url,
                              height: 200,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![index].title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      snapshot.data![index].score.toString(),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Someting went wrong'));
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class Show {
  final num malId;
  final String title;
  Images images;
  final double score;

  Show({
    required this.malId,
    required this.title,
    required this.images,
    required this.score,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      malId: json['mal_id'],
      title: json['title'],
      images: Images.fromJson(json['images']),
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() => {
        'mal_id': malId,
        'title': title,
        'images': images,
        'score': score,
      };
}

class Images {
  final Jpg jpg;

  Images({required this.jpg});
  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      jpg: Jpg.fromJson(json['jpg']),
    );
  }

  Map<String, dynamic> toJson() => {
        'jpg': jpg.toJson(),
      };
}

class Jpg {
  String image_url;
  String small_image_url;
  String large_image_url;

  Jpg({
    required this.image_url,
    required this.small_image_url,
    required this.large_image_url,
  });

  factory Jpg.fromJson(Map<String, dynamic> json) {
    return Jpg(
      image_url: json['image_url'],
      small_image_url: json['small_image_url'],
      large_image_url: json['large_image_url'],
    );
  }
  //to json
  Map<String, dynamic> toJson() => {
        'image_url': image_url,
        'small_image_url': small_image_url,
        'large_image_url': large_image_url,
      };
}

Future<List<Show>> fetchShows() async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v4/top/manga'));

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body)['data'] as List;
    return jsonResponse.map((show) => Show.fromJson(show)).toList();
  } else {
    throw Exception('Failed to load shows');
  }
}
