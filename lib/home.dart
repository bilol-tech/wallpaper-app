import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaper_app/data/data.dart';
import 'dart:convert';
import 'package:wallpaper_app/models/categorie_model.dart';
import 'package:wallpaper_app/models/photos_model.dart';
import 'package:wallpaper_app/view/categorie_screen.dart';
import 'package:wallpaper_app/view/search_view.dart';
import 'package:wallpaper_app/widget/widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategorieModel> categories = [];
  int noOfImageToLoad = 30;
  List<PhotosModel> photos = [];

  getTrendingWallpaper() async {
    var uir = Uri.parse(
        "https://api.pexels.com/v1/curated?per_page=$noOfImageToLoad&page=1");
    await http.get(uir, headers: {"Authorization": apiKEY}).then((value) {
      //print(value.body);

      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["photos"].forEach((element) {
        PhotosModel photosModel;
        photosModel = PhotosModel.fromMap(element);
        photos.add(photosModel);
        //print(photosModel.toString()+ "  "+ photosModel.src.portrait);
      });
      if (mounted) {
        setState(() {});
      }
    });
  }

  TextEditingController searchController = TextEditingController();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    //getWallpaper();
    getTrendingWallpaper();
    categories = getCategories();
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        noOfImageToLoad = noOfImageToLoad + 30;
        getTrendingWallpaper();
      }
    });
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: brandName(),
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: const Color(0xfff5f8fd),
                borderRadius: BorderRadius.circular(30),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                        hintText: "Search wallpapers",
                        border: InputBorder.none),
                  )),
                  InkWell(
                      onTap: () {
                        if (searchController.text != "") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchView(
                                        search: searchController.text,
                                      )));
                        }
                      },
                      child: const Icon(Icons.search))
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     const Text(
            //       "Made By ",
            //       style: TextStyle(
            //           color: Colors.black54,
            //           fontSize: 12,
            //           fontFamily: 'Overpass'),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         _launchURL(
            //             "https://sites.google.com/view/sudeshbandara/home?authuser=0");
            //       },
            //       child: const SizedBox(
            //           child: Text(
            //         "Sudesh Bandara",
            //         style: TextStyle(
            //             color: Colors.blue,
            //             fontSize: 12,
            //             fontFamily: 'Overpass'),
            //       )),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    /// Create List Item tile
                    return CategoriesTile(
                      imgUrls: categories[index].imgUrl,
                      categorie: categories[index].categorieName,
                    );
                  }),
            ),
            wallPaper(photos, context),
            SizedBox(height: 10,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     const Text(
            //       "Photos provided By ",
            //       style: TextStyle(
            //           color: Colors.black54,
            //           fontSize: 12,
            //           fontFamily: 'Overpass'),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         _launchURL("https://www.pexels.com/");
            //       },
            //       child: const SizedBox(
            //           child: Text(
            //         "Pexels",
            //         style: TextStyle(
            //             color: Colors.blue,
            //             fontSize: 12,
            //             fontFamily: 'Overpass'),
            //       )),
            //     )
            //   ],
            // ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrls, categorie;

  const CategoriesTile(
      {Key? key, required this.imgUrls, required this.categorie})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategorieScreen(
                      categorie: categorie,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: imgUrls,
                  height: 50,
                  width: 100,
                  fit: BoxFit.cover,
                )),
            Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            Container(
                height: 50,
                width: 100,
                alignment: Alignment.center,
                child: Text(
                  categorie,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Overpass'),
                ))
          ],
        ),
      ),
    );
  }
}
