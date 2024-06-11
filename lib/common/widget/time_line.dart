import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';

const kFlexMultiplier = 1000.0;

/// Defines the visual properties of [SolidLineConnector], connectors inside
/// [TimelineNode].
///
/// Descendant widgets obtain the current [ConnectorThemeData] object using
/// `ConnectorTheme.of(context)`. Instances of [ConnectorThemeData] can be
/// customized with [ConnectorThemeData.copyWith].
///
/// Typically a [ConnectorThemeData] is specified as part of the overall
/// [TimelineTheme] with [TimelineThemeData.connectorTheme].
///
/// All [ConnectorThemeData] properties are `null` by default. When null, the
/// widgets will provide their own defaults.
///
/// See also:
///
///  * [TimelineThemeData], which describes the overall theme information for
///  the timeline.
@immutable
class ConnectorThemeData with Diagnosticable {
  /// Creates a theme that can be used for [ConnectorTheme] or
  /// [TimelineThemeData.connectorTheme].
  const ConnectorThemeData({
    this.color,
    this.space,
    this.thickness,
    this.indent,
  });

  /// The color of [SolidLineConnector]s and connectors inside [TimelineNode]s,
  /// and so forth.
  final Color? color;

  /// This represents the amount of horizontal or vertical space the connector
  /// takes up.
  final double? space;

  /// The thickness of the line drawn within the connector.
  final double? thickness;

  /// The amount of empty space at the edge of [SolidLineConnector].
  final double? indent;

  /// Creates a copy of this object with the given fields replaced with the new
  /// values.
  ConnectorThemeData copyWith({
    Color? color,
    double? space,
    double? thickness,
    double? indent,
  }) {
    return ConnectorThemeData(
      color: color ?? this.color,
      space: space ?? this.space,
      thickness: thickness ?? this.thickness,
      indent: indent ?? this.indent,
    );
  }

  /// Linearly interpolate between two Connector themes.
  ///
  /// The argument `t` must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static ConnectorThemeData lerp(
      ConnectorThemeData? a, ConnectorThemeData? b, double t) {
    return ConnectorThemeData(
      color: Color.lerp(a?.color, b?.color, t),
      space: lerpDouble(a?.space, b?.space, t),
      thickness: lerpDouble(a?.thickness, b?.thickness, t),
      indent: lerpDouble(a?.indent, b?.indent, t),
    );
  }

  @override
  int get hashCode {
    return hashValues(
      color,
      space,
      thickness,
      indent,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ConnectorThemeData &&
        other.color == color &&
        other.space == space &&
        other.thickness == thickness &&
        other.indent == indent;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(DoubleProperty('space', space, defaultValue: null))
      ..add(DoubleProperty('thickness', thickness, defaultValue: null))
      ..add(DoubleProperty('indent', indent, defaultValue: null));
  }
}

/// An inherited widget that defines the configuration for
/// [SolidLineConnector]s, connectors inside [TimelineNode]s.
class ConnectorTheme extends InheritedTheme {
  /// Creates a connector theme that controls the configurations for
  /// [SolidLineConnector]s, connectors inside [TimelineNode]s.
  const ConnectorTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The properties for descendant [SolidLineConnector]s, connectors inside
  /// [TimelineNode]s.
  final ConnectorThemeData data;

  /// The closest instance of this class's [data] value that encloses the given
  /// context.
  ///
  /// If there is no ancestor, it returns [TimelineThemeData.connectorTheme].
  /// Applications can assume that the returned value will not be null.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ConnectorThemeData theme = ConnectorTheme.of(context);
  /// ```
  static ConnectorThemeData of(BuildContext context) {
    final connectorTheme =
        context.dependOnInheritedWidgetOfExactType<ConnectorTheme>();
    return connectorTheme?.data ?? TimelineTheme.of(context).connectorTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    final ancestorTheme =
        context.findAncestorWidgetOfExactType<ConnectorTheme>();
    return identical(this, ancestorTheme)
        ? child
        : ConnectorTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(ConnectorTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    data.debugFillProperties(properties);
  }
}

/// Connector component configured through [ConnectorTheme]
mixin ThemedConnectorComponent on Widget {
  /// {@template timelines.connector.direction}
  /// If this is null, then the [TimelineThemeData.direction] is used.
  /// {@endtemplate}
  Axis? get direction;

  Axis getEffectiveDirection(BuildContext context) {
    return direction ?? TimelineTheme.of(context).direction;
  }

  /// {@template timelines.connector.thickness}
  /// If this is null, then the [ConnectorThemeData.thickness] is used which
  /// defaults to 2.0.
  /// {@endtemplate}
  double? get thickness;

  double getEffectiveThickness(BuildContext context) {
    return thickness ?? ConnectorTheme.of(context).thickness ?? 2.0;
  }

  /// {@template timelines.connector.space}
  /// If this is null, then the [ConnectorThemeData.space] is used. If that is
  /// also null, then this defaults to double.infinity.
  /// {@endtemplate}
  double? get space;

  double? getEffectiveSpace(BuildContext context) {
    return space ?? ConnectorTheme.of(context).space;
  }

  double? get indent;

  double getEffectiveIndent(BuildContext context) {
    return indent ?? ConnectorTheme.of(context).indent ?? 0.0;
  }

  double? get endIndent;

  double getEffectiveEndIndent(BuildContext context) {
    return endIndent ?? ConnectorTheme.of(context).indent ?? 0.0;
  }

  Color? get color;

  Color getEffectiveColor(BuildContext context) {
    return color ??
        ConnectorTheme.of(context).color ??
        TimelineTheme.of(context).color;
  }
}

/// Abstract class for predefined connector widgets.
///
/// See also:
///
///  * [SolidLineConnector], which is a [Connector] that draws solid line.
///  * [DashedLineConnector], which is a [Connector] that draws outlined dot.
///  * [TransparentConnector], which is a [Connector] that only takes up space.
abstract class Connector extends StatelessWidget with ThemedConnectorComponent {
  /// Creates an connector.
  const Connector({
    Key? key,
    this.direction,
    this.space,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
  })  : assert(thickness == null || thickness >= 0.0),
        assert(space == null || space >= 0.0),
        assert(indent == null || indent >= 0.0),
        assert(endIndent == null || endIndent >= 0.0),
        super(key: key);

  /// Creates a solid line connector.
  ///
  /// See also:
  ///
  /// * [SolidLineConnector],  exactly the same.
  factory Connector.solidLine({
    Key? key,
    Axis? direction,
    double? thickness,
    double? space,
    double? indent,
    double? endIndent,
    Color? color,
  }) {
    return SolidLineConnector(
      key: key,
      direction: direction,
      thickness: thickness,
      space: space,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }

  /// Creates a dashed line connector.
  ///
  /// See also:
  ///
  /// * [DashedLineConnector],  exactly the same.
  factory Connector.dashedLine({
    Key? key,
    Axis? direction,
    double? thickness,
    double? dash,
    double? gap,
    double? space,
    double? indent,
    double? endIndent,
    Color? color,
    Color? gapColor,
  }) {
    return DashedLineConnector(
      key: key,
      direction: direction,
      thickness: thickness,
      dash: dash,
      gap: gap,
      space: space,
      indent: indent,
      endIndent: endIndent,
      color: color,
      gapColor: gapColor,
    );
  }

  /// Creates a dashed transparent connector.
  ///
  /// See also:
  ///
  /// * [TransparentConnector],  exactly the same.
  factory Connector.transparent({
    Key? key,
    Axis? direction,
    double? indent,
    double? endIndent,
    double? space,
  }) {
    return TransparentConnector(
      key: key,
      direction: direction,
      indent: indent,
      endIndent: endIndent,
      space: space,
    );
  }

  /// {@macro timelines.direction}
  ///
  /// {@macro timelines.connector.direction}
  @override
  final Axis? direction;

  /// The connector's cross axis size extent.
  ///
  /// The connector itself is always drawn as a line that is centered within the
  /// size specified by this value.
  /// {@macro timelines.connector.space}
  @override
  final double? space;

  /// The thickness of the line drawn within the connector.
  ///
  /// {@macro timelines.connector.thickness}
  @override
  final double? thickness;

  /// The amount of empty space to the leading edge of the connector.
  ///
  /// If this is null, then the [ConnectorThemeData.indent] is used. If that is
  /// also null, then this defaults to 0.0.
  @override
  final double? indent;

  /// The amount of empty space to the trailing edge of the connector.
  ///
  /// If this is null, then the [ConnectorThemeData.indent] is used. If that is
  /// also null, then this defaults to 0.0.
  @override
  final double? endIndent;

  /// The color to use when painting the line.
  ///
  /// If this is null, then the [ConnectorThemeData.color] is used. If that is
  /// also null, then [TimelineThemeData.color] is used.
  @override
  final Color? color;
}

/// A thin line, with padding on either side.
///
/// The box's total cross axis size(width or height, depend on [direction]) is
/// controlled by [space].
///
/// The appropriate padding is automatically computed from the cross axis size.
class SolidLineConnector extends Connector {
  /// Creates a solid line connector.
  ///
  /// The [thickness], [space], [indent], and [endIndent] must be null or
  /// non-negative.
  const SolidLineConnector({
    Key? key,
    Axis? direction,
    double? thickness,
    double? space,
    double? indent,
    double? endIndent,
    Color? color,
  }) : super(
          key: key,
          thickness: thickness,
          space: space,
          indent: indent,
          endIndent: endIndent,
          color: color,
        );

  @override
  Widget build(BuildContext context) {
    final direction = getEffectiveDirection(context);
    final thickness = getEffectiveThickness(context);
    final color = getEffectiveColor(context);
    final space = getEffectiveSpace(context);
    final indent = getEffectiveIndent(context);
    final endIndent = getEffectiveEndIndent(context);

    switch (direction) {
      case Axis.vertical:
        return _ConnectorIndent(
          direction: direction,
          indent: indent,
          endIndent: endIndent,
          space: space,
          child: Container(
            width: thickness,
            color: color,
          ),
        );
      case Axis.horizontal:
        return _ConnectorIndent(
          direction: direction,
          indent: indent,
          endIndent: endIndent,
          space: space,
          child: Container(
            height: thickness,
            color: color,
          ),
        );
    }
  }
}

/// A decorated thin line, with padding on either side.
///
/// The box's total cross axis size(width or height, depend on [direction]) is
/// controlled by [space].
///
/// The appropriate padding is automatically computed from the cross axis size.
class DecoratedLineConnector extends Connector {
  /// Creates a decorated line connector.
  ///
  /// The [thickness], [space], [indent], and [endIndent] must be null or
  /// non-negative.
  const DecoratedLineConnector({
    Key? key,
    Axis? direction,
    double? thickness,
    double? space,
    double? indent,
    double? endIndent,
    this.decoration,
  }) : super(
          key: key,
          thickness: thickness,
          space: space,
          indent: indent,
          endIndent: endIndent,
        );

