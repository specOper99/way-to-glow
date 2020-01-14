// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  shadow,
}

final _lightTheme = {
  _Element.background: Colors.white60,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.shadow: Colors.white,
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  List<Color> colorSet = [
    Colors.purpleAccent,
    Colors.indigoAccent,
    Colors.redAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.pink,
    Colors.deepOrangeAccent,
    Colors.cyan,
    Colors.lime,
    Colors.teal,
    Colors.lightBlueAccent,
    Colors.amber,
    Colors.blue,
  ];

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      // _timer = Timer(
      //   Duration(minutes: 1) -
      //       Duration(seconds: _dateTime.second) -
      //       Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 3.5;
    final offset = -fontSize / 7;
    final defaultStyle = TextStyle(
      // fontFamily: 'PressStart2P',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 2.5,
          color: colors[_Element.shadow],
          offset: Offset(4, 1),
        ),
      ],
    );

    return Container(
      color: colors[_Element.background],
      child: Center(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 2.5),
                      child: Text(
                        hour[0],
                        style: TextStyle(color: colorSet[int.parse(hour[0])]),
                      )),
                  AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 4),
                      child: Text(
                        hour[1],
                        style: TextStyle(color: colorSet[int.parse(hour[1])]),
                      )),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 8,
                    bottom: MediaQuery.of(context).size.height / 6),
                width: 10,
                child: DateTime.now().second % 2 == 0
                    ? Text(
                        ":",
                        style: TextStyle(
                          color: colorSet[Random().nextInt(12)],
                        ),
                      )
                    : Text(""),
                transform: Matrix4.rotationZ(0.5),
              ),
              Row(
                children: <Widget>[
                  AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 3),
                      child: Text(
                        minute[0],
                        style: TextStyle(color: colorSet[int.parse(minute[0])]),
                      )),
                  AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      transform: Matrix4.diagonal3Values(1, 1, 1),
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 2.4),
                      child: Text(
                        minute[1],
                        style: TextStyle(color: colorSet[int.parse(minute[1])]),
                      )),
                ],
              ),
              // Positioned(left: offset, top: 0, child: Text(hour)),
              // Positioned(right: offset, bottom: offset, child: Text(minute)),
            ],
          ),
        ),
      ),
    );
  }
}
