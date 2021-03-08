import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery/max_size_photo.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gallery App', // Назва додатку в вікні запущених додатків
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          // Налаштування вигляду AppBar
          color: Colors.black,
          elevation: 2,
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List getData = [];

  Future<List> getJSONData() async {
    // Запит Get який отримує у відповідь масив з 30 об'єктів
    var response = await http.get(
      Uri.encodeFull(
          "https://api.unsplash.com/photos/?per_page=30&order_by=popular&client_id=cf49c08b444ff4cb9e4d126b7e9f7513ba1ee58de7906e4360afc1a33d1bf4c0"),
    );

    setState(() {
      // Присвоєння змінній декодованого json словника
      getData = json.decode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Gallery App'),
      ),
      body: _buildGridView(),
    );
  }

  Widget _buildGridView() {
    this.getJSONData();
    return Container(
      margin: EdgeInsets.all(12),
      child: StaggeredGridView.countBuilder(
          // Створює плитку з отриманими зображеннями
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          itemCount: getData.length,
          itemBuilder: (context, index) {
            return Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: _buildImageColumn(getData[index]),
              ),
            );
          },
          staggeredTileBuilder: (index) {
            return StaggeredTile.fit(1);
          }),
    );
  }

  Widget _buildImageColumn(dynamic item) => GestureDetector(
        // Даний віджет дозволяє відслідковувати нажиманя на наше фото, щоби відкрити його
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MaxSizePhoto(pictureItem: item))),

        child: Container(
          // В даному контейнері ми отримуємо small зображення та виводимо його
          color: Colors.black87,
          child: Column(
            children: [
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: item['urls']['small'],
              ),
              Container(padding: EdgeInsets.all(10), child: _buildTittle(item))
            ],
          ),
        ),
      );

  Widget _buildTittle(dynamic item) {
    // Отримання опису фотографії, нік автора та виведення їх
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(
        item['description'] == null ? "No Description" : item['description'],
        style: TextStyle(color: Colors.white),
      ),
      SizedBox(
        height: 10,
      ),
      AutoSizeText(
        "Author: " + item['user']['username'].toString(),
        style: TextStyle(color: Colors.white),
        maxLines: 1,
      ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    // Викликаємо getJSONData() method коли додаток ініціалізується
    this.getJSONData();
  }
}