  /// The decoration to paint line.
  ///
  /// Use the [SolidLineConnector] class to specify a simple solid color line.
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    final direction = getEffectiveDirection(context);
    final thickness = getEffectiveThickness(context);
    final space = getEffectiveSpace(context);
    final indent = getEffectiveIndent(context);
    final endIndent = getEffectiveEndIndent(context);
    final color = decoration == null ? getEffectiveColor(context) : null;

    switch (direction) {
      case Axis.vertical:
        return _ConnectorIndent(
          direction: direction,
          indent: indent,
          endIndent: endIndent,
          space: space,
          child: Container(
            width: thickness,
            color: color,
            decoration: decoration,
          ),
        );
      case Axis.horizontal:
        return _ConnectorIndent(
          direction: direction,
          indent: indent,
          endIndent: endIndent,
          space: space,
          child: Container(
            height: thickness,
            color: color,
            decoration: decoration,
          ),
        );
    }
  }
}

/// A thin dashed line, with padding on either side.
///
/// The box's total cross axis size(width or height, depend on [direction]) is
/// controlled by [space].
///
/// The appropriate padding is automatically computed from the cross axis size.
///
/// See also:
///
///  * [DashedLinePainter], which is painter that draws this connector.
class DashedLineConnector extends Connector {
  /// Creates a dashed line connector.
  ///
  /// The [thickness], [space], [indent], and [endIndent] must be null or
  /// non-negative.
  const DashedLineConnector({
    Key? key,
    Axis? direction,
    double? thickness,
    this.dash,
    this.gap,
    double? space,
    double? indent,
    double? endIndent,
    Color? color,
    this.gapColor,
  }) : super(
          key: key,
          direction: direction,
          thickness: thickness,
          space: space,
          indent: indent,
          endIndent: endIndent,
          color: color,
        );

  /// The dash size of the line drawn within the connector.
  ///
  /// If this is null, then this defaults to 1.0.
  final double? dash;

  /// The gap of the line drawn within the connector.
  ///
  /// If this is null, then this defaults to 1.0.
  final double? gap;

  /// The color to use when painting the gap in the line.
  ///
  /// If this is null, then the [Colors.transparent] is used.
  final Color? gapColor;

  @override
  Widget build(BuildContext context) {
    final direction = getEffectiveDirection(context);
    return _ConnectorIndent(
      direction: direction,
      indent: getEffectiveIndent(context),
      endIndent: getEffectiveEndIndent(context),
      space: getEffectiveSpace(context),
      child: CustomPaint(
        painter: DashedLinePainter(
          direction: direction,
          color: getEffectiveColor(context),
          strokeWidth: getEffectiveThickness(context),
          dashSize: dash ?? 1.0,
          gapSize: gap ?? 1.0,
          gapColor: gapColor ?? Colors.transparent,
        ),
        child: Container(),
      ),
    );
  }
}

/// A transparent connector for start, end [TimelineNode] of the [Timeline].
///
/// This connector will be not displayed, it only occupies an area.
class TransparentConnector extends Connector {
  /// Creates a transparent connector.
  ///
  /// The [space], [indent], and [endIndent] must be null or non-negative.
  const TransparentConnector({
    Key? key,
    Axis? direction,
    double? indent,
    double? endIndent,
    double? space,
  }) : super(
          key: key,
          direction: direction,
          indent: indent,
          endIndent: endIndent,
          space: space,
        );

  @override
  Widget build(BuildContext context) {
    return _ConnectorIndent(
      direction: getEffectiveDirection(context),
      indent: getEffectiveIndent(context),
      endIndent: getEffectiveEndIndent(context),
      space: getEffectiveSpace(context),
      child: Container(),
    );
  }
}

/// Apply indent to [child].
class _ConnectorIndent extends StatelessWidget {
  /// Creates a indent.
  ///
  /// The [direction]and [child] must be null. And [space], [indent] and
  /// [endIndent] must be null or non-negative.
  const _ConnectorIndent({
    Key? key,
    required this.direction,
    required this.space,
    this.indent,
    this.endIndent,
    required this.child,
  })  : assert(space == null || space >= 0),
        assert(indent == null || indent >= 0),
        assert(endIndent == null || endIndent >= 0),
        super(key: key);

  /// {@macro timelines.direction}
  final Axis direction;

  /// The connector's cross axis size extent.
  ///
  /// The connector itself is always drawn as a line that is centered within the
  /// size specified by this value.
  final double? space;

  /// The amount of empty space to the leading edge of the connector.
  final double? indent;

  /// The amount of empty space to the trailing edge of the connector.
  final double? endIndent;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: direction == Axis.vertical ? space : null,
      height: direction == Axis.vertical ? null : space,
      child: Center(
        child: Padding(
          padding: direction == Axis.vertical
              ? EdgeInsetsDirectional.only(
                  top: indent ?? 0,
                  bottom: endIndent ?? 0,
                )
              : EdgeInsetsDirectional.only(
                  start: indent ?? 0,
                  end: endIndent ?? 0,
                ),
          child: child,
        ),
      ),
    );
  }
}

/// Defines the visual properties of [DotIndicator], indicators inside
/// [TimelineNode]s.
///
/// Descendant widgets obtain the current [IndicatorThemeData] object using
/// `IndicatorTheme.of(context)`. Instances of [IndicatorThemeData] can be
/// customized with [IndicatorThemeData.copyWith].
///
/// Typically a [IndicatorThemeData] is specified as part of the overall
/// [TimelineTheme] with [TimelineThemeData.indicatorTheme].
///
/// All [IndicatorThemeData] properties are `null` by default. When null, the
/// widgets will provide their own defaults.
///
/// See also:
///
///  * [TimelineThemeData], which describes the overall theme information for
///  the timeline.
@immutable
class IndicatorThemeData with Diagnosticable {
  /// Creates a theme that can be used for [IndicatorTheme] or
  /// [TimelineThemeData.indicatorTheme].
  const IndicatorThemeData({
    this.color,
    this.size,
    this.position,
  });

  /// The color of [DotIndicator]s and indicators inside [TimelineNode]s, and so
  /// forth.
  final Color? color;

  /// The size of [DotIndicator]s and indicators inside [TimelineNode]s, and so
  /// forth in logical pixels.
  ///
  /// Indicators occupy a square with width and height equal to size.
  final double? size;

  /// A position of indicator inside both two connectors.
  final double? position;

  /// Creates a copy of this object with the given fields replaced with the new
  /// values.
  IndicatorThemeData copyWith({
    Color? color,
    double? size,
    double? position,
  }) {
    return IndicatorThemeData(
      color: color ?? this.color,
      size: size ?? this.size,
      position: position ?? this.position,
    );
  }

  /// Linearly interpolate between two Indicator themes.
  ///
  /// The argument `t` must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static IndicatorThemeData lerp(
      IndicatorThemeData? a, IndicatorThemeData? b, double t) {
    return IndicatorThemeData(
      color: Color.lerp(a?.color, b?.color, t),
      size: lerpDouble(a?.size, b?.size, t),
      position: lerpDouble(a?.position, b?.position, t),
    );
  }

  @override
  int get hashCode => hashValues(color, size, position);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is IndicatorThemeData &&
        other.color == color &&
        other.size == size &&
        other.position == position;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(DoubleProperty('size', size, defaultValue: null))
      ..add(DoubleProperty('position', size, defaultValue: null));
  }
}

/// Controls the default color and size of indicators in a widget subtree.
///
/// The indicator theme is honored by [TimelineNode], [DotIndicator] and
/// [OutlinedDotIndicator] widgets.
class IndicatorTheme extends InheritedTheme {
  /// Creates an indicator theme that controls the color and size for
  /// [DotIndicator]s, indicators inside [TimelineNode]s.
  const IndicatorTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The properties for descendant [DotIndicator]s, indicators inside
  /// [TimelineNode]s.
  final IndicatorThemeData data;

