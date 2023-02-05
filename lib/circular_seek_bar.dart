library circular_seek_bar;

import 'dart:math';

import 'package:flutter/material.dart';

class CircularSeekBar extends StatefulWidget {
  /// CircularSeekBar width.
  final double width;

  /// CircularSeekBar height.
  final double height;

  /// Current value of seek bar.
  final double progress;

  /// Minimum value of seek bar.
  final double minProgress;

  /// Maximum value of seek bar.
  final double maxProgress;

  /// [startAngle] should be between 0 and 360.
  /// The Angle to start drawing this seek bar from
  final double startAngle;

  /// [sweepAngle] should be be between 0 and 360.
  /// The Angle through which to draw the seek bar
  final double sweepAngle;

  /// The thickness of the seek bar.
  final double barWidth;

  /// Background track color of seek bar.
  final Color trackColor;

  /// If [trackGradientColors] is not empty, [trackColor] is not applied.
  /// Background track gradient colors of seek bar.
  final List<Color> trackGradientColors;

  /// Foreground progress color of seek bar.
  final Color progressColor;

  /// If [progressGradientColors] is not empty, [progressColor] is not applied.
  /// Foreground progressGradientColors of seek bar.
  final List<Color> progressGradientColors;

  /// Styles to use for arcs endings.
  final StrokeCap strokeCap;

  /// Active seek bar animation.
  final bool animation;

  /// Animation duration milliseconds.
  final int animDurationMillis;

  /// Default is [Curves.linear]
  /// Animation curve.
  final Curve curves;

  /// The radius of the seekbar inner thumb.
  final double innerThumbRadius;

  /// The stroke width of the seekbar inner thumb.
  final double innerThumbStrokeWidth;

  /// Color of the seekbar inner thumb.
  final Color innerThumbColor;

  /// The radius of the seekbar outer thumb.
  final double outerThumbRadius;

  /// The stroke width of the seekbar outer thumb.
  final double outerThumbStrokeWidth;

  /// Color of the seekbar outer thumb.
  final Color outerThumbColor;

  /// If you want to make dashed progress, set [dashWidth] and [dashGap] to greater than 0
  /// Dash width of seek bar
  final double dashWidth;

  /// If you want to make dashed progress, set [dashWidth] and [dashGap] to greater than 0
  /// Dash gap of seek bar.
  final double dashGap;

  /// This ValueNotifier notifies the listener that the seekbar's progress value has changed.
  final ValueNotifier<double>? valueNotifier;

  /// This callback function will execute when Animation is finished.
  final VoidCallback? onEnd;

  /// Set to true if you want to interact with TapDown to change the seekbar's progress.
  final bool interactive;

  /// This widget is placed on the seek bar.
  final Widget? child;

  /// Constructor of CircularSeekBar.
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
    this.innerThumbRadius = 0,
    this.innerThumbStrokeWidth = 0,
    this.innerThumbColor = Colors.white,
    this.outerThumbRadius = 0,
    this.outerThumbStrokeWidth = 0,
    this.outerThumbColor = Colors.blueAccent,
    this.dashGap = 0,
    this.dashWidth = 0,
    this.valueNotifier,
    this.onEnd,
    this.interactive = true,
    this.child,
  }) : super(key: key);

  @override
  State<CircularSeekBar> createState() => _CircularSeekBarState();
}

class _CircularSeekBarState extends State<CircularSeekBar> {
  double? _progress;
  final GlobalKey _key = GlobalKey();

