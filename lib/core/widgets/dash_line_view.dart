import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';


class DashLineView extends StatefulWidget {
  final double dashHeight;
  final double dashWith;
  final Color dashColor;
  int fillRate; // [0, 1] totalDashSpace/totalSpace
  final Axis direction;

  DashLineView(
      {this.dashHeight = 10,
        this.dashWith = 80,
        this.dashColor = AppColors.loaderProgressColor,
        this.fillRate = -1,
        this.direction = Axis.horizontal});

  @override
  State<DashLineView> createState() => _DashLineViewState();
}

class _DashLineViewState extends State<DashLineView> {
  late Timer _timer;
  int duration = 1;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: duration), (timer) {
      //code to run on every 2 minutes 5 seconds

      setState(() {
        widget.fillRate++;
        if (widget.fillRate > 4) widget.fillRate = -1;
      });


    });
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final dCount = 4;
        return Flex(
          children: List.generate(dCount, (_) {
            return SizedBox(
              width: widget.direction == Axis.horizontal
                  ? widget.dashWith
                  : widget.dashHeight,
              height: widget.direction == Axis.horizontal
                  ? widget.dashHeight
                  : widget.dashWith,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: widget.fillRate == -1
                        ? AppColors.colorgrey
                        : _ <= widget.fillRate
                        ? widget.dashColor
                        : AppColors.colorgrey),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: widget.direction,
        );
      },
    );
  }
}