  /// The data from the closest instance of this class that encloses the given
  /// context.
  ///
  /// Defaults to the current [TimelineThemeData.indicatorTheme].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  ///  IndicatorThemeData theme = IndicatorTheme.of(context);
  /// ```
  static IndicatorThemeData of(BuildContext context) {
    final indicatorTheme =
        context.dependOnInheritedWidgetOfExactType<IndicatorTheme>();
    return indicatorTheme?.data ?? TimelineTheme.of(context).indicatorTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    final ancestorTheme =
        context.findAncestorWidgetOfExactType<IndicatorTheme>();
    return identical(this, ancestorTheme)
        ? child
        : IndicatorTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(IndicatorTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    data.debugFillProperties(properties);
  }
}

/// Indicator component configured through [IndicatorTheme]
mixin ThemedIndicatorComponent on PositionedIndicator {
  /// {@template timelines.indicator.color}
  /// Defaults to the current [IndicatorTheme] color, if any.
  ///
  /// If no [IndicatorTheme] and no [TimelineTheme] is specified, indicators
  /// will default to blue.
  /// {@endtemplate}
  Color? get color;

  Color getEffectiveColor(BuildContext context) {
    return color ??
        IndicatorTheme.of(context).color ??
        TimelineTheme.of(context).color;
  }

  /// {@template timelines.indicator.size}
  /// Indicators occupy a square with width and height equal to size.
  ///
  /// Defaults to the current [IndicatorTheme] size, if any. If there is no
  /// [IndicatorTheme], or it does not specify an explicit size, then it
  /// defaults to own child size(0.0).
  /// {@endtemplate}
  double? get size;

  double? getEffectiveSize(BuildContext context) {
    return size ?? IndicatorTheme.of(context).size;
  }
}

/// [TimelineNode]'s indicator.
mixin PositionedIndicator on Widget {
  /// {@template timelines.indicator.position}
  /// If this is null, then the [IndicatorThemeData.position] is used. If that
  /// is also null, then this defaults to [TimelineThemeData.indicatorPosition].
  /// {@endtemplate}
  double? get position;

  double getEffectivePosition(BuildContext context) {
    return position ??
        IndicatorTheme.of(context).position ??
        TimelineTheme.of(context).indicatorPosition;
  }
}

/// Abstract class for predefined indicator widgets.
///
/// See also:
///
///  * [DotIndicator], which is a [Indicator] that draws dot.
///  * [OutlinedDotIndicator], which is a [Indicator] that draws outlined dot.
///  * [ContainerIndicator], which is a [Indicator] that draws it's child.
abstract class Indicator extends StatelessWidget
    with PositionedIndicator, ThemedIndicatorComponent {
  /// Creates an indicator.
  const Indicator({
    Key? key,
    this.size,
    this.color,
    this.border,
    this.position,
    this.child,
  })  : assert(size == null || size >= 0),
        assert(position == null || 0 <= position && position <= 1),
        super(key: key);

  /// Creates a dot indicator.
  ///
  /// See also:
  ///
  /// * [DotIndicator],  exactly the same.
  factory Indicator.dot({
    Key? key,
    double? size,
    Color? color,
    double? position,
    Border? border,
    Widget? child,
  }) =>
      DotIndicator(
        size: size,
        color: color,
        position: position,
        border: border,
        child: child,
      );

  /// Creates a outlined dot indicator.
  ///
  /// See also:
  ///
  /// * [OutlinedDotIndicator], exactly the same.
  factory Indicator.outlined({
    Key? key,
    double? size,
    Color? color,
    Color? backgroundColor,
    double? position,
    double borderWidth = 2.0,
    Widget? child,
  }) =>
      OutlinedDotIndicator(
        size: size,
        color: color,
        position: position,
        backgroundColor: backgroundColor,
        borderWidth: borderWidth,
        child: child,
      );

  /// Creates a transparent indicator.
  ///
  /// See also:
  ///
  /// * [ContainerIndicator], this is created without child.
  factory Indicator.transparent({
    Key? key,
    double? size,
    double? position,
  }) =>
      ContainerIndicator(
        size: size,
        position: position,
      );

  /// Creates a widget indicator.
  ///
  /// See also:
  ///
  /// * [OutlinedDotIndicator], exactly the same.
  factory Indicator.widget({
    Key? key,
    double? size,
    double? position,
    Widget? child,
  }) =>
      ContainerIndicator(
        size: size,
        position: position,
        child: child,
      );

  /// The size of the dot in logical pixels.
  ///
  /// {@macro timelines.indicator.size}
  @override
  final double? size;

  /// The color to use when drawing the dot.
  ///
  /// {@macro timelines.indicator.color}
  @override
  final Color? color;

  /// The position of a indicator between the two connectors.
  ///
  /// {@macro timelines.indicator.position}
  @override
  final double? position;

  /// The border to use when drawing the dot's outline.
  final BoxBorder? border;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget? child;
}

/// A widget that displays an [child]. The [child] if null, the indicator is not
/// visible.
class ContainerIndicator extends Indicator {
  /// Creates a container indicator.
  const ContainerIndicator({
    Key? key,
    double? size,
    double? position,
    this.child,
  }) : super(
          key: key,
          size: size,
          position: position,
          color: Colors.transparent,
        );

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final size = getEffectiveSize(context);
    return Container(
      width: size,
      height: size,
      child: child,
    );
  }
}

/// A widget that displays an dot.
class DotIndicator extends Indicator {
  /// Creates a dot indicator.
  ///
  /// The [size] must be null or non-negative.
  const DotIndicator({
    Key? key,
    double? size,
    Color? color,
    double? position,
    this.border,
    this.child,
  }) : super(
          key: key,
          size: size,
          color: color,
          position: position,
        );

  /// The border to use when drawing the dot's outline.
  final BoxBorder? border;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = getEffectiveSize(context);
    final effectiveColor = getEffectiveColor(context);
    return Center(
      child: Container(
        width: effectiveSize ?? ((child == null) ? 15.0 : null),
        height: effectiveSize ?? ((child == null) ? 15.0 : null),
        child: child,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          //color: effectiveColor,
          //border: border,
        ),
      ),
    );
  }
}

/// A widget that displays an outlined dot.
class OutlinedDotIndicator extends Indicator {
  /// Creates a outlined dot indicator.
  ///
  /// The [size] must be null or non-negative.
  const OutlinedDotIndicator({
    Key? key,
    double? size,
    Color? color,
    double? position,
    this.backgroundColor,
    this.borderWidth = 2.0,
    this.child,
  })  : assert(size == null || size >= 0),
        assert(position == null || 0 <= position && position <= 1),
        super(
          key: key,
          size: size,
          color: color,
          position: position,
        );

  /// The color to use when drawing the dot in outline.
  ///
  /// {@macro timelines.indicator.color}
  final Color? backgroundColor;

  /// The width of this outline, in logical pixels.
  final double borderWidth;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DotIndicator(
      size: size,
      color: backgroundColor ?? Colors.transparent,
      position: position,
      border: Border.all(
        color: color ?? getEffectiveColor(context),
        width: borderWidth,
      ),
      child: child,
    );
  }
}

/// Paints a [DashedLineConnector].
///
/// Draw the line like this:
/// ```
///  0 > [dash][gap][dash][gap] < constraints size
/// ```
///
/// [dashSize] specifies the size of [dash]. and [gapSize] specifies the size of
/// [gap].
///
/// When using the default colors, this painter draws a dotted line or dashed
/// line that familiar.
/// If set other [gapColor], this painter draws a line that alternates between
/// two colors.
class DashedLinePainter extends CustomPainter {
  /// Creates a dashed line painter.
  ///
  /// The [dashSize] argument must be 1 or more, and the [gapSize] and
  /// [strokeWidth] arguments must be positive numbers.
  ///
  /// The [direction], [color], [gapColor] and [strokeCap] arguments must not be
  /// null.
  const DashedLinePainter({
    required this.direction,
    required this.color,
    this.gapColor = Colors.transparent,
    this.dashSize = 1.0,
    this.gapSize = 1.0,
    this.strokeWidth = 1.0,
    this.strokeCap = StrokeCap.square,
  })  : assert(dashSize >= 1),
        assert(gapSize >= 0),
        assert(strokeWidth >= 0);

  /// {@macro timelines.direction}
  final Axis direction;

  /// The color to paint dash of line.
  final Color color;

  /// The color to paint gap(another dash) of line.
  final Color gapColor;

  /// The size of dash
  final double dashSize;

  /// The size of gap, it also draws [gapColor]
  final double gapSize;

  /// The stroke width of dash and gap.
  final double strokeWidth;

  /// Styles to use for line endings.
  final StrokeCap strokeCap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap
      ..style = PaintingStyle.stroke;

    var offset = _DashOffset(
      containerSize: size,
      strokeWidth: strokeWidth,
      dashSize: dashSize,
      gapSize: gapSize,
      axis: direction,
    );

    while (offset.hasNext) {
      // draw dash
      paint.color = color;
      canvas.drawLine(
        offset,
        offset.translateDashSize(),
        paint,
      );
      offset = offset.translateDashSize();

      // draw gap
      if (gapColor != Colors.transparent) {
        paint.color = gapColor;
        canvas.drawLine(
          offset,
          offset.translateGapSize(),
          paint,
        );
      }
      offset = offset.translateGapSize();
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) {
    return direction != oldDelegate.direction ||
        color != oldDelegate.color ||
        gapColor != oldDelegate.gapColor ||
        dashSize != oldDelegate.dashSize ||
        gapSize != oldDelegate.gapSize ||
        strokeWidth != oldDelegate.strokeWidth ||
        strokeCap != oldDelegate.strokeCap;
  }
}

class _DashOffset extends Offset {
  factory _DashOffset({
    required Size containerSize,
    required double strokeWidth,
    required double dashSize,
    required double gapSize,
    required Axis axis,
  }) {
    return _DashOffset._(
      dx: axis == Axis.vertical ? containerSize.width / 2 : 0,
      dy: axis == Axis.vertical ? 0 : containerSize.height / 2,
      strokeWidth: strokeWidth,
      containerSize: containerSize,
      dashSize: dashSize,
      gapSize: gapSize,
      axis: axis,
    );
  }

  const _DashOffset._({
    required double dx,
    required double dy,
    required this.strokeWidth,
    required this.containerSize,
    required this.dashSize,
    required this.gapSize,
    required this.axis,
  }) : super(dx, dy);

  final Size containerSize;
  final double strokeWidth;
  final double dashSize;
  final double gapSize;
  final Axis axis;

  double get offset {
    if (axis == Axis.vertical) {
      return dy;
    } else {
      return dx;
    }
  }

  bool get hasNext {
    if (axis == Axis.vertical) {
      return offset < containerSize.height;
    } else {
      return offset < containerSize.width;
    }
  }

  _DashOffset translateDashSize() {
    return _translateDirectionally(dashSize);
  }

  _DashOffset translateGapSize() {
    return _translateDirectionally(gapSize + strokeWidth);
  }

  _DashOffset _translateDirectionally(double offset) {
    if (axis == Axis.vertical) {
      return translate(0, offset) as _DashOffset;
    } else {
      return translate(offset, 0) as _DashOffset;
    }
  }

  @override
  Offset translate(double translateX, double translateY) {
    double dx, dy;
    if (axis == Axis.vertical) {
      dx = this.dx;
      dy = this.dy + translateY;
    } else {
      dx = this.dx + translateX;
      dy = this.dy;
    }
    return copyWith(
      dx: min(dx, containerSize.width),
      dy: min(dy, containerSize.height),
    );
  }

  _DashOffset copyWith({
    double? dx,
    double? dy,
    Size? containerSize,
    double? strokeWidth,
    double? dashSize,
    double? gapSize,
    Axis? axis,
  }) {
    return _DashOffset._(
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      containerSize: containerSize ?? this.containerSize,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      dashSize: dashSize ?? this.dashSize,
      gapSize: gapSize ?? this.gapSize,
      axis: axis ?? this.axis,
    );
  }
}

/// [TimelineTile]'s timeline node
mixin TimelineTileNode on Widget {
  /// {@template timelines.node.position}
  /// If this is null, then the [TimelineThemeData.nodePosition] is used.
  /// {@endtemplate}
  double? get position;

  double getEffectivePosition(BuildContext context) {
    return position ?? TimelineTheme.of(context).nodePosition;
  }
}

/// A widget that displays indicator and two connectors.
///
/// The [indicator] displayed between the [startConnector] and [endConnector]
class TimelineNode extends StatelessWidget with TimelineTileNode {
  /// Creates a timeline node.
  ///
  /// The [indicatorPosition] must be null or a value between 0 and 1.
  const TimelineNode({
    Key? key,
    this.direction,
    this.startConnector,
    this.endConnector,
    this.indicator = const ContainerIndicator(),
    this.indicatorPosition,
    this.position,
    this.overlap,
  })  : assert(indicatorPosition == null ||
            0 <= indicatorPosition && indicatorPosition <= 1),
        super(key: key);

