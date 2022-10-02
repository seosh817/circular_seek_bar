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
  final List<Color> trackGradientColors;
  final Color progressColor;
  final List<Color> progressGradientColors;
  final StrokeCap strokeCap;
  final bool animation;
  final int animDurationMillis;
  final Curve curves;
  final VoidCallback? onEnd;
  final bool interactive;
  final double innerThumbRadius;
  final double innerThumbStrokeWidth;
  final Color innerThumbColor;
  final double outerThumbRadius;
  final double outerThumbStrokeWidth;
  final Color outerThumbColor;
  final double dashWidth;
  final double dashGap;

  const CircularSeekBar({
    Key? key,
    required this.width,
    required this.height,
    this.progress = 0,
    this.minProgress = 0,
    this.maxProgress = 100,
    this.startAngle = 0,
    this.sweepAngle = 360,
    this.barWidth = 10,
    this.trackColor = Colors.white54,
    this.trackGradientColors = const [],
    this.progressColor = Colors.blue,
    this.progressGradientColors = const [],
    this.strokeCap = StrokeCap.round,
    this.animation = true,
    this.animDurationMillis = 1000,
    this.curves = Curves.linear,
    this.onEnd,
    this.interactive = true,
    this.innerThumbRadius = 5,
    this.innerThumbStrokeWidth = 3,
    this.innerThumbColor = Colors.white,
    this.outerThumbRadius = 5,
    this.outerThumbStrokeWidth = 10,
    this.outerThumbColor = Colors.blueAccent,
    this.dashGap = 0,
    this.dashWidth = 0,
  }) : super(key: key);

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
      });
    }
  }

  double _getTouchDegrees(double centerX, double dx, double centerY, double dy) {
    return _radiansToDegrees(atan2(centerX - dx, dy - centerY));
  }

  double _angleToProgress(double angle, double startAngle, double sweepAngle) {
    double relativeAngle = (angle - startAngle) >= 0 ? (angle - startAngle) : (startAngle - sweepAngle + angle);
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
                  trackGradientColors: widget.trackGradientColors,
                  progressColor: widget.progressColor,
                  progressGradientColors: widget.progressGradientColors,
                  strokeCap: widget.strokeCap,
                  interactive: widget.interactive,
                  innerThumbRadius: widget.innerThumbRadius,
                  innerThumbStrokeWidth: widget.innerThumbStrokeWidth,
                  innerThumbColor: widget.innerThumbColor,
                  outerThumbRadius: widget.outerThumbRadius,
                  outerThumbStrokeWidth: widget.outerThumbStrokeWidth,
                  outerThumbColor: widget.outerThumbColor,
                  dashWidth: widget.dashWidth,
                  dashGap: widget.dashGap,
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
          trackGradientColors: widget.trackGradientColors,
          progressColor: widget.progressColor,
          progressGradientColors: widget.progressGradientColors,
          strokeCap: widget.strokeCap,
          interactive: widget.interactive,
          innerThumbRadius: widget.innerThumbRadius,
          innerThumbStrokeWidth: widget.innerThumbStrokeWidth,
          innerThumbColor: widget.innerThumbColor,
          outerThumbRadius: widget.outerThumbRadius,
          outerThumbStrokeWidth: widget.outerThumbStrokeWidth,
          outerThumbColor: widget.outerThumbColor,
          dashWidth: widget.dashWidth,
          dashGap: widget.dashGap,
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
  final List<Color> trackGradientColors;
  final Color progressColor;
  final List<Color> progressGradientColors;
  final StrokeCap strokeCap;
  final bool interactive;
  final double innerThumbRadius;
  final double innerThumbStrokeWidth;
  final Color innerThumbColor;
  final double outerThumbRadius;
  final double outerThumbStrokeWidth;
  final Color outerThumbColor;
  final double dashWidth;
  final double dashGap;

  // The initial rotational offset 90
  static const double angleOffset = 90;

  _SeekBarPainter(
      {required this.progress,
      required this.minProgress,
      required this.maxProgress,
      required this.startAngle,
      required this.sweepAngle,
      required this.barWidth,
      required this.trackColor,
      required this.trackGradientColors,
      required this.progressColor,
      required this.progressGradientColors,
      required this.strokeCap,
      required this.interactive,
      required this.innerThumbRadius,
      required this.innerThumbStrokeWidth,
      required this.innerThumbColor,
      required this.outerThumbRadius,
      required this.outerThumbStrokeWidth,
      required this.outerThumbColor,
      required this.dashWidth,
      required this.dashGap});

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
    final double largerThumbWidth = barWidth >= (outerThumbRadius + (outerThumbStrokeWidth / 2)) ? barWidth : (outerThumbRadius + (outerThumbStrokeWidth / 2));
    final double radius = min(center.dx, center.dy) - largerThumbWidth;
    double realStartAngle = startAngle + angleOffset;

    double startAngleRadian = _degreesToRadians(realStartAngle);
    Rect rect = Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius);

    double sweepAngleRadian = _degreesToRadians(sweepAngle);

    Gradient? trackGradient = trackGradientColors.isNotEmpty
        ? SweepGradient(
            center: Alignment.center,
            startAngle: startAngleRadian,
            endAngle: startAngleRadian + sweepAngleRadian,
            tileMode: TileMode.mirror,
            colors: trackGradientColors,
          )
        : null;

    trackPaint.shader = trackGradient?.createShader(rect);

    Gradient? progressGradient = progressGradientColors.isNotEmpty
        ? SweepGradient(
            center: Alignment.center,
            startAngle: startAngleRadian,
            endAngle: startAngleRadian + sweepAngleRadian,
            tileMode: TileMode.mirror,
            colors: progressGradientColors,
          )
        : null;

    progressPaint.shader = progressGradient?.createShader(rect);

    if (dashWidth > 0 && dashGap > 0) {
      double dashSum = dashWidth + dashGap;
      double dashWidthRadian = _degreesToRadians(dashWidth);
      double dashSumRadian = _degreesToRadians(dashSum);

      int trackDashCounts = sweepAngle >= (sweepAngle ~/ dashSum) * dashSum + dashWidth ? (sweepAngle ~/ dashSum) + 1 : (sweepAngle ~/ dashSum);
      int progressDashCounts = (trackDashCounts * _lerpRatio(minProgress, maxProgress, progress)).floor();
      double fullProgressRatio = (progressDashCounts / trackDashCounts.toDouble());

      // Draw track dashes.
      for (int i = 0; i < trackDashCounts; i++) {
        canvas.drawArc(
          rect,
          startAngleRadian + dashSumRadian * i,
          dashWidthRadian,
          false,
          trackPaint,
        );
      }

      // Draw progress dashes.
      for (int i = 0; i < progressDashCounts; i++) {
        canvas.drawArc(
          rect,
          startAngleRadian + dashSumRadian * i,
          dashWidthRadian,
          false,
          progressPaint,
        );
      }

      canvas.drawArc(
        rect,
        startAngleRadian + dashSumRadian * (progressDashCounts),
        dashWidthRadian * (_lerpRatio(minProgress, maxProgress, progress) - fullProgressRatio) * trackDashCounts,
        false,
        progressPaint,
      );


      double totalTrackDashWidth = dashWidth * trackDashCounts;
      double totalRatio = _lerpRatio(minProgress, maxProgress, progress);
      double totalFilledAngleRatio = (dashWidth * progressDashCounts) / totalTrackDashWidth.toDouble();
      double totalNotFilledAngleRatio = totalRatio - totalFilledAngleRatio;
      double notFilledAngleRatio = totalNotFilledAngleRatio * trackDashCounts;
      double progressAngle = dashSum * progressDashCounts + _lerp(0, dashWidth, notFilledAngleRatio);

      double thumbX = center.dx - sin(_degreesToRadians(startAngle + progressAngle)) * radius;
      double thumbY = center.dy + cos(_degreesToRadians(startAngle + progressAngle)) * radius;
      Offset thumbCenter = Offset(thumbX, thumbY);

      canvas.drawCircle(
          thumbCenter,
          outerThumbRadius,
          Paint()
            ..color = outerThumbColor
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = outerThumbStrokeWidth);

      canvas.drawCircle(
          thumbCenter,
          innerThumbRadius,
          Paint()
            ..color = innerThumbColor
            ..style = PaintingStyle.fill
            ..strokeCap = StrokeCap.round
            ..strokeWidth = innerThumbStrokeWidth);
    } else {
      double progressAngle = _lerp(0, sweepAngle, _lerpRatio(minProgress, maxProgress, progress));
      double progressAngleRadian = _degreesToRadians(progressAngle);

      canvas.drawArc(rect, startAngleRadian, sweepAngleRadian, false, trackPaint);
      canvas.drawArc(rect, startAngleRadian, progressAngleRadian, false, progressPaint);

      double thumbX = center.dx - sin(_degreesToRadians(startAngle + progressAngle)) * radius;
      double thumbY = center.dy + cos(_degreesToRadians(startAngle + progressAngle)) * radius;

      Offset thumbCenter = Offset(thumbX, thumbY);

      canvas.drawCircle(
          thumbCenter,
          outerThumbRadius,
          Paint()
            ..color = outerThumbColor
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = outerThumbStrokeWidth);

      canvas.drawCircle(
          thumbCenter,
          innerThumbRadius,
          Paint()
            ..color = innerThumbColor
            ..style = PaintingStyle.fill
            ..strokeCap = StrokeCap.round
            ..strokeWidth = innerThumbStrokeWidth);
    }
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
        oldDelegate.trackGradientColors != trackGradientColors ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.progressGradientColors != progressGradientColors ||
        oldDelegate.strokeCap != strokeCap ||
        oldDelegate.interactive != interactive ||
        oldDelegate.innerThumbRadius != innerThumbRadius ||
        oldDelegate.innerThumbStrokeWidth != innerThumbStrokeWidth ||
        oldDelegate.innerThumbColor != innerThumbColor ||
        oldDelegate.outerThumbRadius != outerThumbRadius ||
        oldDelegate.outerThumbStrokeWidth != outerThumbStrokeWidth ||
        oldDelegate.outerThumbColor != outerThumbColor ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashGap != dashGap;
  }
}

double _lerp(double from, double to, double ratio) {
  return from + (to - from) * ratio;
}

double _lerpRatio(double from, double to, double progress) {
  return progress / (from + to);
}

double _degreesToRadians(double angle) => angle * pi / 180.0;

double _radiansToDegrees(double radians) => radians * 180 / pi;
