import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/models/photos_model.dart';
import 'package:wallpaper_app/view/image_view.dart';

Widget wallPaper(List<PhotosModel> listPhotos, BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    height: 817,
    // child: GridView.count(
    //     crossAxisCount: 2,
    //     childAspectRatio: 0.6,
    //     physics: const ClampingScrollPhysics(),
    //     shrinkWrap: true,
    //     padding: const EdgeInsets.all(4.0),
    //     mainAxisSpacing: 6.0,
    //     crossAxisSpacing: 6.0,
    //     children: listPhotos.map((PhotosModel photoModel) {
    //       return GridTile(
    //           child: GestureDetector(
    //         onTap: () {
    //           Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => ImageView(
    //                         imgPath: photoModel.src.portrait,
    //                       )));
    //         },
    //         child: Hero(
    //           tag: photoModel.src.portrait,
    //           child: ClipRRect(
    //               borderRadius: BorderRadius.circular(16),
    //               child: kIsWeb
    //                   ? Image.network(
    //                       photoModel.src.portrait,
    //                       height: 50,
    //                       width: 100,
    //                       fit: BoxFit.cover,
    //                     )
    //                   : CachedNetworkImage(
    //                       imageUrl: photoModel.src.portrait,
    //                       placeholder: (context, url) => Container(
    //                             color: const Color(0xfff5f8fd),
    //                           ),
    //                       fit: BoxFit.cover)),
    //         ),
    //       ));
    //     }).toList()),
    child: GridView.custom(
      // semanticChildCount: 20,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverWovenGridDelegate.count(
        crossAxisCount: 2,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        pattern: [
          const WovenGridTile(0.6),
          const WovenGridTile(
            0.7,
            crossAxisRatio: 0.9,
            alignment: AlignmentDirectional.centerEnd,
          ),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate((context, index) {
        return GridTile(
            child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageView(
                          imgPath: listPhotos[index].src.portrait,
                        )));
          },
          child: Hero(
            tag: listPhotos[index].src.portrait,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                    imageUrl: listPhotos[index].src.portrait,
                    placeholder: (context, url) => Container(
                          color: const Color(0xfff5f8fd),
                        ),
                    fit: BoxFit.cover)),
          ),
        ));
      }, childCount: listPhotos.length),
    ),
  );
}

Widget brandName() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const <Widget>[
      Text(
        "Awesome",
        style: TextStyle(color: Colors.black87, fontFamily: 'Overpass'),
      ),
      Text(
        " Walpapers",
        style: TextStyle(color: Colors.blue, fontFamily: 'Overpass'),
      )
    ],
  );
}