  /// Creates a timeline node that connects the dot indicator in a solid line.
  TimelineNode.simple({
    Key? key,
    Axis? direction,
    Color? color,
    double? lineThickness,
    double? nodePosition,
    double? indicatorPosition,
    double? indicatorSize,
    Widget? indicatorChild,
    double? indent,
    double? endIndent,
    bool drawStartConnector = true,
    bool drawEndConnector = true,
    bool? overlap,
  }) : this(
          key: key,
          direction: direction,
          startConnector: drawStartConnector
              ? SolidLineConnector(
                  direction: direction,
                  color: color,
                  thickness: lineThickness,
                  indent: indent,
                  endIndent: endIndent,
                )
              : null,
          endConnector: drawEndConnector
              ? SolidLineConnector(
                  direction: direction,
                  color: color,
                  thickness: lineThickness,
                  indent: indent,
                  endIndent: endIndent,
                )
              : null,
          indicator: DotIndicator(
            child: indicatorChild,
            position: indicatorPosition,
            size: indicatorSize,
            color: color,
          ),
          indicatorPosition: indicatorPosition,
          position: nodePosition,
          overlap: overlap,
        );

  /// {@macro timelines.direction}
  final Axis? direction;

  /// The connector of the start edge of this node
  final Widget? startConnector;

  /// The connector of the end edge of this node
  final Widget? endConnector;

  /// The indicator of the node
  final Widget indicator;

  /// The position of a indicator between the two connectors.
  ///
  /// {@macro timelines.indicator.position}
  final double? indicatorPosition;

  /// A position of timeline node between both two contents.
  ///
  /// {@macro timelines.node.position}
  @override
  final double? position;

  /// Determine whether each connectors and indicator will overlap.
  ///
  /// When each connectors overlap, they are drawn from the center offset of the
  /// indicator.
  final bool? overlap;

  double _getEffectiveIndicatorPosition(BuildContext context) {
    var indicatorPosition = this.indicatorPosition;
    indicatorPosition ??= (indicator is PositionedIndicator)
        ? (indicator as PositionedIndicator).getEffectivePosition(context)
        : TimelineTheme.of(context).indicatorPosition;
    return indicatorPosition;
  }

  bool _getEffectiveOverlap(BuildContext context) {
    var overlap = this.overlap ?? TimelineTheme.of(context).nodeItemOverlap;
    return overlap;
  }

  @override
  Widget build(BuildContext context) {
    final direction = this.direction ?? TimelineTheme.of(context).direction;
    final overlap = _getEffectiveOverlap(context);
    // TODO: support both flex and logical pixel
    final indicatorFlex = _getEffectiveIndicatorPosition(context);
    Widget line = indicator;
    final lineItems = [
      if (indicatorFlex > 0)
        Flexible(
          flex: (indicatorFlex * kFlexMultiplier).toInt(),
          child: startConnector ?? TransparentConnector(),
        ),
      if (!overlap) indicator,
      if (indicatorFlex < 1)
        Flexible(
          flex: ((1 - indicatorFlex) * kFlexMultiplier).toInt(),
          child: endConnector ?? TransparentConnector(),
        ),
    ];

    switch (direction) {
      case Axis.vertical:
        line = Column(
          mainAxisSize: MainAxisSize.min,
          children: lineItems,
        );
        break;
      case Axis.horizontal:
        line = Row(
          mainAxisSize: MainAxisSize.min,
          children: lineItems,
        );
        break;
    }

    Widget result;
    if (overlap) {
      Widget positionedIndicator = indicator;
      final positionedIndicatorItems = [
        if (indicatorFlex > 0)
          Flexible(
            flex: (indicatorFlex * kFlexMultiplier).toInt(),
            child: TransparentConnector(),
          ),
        indicator,
        Flexible(
          flex: ((1 - indicatorFlex) * kFlexMultiplier).toInt(),
          child: TransparentConnector(),
        ),
      ];

      switch (direction) {
        case Axis.vertical:
          positionedIndicator = Column(
            mainAxisSize: MainAxisSize.min,
            children: positionedIndicatorItems,
          );
          break;
        case Axis.horizontal:
          positionedIndicator = Row(
            mainAxisSize: MainAxisSize.min,
            children: positionedIndicatorItems,
          );
          break;
      }

      result = Stack(
        alignment: Alignment.center,
        children: [
          line,
          positionedIndicator,
        ],
      );
    } else {
      result = line;
    }

    if (TimelineTheme.of(context).direction != direction) {
      result = TimelineTheme(
        data: TimelineTheme.of(context).copyWith(
          direction: direction,
        ),
        child: result,
      );
    }

    return result;
  }
}

/// Applies a theme to descendant timeline widgets.
///
/// A theme describes the colors and typographic choices of an application.
///
/// Descendant widgets obtain the current theme's [TimelineThemeData] object
/// using [TimelineTheme.of]. When a widget uses [TimelineTheme.of], it is
/// automatically rebuilt if the theme later changes, so that the changes can be
/// applied.
///
/// See also:
///
///  * [TimelineThemeData], which describes the actual configuration of a theme.
class TimelineTheme extends StatelessWidget {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const TimelineTheme({
    Key? key,
    required this.data,
    required this.child,
  }) : super(key: key);

  /// Specifies the direction for descendant widgets.
  final TimelineThemeData data;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  static final TimelineThemeData _kFallbackTheme = TimelineThemeData.fallback();

  /// The data from the closest [TimelineTheme] instance that encloses the given
  /// context.
  ///
  /// Defaults to [new ThemeData.fallback] if there is no [Theme] in the given
  /// build context.
  ///
  /// When the [TimelineTheme] is actually created in the same `build` function
  /// (possibly indirectly, e.g. as part of a [Timeline]), the `context`
  /// argument to the `build` function can't be used to find the [TimelineTheme]
  /// (since it's "above" the widget being returned). In such cases, the
  /// following technique with a [Builder] can be used to provide a new scope
  /// with a [BuildContext] that is "under" the [TimelineTheme]:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   // TODO: replace to Timeline
  ///   return TimelineTheme(
  ///     data: TimelineThemeData.vertical(),
  ///     child: Builder(
  ///       // Create an inner BuildContext so that we can refer to the Theme with TimelineTheme.of().
  ///       builder: (BuildContext context) {
  ///         return Center(
  ///           child: TimelineNode(
  ///             direction: TimelineTheme.of(context).direction,
  ///             child: Text('Example'),
  ///           ),
  ///         );
  ///       },
  ///     ),
  ///   );
  /// }
  /// ```
  static TimelineThemeData of(BuildContext context) {
    final inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedTheme>();
    return inheritedTheme?.theme.data ?? _kFallbackTheme;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedTheme(
      theme: this,
      child: IndicatorTheme(
        data: data.indicatorTheme,
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<TimelineThemeData>('data', data, showName: false));
  }
}

class _InheritedTheme extends InheritedTheme {
  const _InheritedTheme({
    Key? key,
    required this.theme,
    required Widget child,
  }) : super(key: key, child: child);

  final TimelineTheme theme;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final ancestorTheme =
        context.findAncestorWidgetOfExactType<_InheritedTheme>();
    return identical(this, ancestorTheme)
        ? child
        : TimelineTheme(data: theme.data, child: child);
  }

  @override
  bool updateShouldNotify(_InheritedTheme old) => theme.data != old.theme.data;
}

/// Defines the configuration of the overall visual [TimelineTheme] for a
/// [Timeline] or a widget subtree within the app.
///
/// The [Timeline] theme property can be used to configure the appearance of the
/// entire timeline. Widget subtree's within an timeline can override the
/// timeline's theme by including a [TimelineTheme] widget at the top of the
/// subtree.
///
/// Widgets whose appearance should align with the overall theme can obtain the
/// current theme's configuration with [TimelineTheme.of].
///
/// The static [TimelineTheme.of] method finds the [TimelineThemeData] value
/// specified for the nearest [BuildContext] ancestor. This lookup is
/// inexpensive, essentially just a single HashMap access. It can sometimes be a
/// little confusing because [TimelineTheme.of] can not see a [TimelineTheme]
/// widget that is defined in the current build method's context. To overcome
/// that, create a new custom widget for the subtree that appears below the new
/// [TimelineTheme], or insert a widget that creates a new BuildContext, like
/// [Builder].
///
/// {@tool snippet}
/// In this example, the [Container] widget uses [Theme.of] to retrieve the
/// color from the theme's [color] to draw an amber square.
/// The [Builder] widget separates the parent theme's [BuildContext] from the
/// child's [BuildContext].
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/material/theme_data.png)
///
/// ```dart
/// TimelineTheme(
///   data: TimelineThemeData(
///     color: Colors.red,
///   ),
///   child: Builder(
///     builder: (BuildContext context) {
///       return Container(
///         width: 100,
///         height: 100,
///         color: TimelineTheme.of(context).color,
///       );
///     },
///   ),
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
@immutable
class TimelineThemeData with Diagnosticable {
  /// Create a [TimelineThemeData] that's used to configure a [TimelineTheme].
  ///
  /// See also:
  ///
  ///  * [TimelineThemeData.vertical], which creates a vertical direction
  ///  TimelineThemeData.
  ///  * [TimelineThemeData.horizontal], which creates a horizontal direction
  ///  TimelineThemeData.
  factory TimelineThemeData({
    Axis? direction,
    Color? color,
    double? nodePosition,
    bool? nodeItemOverlap,
    double? indicatorPosition,
    IndicatorThemeData? indicatorTheme,
    ConnectorThemeData? connectorTheme,
  }) {
    direction ??= Axis.vertical;
    color ??= Colors
        .blue; // TODO: Need to change the default color to the theme color?
    nodePosition ??= 0.5;
    nodeItemOverlap ??= false;
    indicatorPosition ??= 0.5;
    indicatorTheme ??= IndicatorThemeData();
    connectorTheme ??= ConnectorThemeData();
    return TimelineThemeData.raw(
      direction: direction,
      color: color,
      nodePosition: nodePosition,
      nodeItemOverlap: nodeItemOverlap,
      indicatorPosition: indicatorPosition,
      indicatorTheme: indicatorTheme,
      connectorTheme: connectorTheme,
    );
  }