  /// Initialize CircularSeekBar's progress.
  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  /// Reset CircularSeekBar's progress.
  @override
  void didUpdateWidget(CircularSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progress = widget.progress;
    }
  }

  /// Get size of CircularSeekBar with RenderBox.
  Size _getSize(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    return size;
  }

  /// Converts the x and y coordinate values received by the onTapDown callback to progress.
  void _handleGesture(details) {
    double dx = details.localPosition.dx;
    double dy = details.localPosition.dy;
    Size size = _getSize(_key);
    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;
    double angle = _getTouchedDegrees(centerX, dx, centerY, dy);
    double progress = (widget.dashWidth > 0 && widget.dashGap > 0)
        ? _angleToDashedProgress(
            angle > 0 ? angle : angle + 360,
            widget.startAngle,
            widget.sweepAngle,
            widget.dashWidth,
            widget.dashGap)
        : _angleToProgress(angle > 0 ? angle : angle + 360, widget.startAngle,
            widget.sweepAngle);
    if (progress >= widget.minProgress && progress <= widget.maxProgress) {
      setState(() {
        _progress = progress;
      });
    }
  }

  /// Method to get relative angle of CircularSeekBar.
  double _getRelativeAngle(double angle, double startAngle) {
    return (angle - startAngle) >= 0
        ? (angle - startAngle)
        : (360 - startAngle + angle);
  }

  /// Convert (x, y) coordinates to an angle.
  double _getTouchedDegrees(
      double centerX, double dx, double centerY, double dy) {
    return _radiansToDegrees(atan2(centerX - dx, dy - centerY));
  }

  /// Convert angle to progress.
  double _angleToProgress(double angle, double startAngle, double sweepAngle) {
    double relativeAngle = _getRelativeAngle(angle, startAngle);
    return (relativeAngle / sweepAngle) * 100;
  }

  /// Convert the angle of dashed seekbar to progress
  double _angleToDashedProgress(double angle, double startAngle,
      double sweepAngle, double dashWidth, double dashGap) {
    double relativeAngle = (angle - startAngle) >= 0
        ? (angle - startAngle)
        : (360 - startAngle + angle);
    double dashSum = dashWidth + dashGap;

    int trackDashCounts =
        sweepAngle >= (sweepAngle ~/ dashSum) * dashSum + dashWidth
            ? (sweepAngle ~/ dashSum) + 1
            : (sweepAngle ~/ dashSum);
    double totalTrackDashWidth = dashWidth * trackDashCounts;

    for (int i = 0; i <= trackDashCounts; i++) {
      double relativeDashStartAngle = dashSum * i;
      double relativeDashEndAngle = (relativeDashStartAngle + dashWidth) % 360;

      if (relativeAngle >= relativeDashStartAngle &&
          relativeAngle <= relativeDashEndAngle) {
        double totalFilledDashRatio =
            (dashWidth * i) / totalTrackDashWidth.toDouble();
        double totalHalfWidthDashRatio =
            ((relativeAngle - dashSum * i) / dashWidth.toDouble()) /
                trackDashCounts;

        return _lerp(widget.minProgress, widget.maxProgress,
            totalFilledDashRatio + totalHalfWidthDashRatio);
      }
    }
    return -1;
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
            tween: Tween(begin: widget.minProgress, end: _progress!),
            curve: widget.curves,
            onEnd: widget.onEnd,
            builder: (BuildContext context, double progress, __) {
              widget.valueNotifier?.value = progress;
              return CustomPaint(
                size: Size(widget.width, widget.height),
                painter: _SeekBarPainter(
                  progress: progress,
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
                  innerThumbRadius: widget.innerThumbRadius,
                  innerThumbStrokeWidth: widget.innerThumbStrokeWidth,
                  innerThumbColor: widget.innerThumbColor,
                  outerThumbRadius: widget.outerThumbRadius,
                  outerThumbStrokeWidth: widget.outerThumbStrokeWidth,
                  outerThumbColor: widget.outerThumbColor,
                  dashWidth: widget.dashWidth,
                  dashGap: widget.dashGap,
                ),
                child: SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: widget.child,
                ),
              );
            }),
      );
    } else {
      widget.valueNotifier?.value = _progress!;
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
        child: CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _SeekBarPainter(
            progress: _progress!,
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
            innerThumbRadius: widget.innerThumbRadius,
            innerThumbStrokeWidth: widget.innerThumbStrokeWidth,
            innerThumbColor: widget.innerThumbColor,
            outerThumbRadius: widget.outerThumbRadius,
            outerThumbStrokeWidth: widget.outerThumbStrokeWidth,
            outerThumbColor: widget.outerThumbColor,
            dashWidth: widget.dashWidth,
            dashGap: widget.dashGap,
          ),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: widget.child,
          ),
        ),
      );
    }
  }
}

class _SeekBarPainter extends CustomPainter {
  /// Current value of seek bar.
  final double progress;

  /// Minimum value of seek bar.
  final double minProgress;

  /// Maximum value of seek bar.
  final double maxProgress;

  /// The Angle to start drawing this seek bar from
  final double startAngle;

  /// The Angle through which to draw the seek bar
  final double sweepAngle;

  /// The thickness of the seek bar.
  final double barWidth;

  /// Background track color of seek bar.
  final Color trackColor;

  /// Background track gradient colors of seek bar.
  final List<Color> trackGradientColors;

  /// Foreground progress color of seek bar.
  final Color progressColor;

  /// Foreground trackGradientColors of seek bar.
  final List<Color> progressGradientColors;

  /// Styles to use for arcs endings.
  final StrokeCap strokeCap;

  /// The radius of the seekbar inner thumb.
  final double innerThumbRadius;

  /// The stroke width of the seekbar inner thumb.
  final double innerThumbStrokeWidth;

  /// Color of the seekbar inner thumb.
  final Color innerThumbColor;

  /// The radius of the seekbar outer thumb.
  final double outerThumbRadius;

  /// The stroke width of the seekbar outer thumb.
  final double outerThumbStrokeWidth;

  /// Color of the seekbar outer thumb.
  final Color outerThumbColor;

  /// Dash width of seek bar
  final double dashWidth;

  /// Dash gap of seek bar.
  final double dashGap;

