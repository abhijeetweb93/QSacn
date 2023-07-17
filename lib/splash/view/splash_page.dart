import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qscan/home/view/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: const Center(
        child: SizedBox(
          height: 150,
          width: 200,
          //child: Image.asset('assets/images/couple.jpg'),
          child: CircleAvatar(
            radius: 100, // Image radius
            backgroundImage: AssetImage('assets/images/scan.png'),
          ),
        ),
      ),
    );
  }
}
