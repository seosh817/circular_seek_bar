import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:example/util/text_style.dart';
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
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  double _progress = 50;
  double _startAngle = 90;
  double _sweepAngle = 180;
  double _dashWidth = 0;
  double _dashGap = 0;
  double _barWidth = 5;
  bool _useGradient = true;
  bool _rounded = true;
  bool _animation = true;
  bool _thumbVisible = true;

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter circular_seek_bar example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircularSeekBar(
              width: double.infinity,
              progress: _progress,
              height: 250,
              barWidth: _barWidth,
              startAngle: _startAngle,
              sweepAngle: _sweepAngle,
              strokeCap: _rounded ? StrokeCap.round : StrokeCap.butt,
              progressGradientColors: _useGradient ? [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.indigo, Colors.purple] : [],
              dashWidth: _dashWidth,
              dashGap: _dashGap,
              animation: _animation,
              curves: Curves.bounceOut,
              innerThumbRadius: _thumbVisible ? 5 : 0,
              innerThumbStrokeWidth: _thumbVisible ? 3 : 0,
              outerThumbRadius: _thumbVisible ? 5 : 0,
              outerThumbStrokeWidth: _thumbVisible ? 10 : 0,
              valueNotifier: _valueNotifier,
              child: Center(
                child: ValueListenableBuilder(
                    valueListenable: _valueNotifier,
                    builder: (_, double value, __) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${value.round()}',
                            style: kNotoSansBold16.copyWith(color: Colors.white)
                        ),
                        Text(
                          'progress',
                          style: kNotoSansRegular14.copyWith(color: Colors.grey)
                        ),
                      ],
                    )
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'progress: ',
                            style: kNotoSansBold14.copyWith(color: Colors.white),
                          ),
                          Slider(
                            min: 0.0,
                            max: 100.0,
                            value: _progress,
                            onChanged: (value) {
                              setState(() {
                                _progress = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'startAngle: ',
                            style: kNotoSansBold14.copyWith(color: Colors.white),
                          ),
                          Slider(
                            min: 0.0,
                            max: 360.0,
                            value: _startAngle,
                            onChanged: (value) {
                              setState(() {
                                _startAngle = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'sweepAngle: ',
                            style: kNotoSansBold14.copyWith(color: Colors.white),
                          ),
                          Slider(
                            min: 0.0,
                            max: 360.0,
                            value: _sweepAngle,
                            onChanged: (value) {
                              setState(() {
                                _sweepAngle = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'dashWidth: ',
                            style: kNotoSansBold14.copyWith(color: Colors.white),
                          ),
                          Slider(
                            min: 0.0,
                            max: 50.0,
                            value: _dashWidth,
                            onChanged: (value) {
                              setState(() {
                                _dashWidth = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'dashGap: ',
                            style: kNotoSansBold14.copyWith(color: Colors.white),
                          ),
                          Slider(
                            min: 0.0,
                            max: 20.0,
                            value: _dashGap,
                            onChanged: (value) {
                              setState(() {
                                _dashGap = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'barWidth: ',
                            style: kNotoSansBold14.copyWith(color: Colors.white),
                          ),
                          Slider(
                            min: 1.0,
                            max: 10,
                            value: _barWidth,
                            onChanged: (value) {
                              setState(() {
                                _barWidth = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'useGradient: ',
                            style: kNotoSansBold14.copyWith(color: Colors.white),
                          ),
                          Switch(
                              value: _useGradient,
                              onChanged: (value) {
                                setState(() {
                                  _useGradient = value;
                                });
                              }),
                          Text(
                            'rounded: ',
                            style: kNotoSansBold14.copyWith(color: Colors.white),
                          ),
                          Switch(
                              value: _rounded,
                              onChanged: (value) {
                                setState(() {
                                  _rounded = value;
                                });
                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'animation: ',
                            style: kNotoSansBold14.copyWith(color: Colors.white),
                          ),
                          Switch(
                              value: _animation,
                              onChanged: (value) {
                                setState(() {
                                  _animation = value;
                                });
                              }),
                          Text(
                            'thumbVisible: ',
                            style: kNotoSansBold14.copyWith(color: Colors.white),
                          ),
                          Switch(
                              value: _thumbVisible,
                              onChanged: (value) {
                                setState(() {
                                  _thumbVisible = value;
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
