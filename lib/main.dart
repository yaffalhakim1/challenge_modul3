import 'package:flutter/material.dart';
import 'package:manga/screens/home.dart';

void main() async {
  runApp(const Manga());
}

class Manga extends StatelessWidget {
  const Manga({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manga app',
      debugShowCheckedModeBanner: true,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
    );
  }
}