  /// The default direction theme. Same as [new TimelineThemeData.vertical].
  ///
  /// This is used by [TimelineTheme.of] when no theme has been specified.
  factory TimelineThemeData.fallback() => TimelineThemeData.vertical();

  /// Create a [TimelineThemeData] given a set of exact values. All the values
  /// must be specified. They all must also be non-null.
  ///
  /// This will rarely be used directly. It is used by [lerp] to create
  /// intermediate themes based on two themes created with the
  /// [new TimelineThemeData] constructor.
  const TimelineThemeData.raw({
    required this.direction,
    required this.color,
    required this.nodePosition,
    required this.nodeItemOverlap,
    required this.indicatorPosition,
    required this.indicatorTheme,
    required this.connectorTheme,
  });

  /// A default vertical theme.
  factory TimelineThemeData.vertical() => TimelineThemeData(
        direction: Axis.vertical,
      );

  /// A default horizontal theme.
  factory TimelineThemeData.horizontal() => TimelineThemeData(
        direction: Axis.horizontal,
      );

  /// {@macro timelines.direction}
  final Axis direction;

  /// The color for major parts of the timeline (indicator, connector, etc)
  final Color color;

  /// The position for [TimelineNode] in [TimelineTile].
  ///
  /// Defaults to 0.5.
  final double nodePosition;

  /// Determine whether each connectors and indicator will overlap in
  /// [TimelineNode].
  ///
  /// When each connectors overlap, they are drawn from the center offset of the
  /// indicator.
  final bool nodeItemOverlap;

  /// The position for indicator in [TimelineNode].
  ///
  /// Defaults to 0.5.
  final double indicatorPosition;

  /// A theme for customizing the appearance and layout of
  /// [ThemedIndicatorComponent] widgets.
  final IndicatorThemeData indicatorTheme;

  /// A theme for customizing the appearance and layout of
  /// [ThemedConnectorComponent] widgets.
  final ConnectorThemeData connectorTheme;

  /// Creates a copy of this theme but with the given fields replaced with the
  /// new values.
  TimelineThemeData copyWith({
    Axis? direction,
    Color? color,
    double? nodePosition,
    bool? nodeItemOverlap,
    double? indicatorPosition,
    IndicatorThemeData? indicatorTheme,
    ConnectorThemeData? connectorTheme,
  }) {
    return TimelineThemeData.raw(
      direction: direction ?? this.direction,
      color: color ?? this.color,
      nodePosition: nodePosition ?? this.nodePosition,
      nodeItemOverlap: nodeItemOverlap ?? this.nodeItemOverlap,
      indicatorPosition: indicatorPosition ?? this.indicatorPosition,
      indicatorTheme: indicatorTheme ?? this.indicatorTheme,
      connectorTheme: connectorTheme ?? this.connectorTheme,
    );
  }

  /// Linearly interpolate between two themes.
  ///
  /// The arguments must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static TimelineThemeData lerp(
      TimelineThemeData a, TimelineThemeData b, double t) {
    // Warning: make sure these properties are in the exact same order as in
    // hashValues() and in the raw constructor and in the order of fields in
    // the class and in the lerp() method.
    return TimelineThemeData.raw(
      direction: t < 0.5 ? a.direction : b.direction,
      color: Color.lerp(a.color, b.color, t)!,
      nodePosition: lerpDouble(a.nodePosition, b.nodePosition, t)!,
      nodeItemOverlap: t < 0.5 ? a.nodeItemOverlap : b.nodeItemOverlap,
      indicatorPosition:
          lerpDouble(a.indicatorPosition, b.indicatorPosition, t)!,
      indicatorTheme:
          IndicatorThemeData.lerp(a.indicatorTheme, b.indicatorTheme, t),
      connectorTheme:
          ConnectorThemeData.lerp(a.connectorTheme, b.connectorTheme, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    // Warning: make sure these properties are in the exact same order as in
    // hashValues() and in the raw constructor and in the order of fields in
    // the class and in the lerp() method.
    return other is TimelineThemeData &&
        other.direction == direction &&
        other.color == color &&
        other.nodePosition == nodePosition &&
        other.nodeItemOverlap == nodeItemOverlap &&
        other.indicatorPosition == indicatorPosition &&
        other.indicatorTheme == indicatorTheme &&
        other.connectorTheme == connectorTheme;
  }

  @override
  int get hashCode {
    // Warning: For the sanity of the reader, please make sure these properties
    // are in the exact same order as in operator == and in the raw constructor
    // and in the order of fields in the class and in the lerp() method.
    final values = <Object>[
      direction,
      color,
      nodePosition,
      nodeItemOverlap,
      indicatorPosition,
      indicatorTheme,
      connectorTheme,
    ];
    return hashList(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final defaultData = TimelineThemeData.fallback();
    properties
      ..add(DiagnosticsProperty<Axis>('direction', direction,
          defaultValue: defaultData.direction, level: DiagnosticLevel.debug))
      ..add(ColorProperty('color', color,
          defaultValue: defaultData.color, level: DiagnosticLevel.debug))
      ..add(DoubleProperty('nodePosition', nodePosition,
          defaultValue: defaultData.nodePosition, level: DiagnosticLevel.debug))
      ..add(FlagProperty('nodeItemOverlap',
          value: nodeItemOverlap, ifTrue: 'overlap connector and indicator'))
      ..add(DoubleProperty('indicatorPosition', indicatorPosition,
          defaultValue: defaultData.indicatorPosition,
          level: DiagnosticLevel.debug))
      ..add(DiagnosticsProperty<IndicatorThemeData>(
        'indicatorTheme',
        indicatorTheme,
        defaultValue: defaultData.indicatorTheme,
        level: DiagnosticLevel.debug,
      ))
      ..add(DiagnosticsProperty<ConnectorThemeData>(
        'connectorTheme',
        connectorTheme,
        defaultValue: defaultData.connectorTheme,
        level: DiagnosticLevel.debug,
      ));
  }
}

/// Align the timeline node within the timeline tile.
enum TimelineNodeAlign {
  /// Align [TimelineTile.node] to start side.
  start,

  /// Align [TimelineTile.node] to end side.
  end,

  /// Align according to the [TimelineTile.nodePosition].
  basic,
}

/// A widget that displays timeline node and two contents.
///
/// The [contents] are displayed on the end side, and the [oppositeContents] are
/// displayed on the start side.
/// The [node] is displayed between the two.
class TimelineTile extends StatelessWidget {
  const TimelineTile({
    Key? key,
    this.direction,
    required this.node,
    this.nodeAlign = TimelineNodeAlign.basic,
    this.nodePosition,
    this.contents,
    this.oppositeContents,
    this.mainAxisExtent,
    this.crossAxisExtent,
  })  : assert(
          nodeAlign == TimelineNodeAlign.basic ||
              (nodeAlign != TimelineNodeAlign.basic && nodePosition == null),
          'Cannot provide both a nodeAlign and a nodePosition',
        ),
        assert(nodePosition == null || nodePosition >= 0),
        super(key: key);

  /// {@template timelines.direction}
  /// The axis along which the timeline scrolls.
  /// {@endtemplate}
  final Axis? direction;

  /// A widget that displays indicator and two connectors.
  final Widget node;

  /// Align the [node] within the timeline tile.
  ///
  /// If try to use indicators with different sizes in each timeline tile, the
  /// timeline node may be broken.
  /// This can be prevented by set [IndicatorThemeData.size] to an appropriate
  /// size.
  ///
  /// If [nodeAlign] is not [TimelineNodeAlign.basic], then [nodePosition] is
  /// ignored.
  final TimelineNodeAlign nodeAlign;

  /// A position of [node] inside both two contents.
  ///
  /// {@macro timelines.node.position}
  final double? nodePosition;

  /// The contents to display inside the timeline tile.
  final Widget? contents;

  /// The contents to display on the opposite side of the [contents].
  final Widget? oppositeContents;

  /// The extent of the child in the scrolling axis.
  /// If the scroll axis is vertical, this extent is the child's height. If the
  /// scroll axis is horizontal, this extent is the child's width.
  ///
  /// If non-null, forces the tile to have the given extent in the scroll
  /// direction.
  ///
  /// Specifying an [mainAxisExtent] is more efficient than letting the tile
  /// determine their own extent because the because it don't use the Intrinsic
  /// widget([IntrinsicHeight]/[IntrinsicWidth]) when building.
  final double? mainAxisExtent;

  /// The extent of the child in the non-scrolling axis.
  ///
  /// If the scroll axis is vertical, this extent is the child's width. If the
  /// scroll axis is horizontal, this extent is the child's height.
  final double? crossAxisExtent;

  double _getEffectiveNodePosition(BuildContext context) {
    if (nodeAlign == TimelineNodeAlign.start) return 0.0;
    if (nodeAlign == TimelineNodeAlign.end) return 1.0;
    var nodePosition = this.nodePosition;
    nodePosition ??= (node is TimelineTileNode)
        ? (node as TimelineTileNode).getEffectivePosition(context)
        : TimelineTheme.of(context).nodePosition;
    return nodePosition;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: reduce direction check
    final direction = this.direction ?? TimelineTheme.of(context).direction;
    final nodeFlex = _getEffectiveNodePosition(context) * kFlexMultiplier;

    var minNodeExtent = TimelineTheme.of(context).indicatorTheme.size ?? 0.0;
    var items = [
      if (nodeFlex > 0)
        Expanded(
          flex: nodeFlex.toInt(),
          child: Align(
            alignment: direction == Axis.vertical
                ? AlignmentDirectional.centerEnd
                : Alignment.bottomCenter,
            child: oppositeContents ?? SizedBox.shrink(),
          ),
        ),
      ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: direction == Axis.vertical ? minNodeExtent : 0.0,
          minHeight: direction == Axis.vertical ? 0.0 : minNodeExtent,
        ),
        child: node,
      ),
      if (nodeFlex < kFlexMultiplier)
        Expanded(
          flex: (kFlexMultiplier - nodeFlex).toInt(),
          child: Align(
            alignment: direction == Axis.vertical
                ? AlignmentDirectional.centerStart
                : Alignment.topCenter,
            child: contents ?? SizedBox.shrink(),
          ),
        ),
    ];

    var result;
    switch (direction) {
      case Axis.vertical:
        result = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items,
        );

        if (mainAxisExtent != null) {
          result = SizedBox(
            width: crossAxisExtent,
            height: mainAxisExtent,
            child: result,
          );
        } else {
          result = IntrinsicHeight(
            child: result,
          );

          if (crossAxisExtent != null) {
            result = SizedBox(
              width: crossAxisExtent,
              child: result,
            );
          }
        }
        break;
      case Axis.horizontal:
        result = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items,
        );
        if (mainAxisExtent != null) {
          result = SizedBox(
            width: mainAxisExtent,
            height: crossAxisExtent,
            child: result,
          );
        } else {
          result = IntrinsicWidth(
            child: result,
          );

          if (crossAxisExtent != null) {
            result = SizedBox(
              height: crossAxisExtent,
              child: result,
            );
          }
        }
        break;
      default:
        throw ArgumentError.value(direction, '$direction is invalid.');
    }

    result = Align(
      child: result,
    );

    if (TimelineTheme.of(context).direction != direction) {
      result = TimelineTheme(
        data: TimelineTheme.of(context).copyWith(
          direction: direction,
        ),
        child: result,
      );
    }

    return result;
  }
}

