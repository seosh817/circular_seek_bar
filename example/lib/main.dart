import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter circular_seek_bar example',
      theme: ThemeData(
        primaryColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const CircularSeekBarExamplePage(),
    );
  }
}

class CircularSeekBarExamplePage extends StatefulWidget {
  const CircularSeekBarExamplePage({Key? key}) : super(key: key);

  @override
  State<CircularSeekBarExamplePage> createState() => _CircularSeekBarExamplePageState();
}

class _CircularSeekBarExamplePageState extends State<CircularSeekBarExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter circular_seek_bar example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            CircularSeekBar(
              width: double.infinity,
              progress: 40,
              height: 300,
              startAngle: 90,
              sweepAngle: 180,
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
