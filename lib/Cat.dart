import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'dart:convert';

class Cat {
  final String id;
  final String name;
  final String description;

  Cat({this.id, this.name, this.description});

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  static Resource<List<Cat>> get all {
    return Resource(
        url: "https://api.thecatapi.com/v1/breeds",
        parse: (response) {
          final result = json.decode(response.body);
          Iterable list = result;
          return list.map((model) => Cat.fromJson(model)).toList();
        }
    );
  }

  Resource<CatImage> get image {
    return Resource(
        url: "https://api.thecatapi.com/v1/images/search?breed_ids=" + id,
        parse: (response) {
          final result = json.decode(response.body);
          Iterable list = result;
          return list.map((model) => CatImage.fromJson(model)).toList()[0];
        }
    );
  }

//  Widget get image {
//    return Image.network(
//      "https://api.thecatapi.com/v1/images/search?breed_ids=" + id,
//      height: 250,
//      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
//        if (loadingProgress == null)
//          return Image.network(
//            "https://www.pngitem.com/pimgs/m/287-2875094_data-loading-error-comments-error-loading-image-icon.png",
//            height: 250,
//          );
//        return Center(
//          child: CircularProgressIndicator(
//            value: loadingProgress.expectedTotalBytes != null
//                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
//                : null,
//          ),
//        );
//      },
//    );
//  }
}

class CatImage {
  final String id;
  final String url;

  CatImage({this.id, this.url});

  factory CatImage.fromJson(Map<String, dynamic> json) {
    return CatImage(
      id: json['id'],
      url: json['url'],
    );
  }
}