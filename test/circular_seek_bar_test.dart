import 'package:flutter_test/flutter_test.dart';

import 'package:circular_seek_bar/circular_seek_bar.dart';

void main() {
  test('test circularSeekBar', () {
    const circularSeekBar = CircularSeekBar(
      width: 300,
      height: 300,
      progress: 50,
    );
    expect(circularSeekBar.progress, 50);
  });
}