/// How a contents displayed be into timeline.
///
/// See also:
///  * [TimelineTileBuilder.fromStyle]
enum ContentsAlign {
  /// The contents aligned end of timeline. And the opposite contents aligned
  /// start of timeline.
  ///
  /// Example:
  /// ```
  /// opposite contents  |  contents
  /// opposite contents  |  contents
  /// opposite contents  |  contents
  /// ```
  basic,

  /// The contents aligned start of timeline. And the opposite contents aligned
  /// end of timeline.
  ///
  /// Example:
  ///
  /// ```
  /// contents  |  opposite contents
  /// contents  |  opposite contents
  /// contents  |  opposite contents
  /// ```
  reverse,

  /// The contents and opposite contents displayed alternating.
  ///
  /// Example:
  /// ```
  ///          contents  |  opposite contents
  /// opposite contents  |  contents
  ///          contents  |  opposite contents
  /// opposite contents  |  contents
  ///          contents  |  opposite contents
  /// ```
  alternating,
}

/// An enum that representing the direction the connector is connected through
/// the builder.
///
/// See also:
///
///  * [TimelineTileBuilder.connected], which is how the builder uses this enum
///  to connect each connector.
///  * [TimelineTileBuilder.connectedFromStyle], which is how the builder uses
///  this enum to connect each connector.
enum ConnectionDirection { before, after }

/// An enum that representing the connector type in [TimelineNode].
///
/// For example, if the timeline direction is Axis.horizontal and the text
/// direction is LTR:
/// ```
///   start   end
///   ---- O ----
/// ```
/// See also:
///
///  * [ConnectedConnectorBuilder], which is use this.
enum ConnectorType { start, end }

/// An enum that determines the style of indicator in timeline tile builder.
///
/// TODO: replace with class to support parameters
///
/// See also:
///
///  * [TimelineTileBuilder.fromStyle], which is use this.
///  * [TimelineTileBuilder.connectedFromStyle], which is use this.
enum IndicatorStyle {
  /// Draw dot indicator.
  dot,

  /// Draw outlined dot indicator.
  outlined,

  /// Draw container indicator. TODO: need child to builds...
  container,

  /// Draw transparent indicator. (invisible indicator)
  transparent,
}

/// Types of connectors displayed into timeline
///
/// See also:
/// * [TimelineTileBuilder.fromStyle].
enum ConnectorStyle {
  /// Draw solid line connector.
  solidLine,

  /// Draw dashed line connector.
  dashedLine,

  /// Draw transparent connector. (invisible connector)
  transparent,
}

/// Signature for a function that creates a connected connector widget for a
/// given index and type, e.g., in a timeline tile builder.
typedef ConnectedConnectorBuilder = Widget? Function(
    BuildContext context, int index, ConnectorType type);

/// Signature for a function that creates a typed value for a given index, e.g.,
/// in a timeline tile builder.
///
/// Used by [TimelineTileBuilder] that use lazily-generated typed value.
typedef IndexedValueBuilder<T> = T Function(BuildContext context, int index);

/// WARNING: The interface of this class is not yet clear. It may change
/// frequently.
///
/// A delegate that supplies [TimelineTile] for timeline using a builder
/// callback.
class TimelineTileBuilder {
  /// Create a connected tile builder, which builds tiles using each component
  /// builder.
  ///
  /// Check below for how to build:
  ///
  /// Original build system:
  ///
  /// ```
  /// |            <-- builder(0)
  /// O contents1  <-- builder(0)
  /// |            <-- builder(0)
  /// |            <-- builder(1)
  /// O contents2  <-- builder(1)
  /// |            <-- builder(1)
  /// ```
  ///
  /// Connected build system(before):
  ///
  /// ```
  /// |            <-- draw if provided [firstConnectorBuilder]
  /// O contents1  <-- builder(0)
  /// |            <-- builder(1)
  /// |            <-- builder(1)
  /// O contents2  <-- builder(1)
  /// |            <-- builder(2)
  /// |            <-- builder(2)
  /// O            <-- builder(2)
  /// |            <-- builder(3)
  /// ..
  /// |            <-- draw if provided [lastConnectorBuilder]
  /// ```
  ///
  ///
  /// Connected build system(after):
  ///
  /// ```
  /// |            <-- draw if provided [firstConnectorBuilder]
  /// O contents1  <-- builder(0)
  /// |            <-- builder(0)
  /// |            <-- builder(0)
  /// O contents2  <-- builder(1)
  /// |            <-- builder(1)
  /// |            <-- builder(1)
  /// O            <-- builder(2)
  /// |            <-- builder(2)
  /// ..
  /// |            <-- draw if provided [lastConnectorBuilder]
  /// ```
  ///
  /// The above example can be made similar by just set the
  /// [TimelineNode.indicatorPosition] as 0 or 1, but the contents position may
  /// be limited.
  ///
  /// {@macro timelines.itemExtentBuilder}
  ///
  /// See also:
  ///
  ///  * [TimelineTileBuilder.connectedFromStyle], which builds connected tiles
  ///  from style.
  factory TimelineTileBuilder.connected({
    required int itemCount,
    ContentsAlign contentsAlign = ContentsAlign.basic,
    ConnectionDirection connectionDirection = ConnectionDirection.after,
    NullableIndexedWidgetBuilder? contentsBuilder,
    NullableIndexedWidgetBuilder? oppositeContentsBuilder,
    NullableIndexedWidgetBuilder? indicatorBuilder,
    ConnectedConnectorBuilder? connectorBuilder,
    WidgetBuilder? firstConnectorBuilder,
    WidgetBuilder? lastConnectorBuilder,
    double? itemExtent,
    IndexedValueBuilder<double>? itemExtentBuilder,
    IndexedValueBuilder<double>? nodePositionBuilder,
    IndexedValueBuilder<double>? indicatorPositionBuilder,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  }) {
    return TimelineTileBuilder(
      itemCount: itemCount,
      contentsAlign: contentsAlign,
      contentsBuilder: contentsBuilder,
      oppositeContentsBuilder: oppositeContentsBuilder,
      indicatorBuilder: indicatorBuilder,
      startConnectorBuilder: _createConnectedStartConnectorBuilder(
        connectionDirection: connectionDirection,
        firstConnectorBuilder: firstConnectorBuilder,
        connectorBuilder: connectorBuilder,
      ),
      endConnectorBuilder: _createConnectedEndConnectorBuilder(
        connectionDirection: connectionDirection,
        lastConnectorBuilder: lastConnectorBuilder,
        connectorBuilder: connectorBuilder,
        itemCount: itemCount,
      ),
      itemExtent: itemExtent,
      itemExtentBuilder: itemExtentBuilder,
      nodePositionBuilder: nodePositionBuilder,
      indicatorPositionBuilder: indicatorPositionBuilder,
    );
  }

  /// Create a connected tile builder, which builds tiles using each style.
  ///
  /// {@macro timelines.itemExtentBuilder}
  ///
  /// See also:
  ///
  ///  * [TimelineTileBuilder.connected], which builds connected tiles.
  ///  * [TimelineTileBuilder.fromStyle], which builds tiles from style.
  factory TimelineTileBuilder.connectedFromStyle({
    @required required int itemCount,
    ConnectionDirection connectionDirection = ConnectionDirection.after,
    NullableIndexedWidgetBuilder? contentsBuilder,
    NullableIndexedWidgetBuilder? oppositeContentsBuilder,
    ContentsAlign contentsAlign = ContentsAlign.basic,
    IndexedValueBuilder<IndicatorStyle>? indicatorStyleBuilder,
    IndexedValueBuilder<ConnectorStyle>? connectorStyleBuilder,
    ConnectorStyle firstConnectorStyle = ConnectorStyle.solidLine,
    ConnectorStyle lastConnectorStyle = ConnectorStyle.solidLine,
    double? itemExtent,
    IndexedValueBuilder<double>? itemExtentBuilder,
    IndexedValueBuilder<double>? nodePositionBuilder,
    IndexedValueBuilder<double>? indicatorPositionBuilder,
  }) {
    return TimelineTileBuilder(
      itemCount: itemCount,
      contentsAlign: contentsAlign,
      contentsBuilder: contentsBuilder,
      oppositeContentsBuilder: oppositeContentsBuilder,
      indicatorBuilder: (context, index) => _createStyledIndicatorBuilder(
          indicatorStyleBuilder?.call(context, index))(context),
      startConnectorBuilder: _createConnectedStartConnectorBuilder(
        connectionDirection: connectionDirection,
        firstConnectorBuilder: (context) =>
            _createStyledConnectorBuilder(firstConnectorStyle)(context),
        connectorBuilder: (context, index, __) => _createStyledConnectorBuilder(
            connectorStyleBuilder?.call(context, index))(context),
      ),
      endConnectorBuilder: _createConnectedEndConnectorBuilder(
        connectionDirection: connectionDirection,
        lastConnectorBuilder: (context) =>
            _createStyledConnectorBuilder(lastConnectorStyle)(context),
        connectorBuilder: (context, index, __) => _createStyledConnectorBuilder(
            connectorStyleBuilder?.call(context, index))(context),
        itemCount: itemCount,
      ),
      itemExtent: itemExtent,
      itemExtentBuilder: itemExtentBuilder,
      nodePositionBuilder: nodePositionBuilder,
      indicatorPositionBuilder: indicatorPositionBuilder,
    );
  }

