import 'package:flutter/material.dart';

class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1200;
  static const double desktop = 1200;
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < Breakpoints.mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= Breakpoints.mobile && width < Breakpoints.tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= Breakpoints.desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.desktop && desktop != null) {
          return desktop!;
        }
        if (constraints.maxWidth >= Breakpoints.mobile && tablet != null) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}

// Responsive value helper
class Responsive<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  const Responsive({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  T of(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= Breakpoints.desktop && desktop != null) return desktop as T;
    if (width >= Breakpoints.mobile && tablet != null) return tablet as T;
    return mobile;
  }
}

// Responsive padding
EdgeInsets responsivePadding(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= Breakpoints.desktop) {
    return EdgeInsets.symmetric(
      horizontal: (width - 1200) / 2 + 32,
      vertical: 0,
    );
  }
  if (width >= Breakpoints.mobile) {
    return const EdgeInsets.symmetric(horizontal: 32);
  }
  return const EdgeInsets.symmetric(horizontal: 16);
}

// Max content width wrapper
class MaxWidthBox extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  const MaxWidthBox({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}