import 'package:flutter/material.dart';
import 'package:predictiva/orders.dart';
import 'package:predictiva/portfolio.dart'; // Import the Portfolio component

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0D0D0F),
        textTheme: const TextTheme(
          bodyText2: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.3,
            color: Colors.white,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        height: 800,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MediaQuery.of(context).size.width < 600
                    ? SizedBox(width: 16)
                    : SizedBox(width: 110),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi Robin,",
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffFFFFFF),
                          height: 1.45, // 23.2px / 16px = 1.45
                        ),
                      ),
                      SizedBox(height: 8), // Add space between the texts
                      Wrap(
                        children: [
                          Text(
                            'Here is an overview of your account activities.',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFF4F4F5),
                              height: 1.45, // 23.2px / 16px = 1.457
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: screenWidth < 650 ? 300 : 190,
              child: Portfolio(), // Add the Portfolio component
            ),
            SizedBox(width: 16),
            Expanded(
              child: Orders(), // Add the Orders component
            ),
          ],
        ),
      )),
    );
  }
}
