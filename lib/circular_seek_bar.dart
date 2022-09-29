library circular_seek_bar;

import 'dart:math';

import 'package:flutter/material.dart';

class CircularSeekBar extends StatefulWidget {
  final double width;
  final double height;
  final double progress;
  final double minProgress;
  final double maxProgress;
  final double startAngle;
  final double sweepAngle;
  final double barWidth;
  final Color trackColor;
  final Color progressColor;
  final StrokeCap strokeCap;
  final bool animation;
  final int animDurationMillis;
  final Curve curves;
  final VoidCallback? onEnd;
  final bool interactive;

  const CircularSeekBar(
      {Key? key,
        required this.width,
        required this.height,
        this.progress = 0,
        this.minProgress = 0,
        this.maxProgress = 100,
        this.startAngle = 0,
        this.sweepAngle = 360,
        this.barWidth = 10,
        this.trackColor = Colors.white54,
        this.progressColor = Colors.blue,
        this.strokeCap = StrokeCap.round,
        this.animation = true,
        this.animDurationMillis = 1000,
        this.curves = Curves.linear,
        this.onEnd,
        this.interactive = true})
      : super(key: key);

  @override
  State<CircularSeekBar> createState() => _CircularSeekBarState();
}

class _CircularSeekBarState extends State<CircularSeekBar> {
  double? _progress;
  final GlobalKey _key = GlobalKey();

  Size _getSize(GlobalKey key) {
    final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    return size;
  }

  void _handleGesture(details) {
    double dx = details.localPosition.dx;
    double dy = details.localPosition.dy;
    Size size = _getSize(_key);
    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;
    double angle = _getTouchDegrees(centerX, dx, centerY, dy);
    double progress = _angleToProgress(angle > 0 ? angle : angle + 360, widget.startAngle, widget.sweepAngle);
    if (progress >= widget.minProgress && progress <= widget.maxProgress) {
      setState(() {
        _progress = _angleToProgress(angle > 0 ? angle : angle + 360, widget.startAngle, widget.sweepAngle);
        // print('_progress: $_progress');
      });
    }
  }

  double _getTouchDegrees(double centerX, double dx, double centerY, double dy) {
    return _radiansToDegrees(atan2(centerX - dx, dy - centerY));
  }

  double _angleToProgress(double angle, double startAngle, double sweepAngle) {
    double relativeAngle = (angle - startAngle) >= 0 ? (angle - startAngle) : (startAngle + sweepAngle + angle);
    return (relativeAngle / sweepAngle) * 100;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animation) {
      return GestureDetector(
        key: _key,
        onTapDown: (details) {
          if (widget.interactive) {
            _handleGesture(details);
          }
        },
        onPanUpdate: (details) {
          if (widget.interactive) {
            _handleGesture(details);
          }
        },
        child: TweenAnimationBuilder(
            duration: Duration(milliseconds: widget.animDurationMillis),
            tween: Tween(begin: widget.minProgress, end: widget.progress),
            curve: widget.curves,
            onEnd: widget.onEnd,
            builder: (BuildContext context, double progress, __) {
              return CustomPaint(
                size: Size(widget.width, widget.height),
                painter: _SeekBarPainter(
                  progress: _progress ?? progress,
                  minProgress: widget.minProgress,
                  maxProgress: widget.maxProgress,
                  startAngle: widget.startAngle,
                  sweepAngle: widget.sweepAngle,
                  barWidth: widget.barWidth,
                  trackColor: widget.trackColor,
                  progressColor: widget.progressColor,
                  strokeCap: widget.strokeCap,
                  interactive: widget.interactive,
                ),
              );
            }),
      );
    } else {
      return CustomPaint(
        size: Size(widget.width, widget.height),
        painter: _SeekBarPainter(
          progress: widget.progress,
          minProgress: widget.minProgress,
          maxProgress: widget.maxProgress,
          startAngle: widget.startAngle,
          sweepAngle: widget.sweepAngle,
          barWidth: widget.barWidth,
          trackColor: widget.trackColor,
          progressColor: widget.progressColor,
          strokeCap: widget.strokeCap,
          interactive: widget.interactive,
        ),
      );
    }
  }
}

class _SeekBarPainter extends CustomPainter {
  final double progress;
  final double minProgress;
  final double maxProgress;
  final double startAngle;
  final double sweepAngle;
  final double barWidth;
  final Color trackColor;
  final Color progressColor;
  final StrokeCap strokeCap;
  final bool interactive;

  // The initial rotational offset 90
  static const double angleOffset = 90;

  _SeekBarPainter({
    required this.progress,
    required this.minProgress,
    required this.maxProgress,
    required this.startAngle,
    required this.sweepAngle,
    required this.barWidth,
    required this.trackColor,
    required this.progressColor,
    required this.strokeCap,
    required this.interactive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = trackColor
      ..strokeCap = strokeCap
      ..strokeWidth = barWidth;

    Paint progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = progressColor
      ..strokeCap = strokeCap
      ..strokeWidth = barWidth;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = min(center.dx, center.dy) - barWidth;
    double realStartAngle = startAngle + angleOffset;

    double startAngleRadian = _degreesToRadians(realStartAngle);
    Rect rect = Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius);

    double sweepAngleRadian = _degreesToRadians(sweepAngle);
    canvas.drawArc(rect, startAngleRadian, sweepAngleRadian, false, trackPaint);

    double progressAngle = _lerp(0, sweepAngle, _lerpRatio(minProgress, maxProgress, progress));
    double progressAngleRadian = _degreesToRadians(progressAngle);

    canvas.drawArc(rect, startAngleRadian, progressAngleRadian, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _SeekBarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.minProgress != minProgress ||
        oldDelegate.maxProgress != maxProgress ||
        oldDelegate.startAngle != startAngle ||
        oldDelegate.sweepAngle != sweepAngle ||
        oldDelegate.barWidth != barWidth ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeCap != strokeCap ||
        oldDelegate.interactive != interactive;
  }

  double _lerp(double from, double to, double ratio) {
    return from + (to - from) * ratio;
  }

  double _lerpRatio(double from, double to, double progress) {
    return progress / (from + to);
  }
}

double _degreesToRadians(double angle) => angle * pi / 180.0;

double _radiansToDegrees(double radians) => radians * 180 / pi;
