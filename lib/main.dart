import 'package:cats/Cat.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart'  as http;
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

class Constants {
  static var url = "https://api.thecatapi.com/";
  final BREEDS = url + "https://api.thecatapi.com/v1/breeds";
  final IMAGE = url + "https://api.thecatapi.com/images/search?breed_id=";
}

class Resource<T> {
  final String url;
  T Function(Response response) parse;

  Resource({this.url,this.parse});
}

class Webservice {

  Future<T> load<T>(Resource<T> resource) async {

    final response = await http.get(resource.url);
    if(response.statusCode == 200) {
      return resource.parse(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }
}


class CatListState extends State<CatList> {

  List<Cat> _cats = List<Cat>();
  Cat selectedCat;

  @override
  void initState() {
    super.initState();
    populateList();
  }

  void selectCat(Cat cat) {
    setState(() => {
      selectedCat = cat
    });
  }

  void populateList() {
    Webservice().load(Cat.all).then((cats) => {
      setState(() => {
        _cats = cats
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Breeds",
      home: Scaffold(
        appBar: AppBar(
          title: Text('Breed list'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh), onPressed: refresh),
          ],
        ),
        body: ListView.separated(
            itemBuilder: (context, index) => ListTile(
              title: Text(_cats[index].name, style: TextStyle(fontSize: 18)),
              onTap: () {
                openBreedDetail(_cats[index], context);
              },
            ),
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            itemCount: _cats.length),
      )
    );
  }

  void openBreedDetail(Cat cat, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(cat.name),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.refresh), onPressed: refreshImage),
              ],
            ),
            body: Column(
              children: <Widget>[
                FutureBuilder(
                  future: Webservice().load(cat.image),
                  builder: (BuildContext context, AsyncSnapshot<CatImage> image) {
                    if (image.hasData) {
                      return Image.network(
                          image.data.url,
                          height: 250,
                      );  // image is ready
                    } else {
                      return new Container(
                        height: 250,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );  // placeholder
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Text(
                    cat.name,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Text(
                    cat.description,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void refresh() {
    populateList();
  }

  void refreshImage() {
    selectCat(selectedCat);
  }
}

void main() => runApp(CatList());

class CatList extends StatefulWidget {
  @override
  CatListState createState() => CatListState();
}