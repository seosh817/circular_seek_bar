
<h1 align="center">Circular Seek Bar</h1>

<p align="center">
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter"
      alt="Platform" />
  </a>
  <a href="https://pub.dartlang.org/packages/circular_seek_bar">
    <img src="https://img.shields.io/pub/v/circular_seek_bar.svg"
      alt="Pub Package" />
  </a>
  <a href="https://github.com/seosh817/Flutter_CircularSeekBar/actions/workflows/main.yml">
    <img src="https://img.shields.io/github/workflow/status/seosh817/Flutter_CircularSeekBar/main_workflow/release/1.0.0?logo=github"
      alt="Build Status" />
  </a>

  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/github/license/seosh817/Flutter_CircularSeekBar"
      alt="License: MIT" />
  </a>
</p><br>

<p align="center">Circular seek bar package for flutter that supports customizable animations, dashes, and gradients.</p>

# Getting Started
- [Youtube Demo Video](#youtube-demo-video)
- [Basic Examples](#basic-examples)
  - [Basic SeekBar](#1-basic-seekbar)
  - [Gradient SeekBar](#2-gradient-seekbar)
  - [Dashed SeekBar](#3-dashed-seekbar)
  - [Add ValueNotifier](#4-add-valuenotifier)
- [Installing](#installing)
  - [Depend on it](#1-depend-on-it)
  - [Install it](#2-install-it)
  - [Import it](#3-import-it)
- [Properties](#properties)
- [License](#license)
- [Contribution](#contribution)

# Youtube Demo Video
An example project can be found in the [example directory](https://github.com/seosh817/Flutter_CircularSeekBar/tree/master/example) of this repository.

[![Demo Video](https://img.youtube.com/vi/rQ_-iKXHR-M/hqdefault.jpg)](https://youtu.be/rQ_-iKXHR-M)

# Basic Examples

### 1. Basic SeekBar

<img src="https://github.com/seosh817/Flutter_CircularSeekBar/blob/release/1.0.0/images/start_90_sweep_360.gif?raw=true" width="300"/>

### Dart code:

If you want to use thumb, set the thumb property values.

```dart
CircularSeekBar(
  width: double.infinity,
  height: 250,
  progress: _progress,
  barWidth: 8,
  startAngle: 90,
  sweepAngle: 360,
  strokeCap: StrokeCap.butt,
  progressColor: Colors.blue,
  innerThumbRadius: 5,
  innerThumbStrokeWidth: 3,
  innerThumbColor: Colors.white,
  outerThumbRadius: 5,
  outerThumbStrokeWidth: 10,
  outerThumbColor: Colors.blueAccent,
  animation: true,
)
```
### 2. Gradient SeekBar

<img src="https://github.com/seosh817/Flutter_CircularSeekBar/blob/release/1.0.0/images/start_45_sweep_270_gradient_rainbow.gif?raw=true" width="300"/>

```dart
CircularSeekBar(
  width: double.infinity,
  height: 250,
  progress: _progress,
  barWidth: 8,
  startAngle: 45,v
  sweepAngle: 270,
  strokeCap: StrokeCap.round,
  progressGradientColors: const [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.indigo, Colors.purple],
  innerThumbRadius: 5,
  innerThumbStrokeWidth: 3,
  innerThumbColor: Colors.white,
  outerThumbRadius: 5,
  outerThumbStrokeWidth: 10,
  outerThumbColor: Colors.blueAccent,
  animation: true,
)
```
### 3. Dashed SeekBar

<img src="https://github.com/seosh817/Flutter_CircularSeekBar/blob/release/1.0.0/images/start_90_sweep_180_dashWidth_50_dashGap_15.gif?raw=true" width="300"/>


### Dart code:
```dart
CircularSeekBar(
  width: double.infinity,
  height: 250,
  progress: _progress,
  barWidth: 8,
  startAngle: 90,
  sweepAngle: 180,
  strokeCap: StrokeCap.round,
  progressGradientColors: const [Colors.blue, Colors.indigo, Colors.purple],
  dashWidth: 50,
  dashGap: 15,
  animation: true,
)
```

<img src="https://github.com/seosh817/Flutter_CircularSeekBar/blob/release/1.0.0/images/start_45_sweep_270_dashWidth_80_dashGap_15.gif?raw=true" width="300"/>

### Dart code:
```dart
CircularSeekBar(
  width: double.infinity,
  height: 250,
  progress: _progress,
  barWidth: 8,
  startAngle: 45,
  sweepAngle: 270,
  strokeCap: StrokeCap.round,
  progressGradientColors: const [Colors.blue, Colors.indigo, Colors.purple],
  dashWidth: 80,
  dashGap: 15,
  animation: true,
)
```


<img src="https://github.com/seosh817/Flutter_CircularSeekBar/blob/release/1.0.0/images/start_45_sweep_270_dashWidth_1_dashGap_2.gif?raw=true" width="300"/>

### Dart code:
```dart
CircularSeekBar(
  width: double.infinity,
  height: 250,
  progress: _progress,
  barWidth: 8,
  startAngle: 45,
  sweepAngle: 270,
  strokeCap: StrokeCap.butt,
  progressGradientColors: const [Colors.blue, Colors.indigo, Colors.purple],
  dashWidth: 1,
  dashGap: 2,
  animation: true,
)
```

### 4. Add ValueNotifier

<img src="https://github.com/seosh817/Flutter_CircularSeekBar/blob/release/1.0.0/images/start_45_sweep_270_dashWith_1_dashGap_2_gradient_rainbow.gif?raw=true" width="300"/>

### Dart code:
```dart
final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
```
If you want to listen to the value of progress, create a valueNotifier and add it to the constructor.
```dart
CircularSeekBar(
  width: double.infinity,
  height: 250,
  progress: _progress,
  barWidth: 8,
  startAngle: 45,
  sweepAngle: 270,
  strokeCap: StrokeCap.butt,
  progressGradientColors: const [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.indigo, Colors.purple],
  innerThumbRadius: 5,
  innerThumbStrokeWidth: 3,
  innerThumbColor: Colors.white,
  outerThumbRadius: 5,
  outerThumbStrokeWidth: 10,
  outerThumbColor: Colors.blueAccent,
  dashWidth: 1,
  dashGap: 2,
  animation: true,
  valueNotifier: _valueNotifier,
  child: Center(
    child: ValueListenableBuilder(
        valueListenable: _valueNotifier,
        builder: (_, double value, __) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${value.round()}', style: kNotoSansBold16.copyWith(color: Colors.white)),
                Text('progress', style: kNotoSansRegular14.copyWith(color: Colors.grey)),
              ],
            )),
  ),
)
```

# Installing

### 1. Depend on it

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  circular_seek_bar: ^1.0.1
```

or

```
$ flutter pub add circular_seek_bar
```

### 2. Install it

You can install packages from the command line:

```
$ flutter pub get
```

### 3. Import it

Now in your `Dart` code, you can use:

```dart
import 'package:circular_seek_bar/circular_seek_bar.dart';
```

## Properties

You can customize the CircularSeekBar using the following properties:

|Property|Type|Default|Description|
|:---|:---|:---|:---|
| width | `double` | required | CircularSeekBar width.|
| height | `double` | required | CircularSeekBar height.|
| progress | `double` | 0 | Current value of seek bar. |
| minProgress | `double` | 0 | Minimum value of seek bar.|
| maxProgress | `double` | 100 | Maximum value of seek bar.|
| startAngle | `double` | 0 | The Angle to start drawing this seek bar from.|
| sweepAngle | `double` | 360 | The Angle through which to draw the seek bar.|
| barWidth | `double` | 10 | The thickness of the seek bar.|
| trackColor | `Color` | Colors.white54 | Background track color of seek bar.|
| trackGradientColors | `List<Color>` | [] | Background track gradient colors of seek bar.<br>If [trackGradientColors] is not empty, [trackColor] is not applied.|
| progressColor | `Color` | Colors.blue | Foreground progress color of seek bar.|
| progressGradientColors | `List<Color>` | [] | Foreground progressGradientColors of seek bar.<br>If [progressGradientColors] is not empty, [progressColor] is not applied.|
| strokeCap | `StrokeCap` | StrokeCap.round | Styles to use for arcs endings.|
| animation | `bool` | true | Active seek bar animation.|
| animDurationMillis | `int` | 1000 | Animation duration milliseconds.|
| curves | `Curve` | Curves.linear | Animation curve.|
| innerThumbRadius | `double` | 0 | The radius of the seekbar inner thumb.|
| innerThumbStrokeWidth | `double` | 0 | The stroke width of the seekbar inner thumb.|
| innerThumbColor | `Color` | Colors.white | Color of the seekbar inner thumb.|
| outerThumbRadius | `double` | 0 | The radius of the seekbar outer thumb.|
| outerThumbStrokeWidth | `double` | 0 | The stroke width of the seekbar outer thumb.|
| outerThumbColor | `Color` | Colors.white | Color of the seekbar outer thumb.|
| dashWidth | `double` | 0 | Dash width of seek bar.|
| dashGap | `double` | 0 |  Dash gap of seek bar.|
| valueNotifier | `ValueNotifier<double>?` | null | This ValueNotifier notifies the listener that the seekbar's progress value has changed.|
| onEnd | `VoidCallback?` | null | This callback function will execute when Animation is finished.|
| interactive | `bool` | true | Set to true if you want to interact with TapDown to change the seekbar's progress.|
| child | `Widget?` | null | This widget is placed on the seek bar.|

# License
```
MIT License

Copyright (c) 2022 seosh817

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

# Contribution
Feel free to file an [issue](https://github.com/seosh817/Flutter_CircularSeekBar/issues) if you find a problem or make [pull requests](https://github.com/seosh817/Flutter_CircularSeekBar/pulls).<br>
All contributions are welcome 😁

