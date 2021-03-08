import 'package:flutter/material.dart';
import 'package:gallery/main.dart';
import 'package:transparent_image/transparent_image.dart';

class MaxSizePhoto extends StatefulWidget {
  const MaxSizePhoto({Key key, this.pictureItem}) : super(key: key);
  final pictureItem;

  @override
  _MaxSizePhotoState createState() => _MaxSizePhotoState();
}

class _MaxSizePhotoState extends State<MaxSizePhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        titleSpacing: -10.0, // Положення слова Back у кнопці
        title: Text(
          "Back",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
        ),
        elevation: 2,
        leading: new IconButton(
          // Копка яка повертає користувача на головний екран
          icon: new Icon(
            Icons.arrow_back_ios_outlined,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
        ),
      ),
      body: Center(
        child: Container(
          child: FadeInImage.memoryNetwork(
            // Отримання посилання з json об'єкту та виведення на екран
            placeholder: kTransparentImage,
            image: widget.pictureItem['urls']['regular'],
          ),
        ),
      ),
    );
  }
}