  /// The initial rotational offset 90
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
    if (sweepAngle > 0.0) {
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
      final double largerThumbWidth =
          (outerThumbRadius / 2 + outerThumbStrokeWidth / 2) >=
                  (innerThumbRadius / 2 + innerThumbStrokeWidth / 2)
              ? (outerThumbRadius / 2 + outerThumbStrokeWidth / 2)
              : (innerThumbRadius / 2 + innerThumbStrokeWidth / 2);
      final double seekBarMargin =
          largerThumbWidth >= (barWidth / 2) ? largerThumbWidth : barWidth / 2;
      final double radius = min(center.dx, center.dy) - seekBarMargin;
      double realStartAngle = startAngle + angleOffset;

      double startAngleWithOffsetRadian = _degreesToRadians(realStartAngle);
      Rect rect = Rect.fromCenter(
          center: center, width: 2 * radius, height: 2 * radius);

      double sweepAngleRadian = _degreesToRadians(sweepAngle);

      // Set gradients
      if (trackGradientColors.isNotEmpty) {
        Gradient trackGradient = SweepGradient(
          center: Alignment.center,
          startAngle: 0,
          endAngle: sweepAngleRadian,
          tileMode: TileMode.mirror,
          colors: trackGradientColors,
          transform: GradientRotation(
              startAngleWithOffsetRadian - asin((barWidth / 2) / radius)),
        );
        trackPaint.shader = trackGradient.createShader(rect);
      }

      if (progressGradientColors.isNotEmpty) {
        Gradient progressGradient = SweepGradient(
          center: Alignment.center,
          startAngle: 0,
          endAngle: sweepAngleRadian,
          tileMode: TileMode.mirror,
          colors: progressGradientColors,
          transform: GradientRotation(
              startAngleWithOffsetRadian - asin((barWidth / 2) / radius)),
        );

        progressPaint.shader = progressGradient.createShader(rect);
      }

      if (dashWidth > 0 && dashGap > 0) {
        double dashSum = dashWidth + dashGap;
        double dashWidthRadian = _degreesToRadians(dashWidth);
        double dashSumRadian = _degreesToRadians(dashSum);

        int trackDashCounts =
            sweepAngle >= (sweepAngle ~/ dashSum) * dashSum + dashWidth
                ? (sweepAngle ~/ dashSum) + 1
                : (sweepAngle ~/ dashSum);
        int progressDashCounts =
            (trackDashCounts * _lerpRatio(minProgress, maxProgress, progress))
                .floor();
        double fullProgressRatio =
            (progressDashCounts / trackDashCounts.toDouble());

        // Draw track dashes.
        for (int i = 0; i < trackDashCounts; i++) {
          canvas.drawArc(
            rect,
            startAngleWithOffsetRadian + dashSumRadian * i,
            dashWidthRadian,
            false,
            trackPaint,
          );
        }

        // Draw progress dashes.
        for (int i = 0; i < progressDashCounts; i++) {
          canvas.drawArc(
            rect,
            startAngleWithOffsetRadian + dashSumRadian * i,
            dashWidthRadian,
            false,
            progressPaint,
          );
        }

        canvas.drawArc(
          rect,
          startAngleWithOffsetRadian + dashSumRadian * (progressDashCounts),
          dashWidthRadian *
              (_lerpRatio(minProgress, maxProgress, progress) -
                  fullProgressRatio) *
              trackDashCounts,
          false,
          progressPaint,
        );

        double totalTrackDashWidth = dashWidth * trackDashCounts;
        double totalRatio = _lerpRatio(minProgress, maxProgress, progress);
        double totalFilledAngleRatio =
            (dashWidth * progressDashCounts) / totalTrackDashWidth.toDouble();
        double totalHalfWidthAngleRatio = totalRatio - totalFilledAngleRatio;
        double halfWidthAngleRatio = totalHalfWidthAngleRatio * trackDashCounts;

        double halfWidthProgressAngle =
            _lerp(0, dashWidth, halfWidthAngleRatio);
        double filledProgressAngle = trackDashCounts >= progressDashCounts + 1
            ? dashSum * progressDashCounts
            : dashSum * (progressDashCounts - 1) + dashWidth;
        double progressAngle = filledProgressAngle + halfWidthProgressAngle;

        double thumbX = center.dx -
            sin(_degreesToRadians(startAngle + progressAngle)) * radius;
        double thumbY = center.dy +
            cos(_degreesToRadians(startAngle + progressAngle)) * radius;
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
        double progressAngle = _lerp(
            0, sweepAngle, _lerpRatio(minProgress, maxProgress, progress));
        double progressAngleRadian = _degreesToRadians(progressAngle);

        canvas.drawArc(rect, startAngleWithOffsetRadian, sweepAngleRadian,
            false, trackPaint);
        canvas.drawArc(rect, startAngleWithOffsetRadian, progressAngleRadian,
            false, progressPaint);

        double thumbX = center.dx -
            sin(_degreesToRadians(startAngle + progressAngle)) * radius;
        double thumbY = center.dy +
            cos(_degreesToRadians(startAngle + progressAngle)) * radius;

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

/// Computes the linear interpolation between from and to. calculate a + t(b - a).
double _lerp(double from, double to, double ratio) {
  return from + (to - from) * ratio;
}

/// Calculate linear interpolator percentage.
double _lerpRatio(double from, double to, double progress) {
  return progress / (from + to);
}

/// Convert degrees to radians
double _degreesToRadians(double angle) => angle * pi / 180.0;

/// Convert radians to degrees
double _radiansToDegrees(double radians) => radians * 180 / pi;