  /// Create a tile builder, which builds tiles using each style.
  ///
  /// {@macro timelines.itemExtentBuilder}
  /// TODO: style each index like fromStyleBuilder
  ///
  /// See also:
  ///
  ///  * [IndicatorStyle]
  ///  * [ConnectorStyle]
  ///  * [ContentsAlign]
  factory TimelineTileBuilder.fromStyle({
    required int itemCount,
    NullableIndexedWidgetBuilder? contentsBuilder,
    NullableIndexedWidgetBuilder? oppositeContentsBuilder,
    ContentsAlign contentsAlign = ContentsAlign.basic,
    IndicatorStyle indicatorStyle = IndicatorStyle.dot,
    ConnectorStyle connectorStyle = ConnectorStyle.solidLine,
    ConnectorStyle endConnectorStyle = ConnectorStyle.solidLine,
    double? itemExtent,
    IndexedValueBuilder<double>? itemExtentBuilder,
    IndexedValueBuilder<double>? nodePositionBuilder,
    IndexedValueBuilder<double>? indicatorPositionBuilder,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  }) {
    return TimelineTileBuilder(
      itemCount: itemCount,
      contentsAlign: contentsAlign,
      contentsBuilder: contentsBuilder,
      oppositeContentsBuilder: oppositeContentsBuilder,
      indicatorBuilder: (context, index) =>
          _createStyledIndicatorBuilder(indicatorStyle)(context),
      startConnectorBuilder: (context, _) =>
          _createStyledConnectorBuilder(connectorStyle)(context),
      endConnectorBuilder: (context, _) =>
          _createStyledConnectorBuilder(connectorStyle)(context),
      itemExtent: itemExtent,
      itemExtentBuilder: itemExtentBuilder,
      nodePositionBuilder: nodePositionBuilder,
      indicatorPositionBuilder: indicatorPositionBuilder,
    );
  }

  /// Create a tile builder, which builds tiles using each component builder.
  ///
  /// {@template timelines.itemExtentBuilder}
  /// If each item has a fixed extent, use [itemExtent], and if each item has a
  /// different extent, use [itemExtentBuilder].
  /// {@endtemplate}
  ///
  /// TODO: need refactoring, is it has many builders...?
  factory TimelineTileBuilder({
    required int itemCount,
    ContentsAlign contentsAlign = ContentsAlign.basic,
    NullableIndexedWidgetBuilder? contentsBuilder,
    NullableIndexedWidgetBuilder? oppositeContentsBuilder,
    NullableIndexedWidgetBuilder? indicatorBuilder,
    NullableIndexedWidgetBuilder? startConnectorBuilder,
    NullableIndexedWidgetBuilder? endConnectorBuilder,
    double? itemExtent,
    IndexedValueBuilder<double>? itemExtentBuilder,
    IndexedValueBuilder<double>? nodePositionBuilder,
    IndexedValueBuilder<bool?>? nodeItemOverlapBuilder,
    IndexedValueBuilder<double>? indicatorPositionBuilder,
    IndexedValueBuilder<TimelineThemeData>? themeBuilder,
  }) {
    assert(
      itemExtent == null || itemExtentBuilder == null,
      'Cannot provide both a itemExtent and a itemExtentBuilder.',
    );

    final effectiveContentsBuilder = _createAlignedContentsBuilder(
      align: contentsAlign,
      contentsBuilder: contentsBuilder,
      oppositeContentsBuilder: oppositeContentsBuilder,
    );
    final effectiveOppositeContentsBuilder = _createAlignedContentsBuilder(
      align: contentsAlign,
      contentsBuilder: oppositeContentsBuilder,
      oppositeContentsBuilder: contentsBuilder,
    );

    return TimelineTileBuilder._(
      (context, index) {
        final tile = TimelineTile(
          mainAxisExtent: itemExtent ?? itemExtentBuilder?.call(context, index),
          node: TimelineNode(
            indicator: indicatorBuilder?.call(context, index) ??
                Indicator.transparent(),
            startConnector: startConnectorBuilder?.call(context, index),
            endConnector: endConnectorBuilder?.call(context, index),
            overlap: nodeItemOverlapBuilder?.call(context, index),
            position: nodePositionBuilder?.call(context, index),
            indicatorPosition: indicatorPositionBuilder?.call(context, index),
          ),
          contents: effectiveContentsBuilder(context, index),
          oppositeContents: effectiveOppositeContentsBuilder(context, index),
        );

        final theme = themeBuilder?.call(context, index);
        if (theme != null) {
          return TimelineTheme(
            data: theme,
            child: tile,
          );
        } else {
          return tile;
        }
      },
      itemCount: itemCount,
    );
  }

  const TimelineTileBuilder._(
    this._builder, {
    required this.itemCount,
  }) : assert(itemCount >= 0);

  final IndexedWidgetBuilder _builder;
  final int itemCount;

  Widget build(BuildContext context, int index) {
    return _builder(context, index);
  }

  static NullableIndexedWidgetBuilder _createConnectedStartConnectorBuilder({
    ConnectionDirection? connectionDirection,
    WidgetBuilder? firstConnectorBuilder,
    ConnectedConnectorBuilder? connectorBuilder,
  }) =>
      (context, index) {
        if (index == 0) {
          if (firstConnectorBuilder != null) {
            return firstConnectorBuilder.call(context);
          } else {
            return null;
          }
        }

        if (connectionDirection == ConnectionDirection.before) {
          return connectorBuilder?.call(context, index, ConnectorType.start);
        } else {
          return connectorBuilder?.call(
              context, index - 1, ConnectorType.start);
        }
      };

  static NullableIndexedWidgetBuilder _createConnectedEndConnectorBuilder({
    ConnectionDirection? connectionDirection,
    WidgetBuilder? lastConnectorBuilder,
    ConnectedConnectorBuilder? connectorBuilder,
    required int itemCount,
  }) =>
      (context, index) {
        if (index == itemCount - 1) {
          if (lastConnectorBuilder != null) {
            return lastConnectorBuilder.call(context);
          } else {
            return null;
          }
        }

        if (connectionDirection == ConnectionDirection.before) {
          return connectorBuilder?.call(context, index + 1, ConnectorType.end);
        } else {
          return connectorBuilder?.call(context, index, ConnectorType.end);
        }
      };

  static NullableIndexedWidgetBuilder _createAlignedContentsBuilder({
    required ContentsAlign align,
    NullableIndexedWidgetBuilder? contentsBuilder,
    NullableIndexedWidgetBuilder? oppositeContentsBuilder,
  }) {
    return (context, index) {
      switch (align) {
        case ContentsAlign.alternating:
          if (index.isOdd) {
            return oppositeContentsBuilder?.call(context, index);
          }

          return contentsBuilder?.call(context, index);
        case ContentsAlign.reverse:
          return oppositeContentsBuilder?.call(context, index);
        case ContentsAlign.basic:
        default:
          return contentsBuilder?.call(context, index);
      }
    };
  }

  static WidgetBuilder _createStyledIndicatorBuilder(IndicatorStyle? style) {
    return (_) {
      switch (style) {
        case IndicatorStyle.dot:
          return Indicator.dot();
        case IndicatorStyle.outlined:
          return Indicator.outlined();
        case IndicatorStyle.container:
          return Indicator.widget();
        case IndicatorStyle.transparent:
        default:
          return Indicator.transparent();
      }
    };
  }

  static WidgetBuilder _createStyledConnectorBuilder(ConnectorStyle? style) {
    return (_) {
      switch (style) {
        case ConnectorStyle.solidLine:
          return Connector.solidLine();
        case ConnectorStyle.dashedLine:
          return Connector.dashedLine();
        case ConnectorStyle.transparent:
        default:
          return Connector.transparent();
      }
    };
  }
}

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

/// The widgets returned from the builder callback are automatically wrapped in
/// [AutomaticKeepAlive] widgets if [addAutomaticKeepAlives] is true
/// (the default) and in [RepaintBoundary] widgets if [addRepaintBoundaries] is
/// true (also the default).
///
/// ## Accessibility
///
/// The [CustomScrollView] requires that its semantic children are annotated
/// using [IndexedSemantics]. This is done by default in the delegate with the
/// `addSemanticIndexes` parameter set to true.
///
/// If multiple delegates are used in a single scroll view, then the indexes
/// will not be correct by default. The `semanticIndexOffset` can be used to
/// offset the semantic indexes of each delegate so that the indexes are
/// monotonically increasing. For example, if a scroll view contains two
/// delegates where the first has 10 children contributing semantics, then the
/// second delegate should offset its children by 10.
///
/// See also:
///
///  * [IndexedSemantics], for an example of manually annotating child nodes
///  with semantic indexes.
class TimelineTileBuilderDelegate extends SliverChildBuilderDelegate {
  TimelineTileBuilderDelegate(
    NullableIndexedWidgetBuilder builder, {
    ChildIndexGetter? findChildIndexCallback,
    int? childCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    SemanticIndexCallback semanticIndexCallback =
        _kDefaultSemanticIndexCallback,
    int semanticIndexOffset = 0,
  }) : super(
          builder,
          findChildIndexCallback: findChildIndexCallback,
          childCount: childCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset,
        );
}

/// A scrollable timeline of widgets arranged linearly.
class Timeline extends BoxScrollView {
  /// Creates a scrollable, linear array of widgets that are created on demand.
  ///
  /// This constructor is appropriate for list views with a large (or infinite)
  /// number of children because the builder is called only for those children
  /// that are actually visible.
  ///
  /// Providing a non-null `itemCount` improves the ability of the [Timeline] to
  /// estimate the maximum scroll extent.
  ///
  /// The `itemBuilder` callback will be called only with indices greater than
  /// or equal to zero and less than `itemCount`.
  ///
  /// The `itemBuilder` should always return a non-null widget, and actually
  /// create the widget instances when called.
  /// Avoid using a builder that returns a previously-constructed widget; if the
  /// timeline view's children are created in advance, or all at once when the
  /// [Timeline] itself is created, it is more efficient to use the [Timeline]
  /// constructor. Even more efficient, however, is to create the instances on
  /// demand using this constructor's `itemBuilder` callback.
  ///
  /// The `addAutomaticKeepAlives` argument corresponds to the
  /// [SliverChildBuilderDelegate.addAutomaticKeepAlives] property. The
  /// `addRepaintBoundaries` argument corresponds to the
  /// [SliverChildBuilderDelegate.addRepaintBoundaries] property. The
  /// `addSemanticIndexes` argument corresponds to the
  /// [SliverChildBuilderDelegate.addSemanticIndexes] property. None
  /// may be null.
  ///
  /// [Timeline.builder] by default does not support child reordering. If you
  /// are planning to change child order at a
  /// later time, consider using [Timeline] or [Timeline.custom].
  factory Timeline.tileBuilder({
    Key? key,
    required TimelineTileBuilder builder,
    Axis? scrollDirection,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double itemExtent = 0.0,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    TimelineThemeData? theme,
  }) {
    assert(builder.itemCount >= 0);
    assert(
        semanticChildCount == null || semanticChildCount <= builder.itemCount);
    return Timeline.custom(
      key: key,
      childrenDelegate: SliverChildBuilderDelegate(
        builder.build,
        childCount: builder.itemCount,
        // TODO: apply some fields if needed.
      ),
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemExtent: itemExtent,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount ?? builder.itemCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      theme: theme,
    );
  }

  /// Creates a scrollable, linear array of widgets from an explicit [List].
  ///
  /// This constructor is appropriate for timeline views with a small number of
  /// children because constructing the [List] requires doing work for every
  /// child that could possibly be displayed in the timeline view instead of
  /// just those children that are actually visible.
  ///
  /// It is usually more efficient to create children on demand using
  /// [Timeline.builder] because it will create the widget children lazily as
  /// necessary.
  ///
  /// The `addAutomaticKeepAlives` argument corresponds to the
  /// [SliverChildListDelegate.addAutomaticKeepAlives] property. The
  /// `addRepaintBoundaries` argument corresponds to the
  /// [SliverChildListDelegate.addRepaintBoundaries] property. The
  /// `addSemanticIndexes` argument corresponds to the
  /// [SliverChildListDelegate.addSemanticIndexes] property. None may be null.
  Timeline({
    Key? key,
    Axis? scrollDirection,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    this.itemExtent,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    List<Widget> children = const <Widget>[],
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    TimelineThemeData? theme,
  })  : childrenDelegate = SliverChildListDelegate(
          children,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        ),
        assert(scrollDirection == null || theme == null,
            'Cannot provide both a scrollDirection and a theme.'),
        this.theme = theme,
        super(
          key: key,
          scrollDirection: scrollDirection ?? theme?.direction ?? Axis.vertical,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount ?? children.length,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  /// Creates a scrollable, linear array of widgets that are created on demand.
  ///
  /// This constructor is appropriate for list views with a large (or infinite)
  /// number of children because the builder is called only for those children
  /// that are actually visible.
  ///
  /// Providing a non-null `itemCount` improves the ability of the [Timeline] to
  /// estimate the maximum scroll extent.
  ///
  /// The `itemBuilder` callback will be called only with indices greater than
  /// or equal to zero and less than `itemCount`.
  ///
  /// The `itemBuilder` should always return a non-null widget, and actually
  /// create the widget instances when called.
  /// Avoid using a builder that returns a previously-constructed widget; if the
  /// timeline view's children are created in advance, or all at once when the
  /// [Timeline] itself is created, it is more efficient to use the [Timeline]
  /// constructor. Even more efficient, however, is to create the instances on
  /// demand using this constructor's `itemBuilder` callback.
  ///
  /// The `addAutomaticKeepAlives` argument corresponds to the
  /// [SliverChildBuilderDelegate.addAutomaticKeepAlives] property. The
  /// `addRepaintBoundaries` argument corresponds to the
  /// [SliverChildBuilderDelegate.addRepaintBoundaries] property. The
  /// `addSemanticIndexes` argument corresponds to the
  /// [SliverChildBuilderDelegate.addSemanticIndexes] property. None
  /// may be null.
  ///
  /// [Timeline.builder] by default does not support child reordering. If you
  /// are planning to change child order at a
  /// later time, consider using [Timeline] or [Timeline.custom].
  Timeline.builder({
    Key? key,
    Axis? scrollDirection,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    this.itemExtent,
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    TimelineThemeData? theme,
  })  : assert(itemCount >= 0),
        assert(semanticChildCount == null || semanticChildCount <= itemCount),
        assert(scrollDirection == null || theme == null,
            'Cannot provide both a scrollDirection and a theme.'),
        childrenDelegate = SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        ),
        this.theme = theme,
        super(
          key: key,
          scrollDirection: scrollDirection ?? theme?.direction ?? Axis.vertical,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount ?? itemCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  /// Creates a scrollable, linear array of widgets with a custom child model.
  ///
  /// For example, a custom child model can control the algorithm used to
  /// estimate the size of children that are not actually visible.
  ///
  /// See also:
  ///
  ///  * This works similarly to [ListView.custom].
  Timeline.custom({
    Key? key,
    Axis? scrollDirection,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    this.itemExtent,
    required this.childrenDelegate,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    TimelineThemeData? theme,
  })  : assert(scrollDirection == null || theme == null,
            'Cannot provide both a scrollDirection and a theme.'),
        this.theme = theme,
        super(
          key: key,
          scrollDirection: scrollDirection ?? theme?.direction ?? Axis.vertical,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  /// If non-null, forces the children to have the given extent in the scroll
  /// direction.
  ///
  /// Specifying an [itemExtent] is more efficient than letting the children
  /// determine their own extent because the scrolling machinery can make use
  /// of the foreknowledge of the children's extent to save work, for example
  /// when the scroll position changes drastically.
  final double? itemExtent;

  /// A delegate that provides the children for the [Timeline].
  ///
  /// The [Timeline.custom] constructor lets you specify this delegate
  /// explicitly. The [Timeline] and [Timeline.builder] constructors create a
  /// [childrenDelegate] that wraps the given [List] and [IndexedWidgetBuilder],
  /// respectively.
  final SliverChildDelegate childrenDelegate;

  /// Default visual properties, like colors, size and spaces, for this
  /// timeline's component widgets.
  ///
  /// The default value of this property is the value of
  /// [TimelineThemeData.vertical()].
  final TimelineThemeData? theme;

  @override
  Widget buildChildLayout(BuildContext context) {
    Widget result;
    if (itemExtent != null) {
      result = SliverFixedExtentList(
        delegate: childrenDelegate,
        itemExtent: itemExtent!,
      );
    } else {
      result = SliverList(delegate: childrenDelegate);
    }

    var theme;
    if (this.theme != null) {
      theme = this.theme;
    } else if (scrollDirection != TimelineTheme.of(context).direction) {
      theme = TimelineTheme.of(context).copyWith(direction: scrollDirection);
    }

    if (theme != null) {
      return TimelineTheme(
        data: theme,
        child: result,
      );
    } else {
      return result;
    }
  }
}

/// A widget that displays its children in a one-dimensional array with
/// timeline theme.
class FixedTimeline extends StatelessWidget {
  /// Creates a timeline flex layout.
  factory FixedTimeline.tileBuilder({
    Key? key,
    required TimelineTileBuilder builder,
    TimelineThemeData? theme,
    Axis? direction,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    Clip clipBehavior = Clip.none,
  }) {
    // TODO: how remove Builders?
    return FixedTimeline(
      children: [
        for (int i = 0; i < builder.itemCount; i++)
          Builder(
            builder: (context) => builder.build(context, i),
          ),
      ],
      theme: theme,
      direction: direction,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior,
    );
  }

  /// Creates a timeline flex layout.
  ///
  /// The [direction], [verticalDirection] arguments must not be null.
  ///
  /// The [textDirection] argument defaults to the ambient [Directionality],
  /// if any. If there is no ambient directionality, and a text direction is
  /// going to be necessary to decide which direction to lay the children in or
  /// to disambiguate `start` or `end` values for the main or cross axis
  /// directions, the [textDirection] must not be null.
  const FixedTimeline({
    Key? key,
    this.theme,
    this.direction,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    this.children = const [],
  })  : assert(direction == null || theme == null,
            'Cannot provide both a direction and a theme.'),
        super(key: key);

  /// Default visual properties, like colors, size and spaces, for this
  /// timeline's component widgets.
  ///
  /// The default value of this property is the value of
  /// [TimelineThemeData.vertical()].
  final TimelineThemeData? theme;

  /// The direction to use as the main axis.
  final Axis? direction;

  /// The widgets below this widget in the tree.
  ///
  /// If this list is going to be mutated, it is usually wise to put a [Key] on
  /// each of the child widgets, so that the framework can match old
  /// configurations to new configurations and maintain the underlying
  /// render objects.
  ///
  /// See also:
  ///
  ///  * [MultiChildRenderObjectWidget.children]
  final List<Widget> children;

  /// How much space should be occupied in the main axis.
  ///
  /// After allocating space to children, there might be some remaining free
  /// space. This value controls whether to maximize or minimize the amount of
  /// free space, subject to the incoming layout constraints.
  ///
  /// If some children have a non-zero flex factors (and none have a fit of
  /// [FlexFit.loose]), they will expand to consume all the available space and
  /// there will be no remaining free space to maximize or minimize, making this
  /// value irrelevant to the final layout.
  final MainAxisSize mainAxisSize;

  /// Determines the order to lay children out horizontally and how to interpret
  /// `start` and `end` in the horizontal direction.
  ///
  /// Defaults to the ambient [Directionality].
  ///
  /// If [textDirection] is [TextDirection.rtl], then the direction in which
  /// text flows starts from right to left. Otherwise, if [textDirection] is
  /// [TextDirection.ltr], then the direction in which text flows starts from
  /// left to right.
  ///
  /// If the [direction] is [Axis.horizontal], this controls the order in which
  /// the children are positioned (left-to-right or right-to-left).
  ///
  /// If the [direction] is [Axis.horizontal], and there's more than one child,
  /// then the [textDirection] (or the ambient [Directionality]) must not
  /// be null.
  final TextDirection? textDirection;

  /// Determines the order to lay children out vertically and how to interpret
  /// `start` and `end` in the vertical direction.
  ///
  /// Defaults to [VerticalDirection.down].
  ///
  /// If the [direction] is [Axis.vertical], there's more than one child, then
  /// the [verticalDirection] must not be null.
  final VerticalDirection verticalDirection;

  /// The content will be clipped (or not) according to this option.
  ///
  /// See the enum Clip for details of all possible options and their common
  /// use cases.
  ///
  /// Defaults to [Clip.none].
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final direction = this.direction ?? this.theme?.direction ?? Axis.vertical;

    Widget result = Flex(
      direction: direction,
      children: children,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior,
    );

    var theme;
    if (this.direction != null) {
      if (direction != TimelineTheme.of(context).direction) {
        theme = TimelineTheme.of(context).copyWith(direction: this.direction);
      }
    } else if (this.theme != null) {
      theme = this.theme;
    }

    if (theme != null) {
      return TimelineTheme(
        data: theme,
        child: result,
      );
    } else {
      return result;
    }
  }
}
