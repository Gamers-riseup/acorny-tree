import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class StatusBarStyler extends StatelessWidget {
  const StatusBarStyler({
    Key? key,
    required this.child,
    this.brightness,
    this.transparent = true,
  }) : super(key: key);

  final Widget child;
  final Brightness? brightness;
  final bool transparent;

  @override
  Widget build(BuildContext context) {
    final effectiveBrightness = brightness ?? Theme.of(context).brightness;

    // SystemUiOverlayStyle brightness refers to the text, rather than the
    // actual theme brightness
    var style = effectiveBrightness == Brightness.light
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;

    if (transparent) {
      style = style.copyWith(
        statusBarColor: Colors.transparent,
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: style,
      child: child,
    );
  }
}

class TreeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const TreeAppbar({
    Key? key,
    this.leading,
    this.title,
    this.trailing = const [],
    this.bottom,
    this.sliver = true,
    required this.color,
  }) : super(key: key);

  final Widget? leading;
  final Widget? title;
  final List<Widget> trailing;
  final PreferredSizeWidget? bottom;
  final bool sliver;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    Widget appBar = Stack(
      children: [
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.9),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: mq.padding.top + 8.0,
            left: 8.0,
            right: 8.0,
            bottom: 8.0,
          ),
          child: NavigationToolbar(
            leading: leading ??
                (Navigator.of(context).canPop()
                    ? const TreeBackButton()
                    : null),
            middle: title == null
                ? null
                : DefaultTextStyle(
                    style: GoogleFonts.pressStart2p(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                    child: title!,
                  ),
            trailing: trailing.isEmpty
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: trailing,
                  ),
          ),
        ),
      ],
    );

    appBar = StatusBarStyler(brightness: Brightness.dark, child: appBar);

    if (sliver) {
      return SliverPersistentHeader(
        floating: false,
        pinned: true,
        delegate: _LittyAppBarDelegate(
          topPadding: MediaQuery.of(context).padding.top,
          body: appBar,
          bottom: bottom,
        ),
      );
    } else {
      return SizedBox(
        height: kToolbarHeight +
            (bottom?.preferredSize.height ?? 0) +
            mq.padding.top,
        child: appBar,
      );
    }
  }

  static const navHeight = kToolbarHeight;

  @override
  Size get preferredSize => const Size.fromHeight(navHeight);
}

class _LittyAppBarDelegate extends SliverPersistentHeaderDelegate {
  _LittyAppBarDelegate({
    required this.topPadding,
    required this.body,
    this.bottom,
  });

  final double topPadding;
  final Widget body;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      children: [
        Expanded(child: body),
        if (bottom != null)
          SizedBox(
            height: bottom!.preferredSize.height,
            child: bottom,
          ),
      ],
    );
  }

  double get bottomExtent => bottom == null ? 0 : bottom!.preferredSize.height;

  @override
  double get minExtent => TreeAppbar.navHeight + topPadding + bottomExtent;

  @override
  double get maxExtent => minExtent;

  @override
  bool shouldRebuild(_LittyAppBarDelegate old) =>
      old.topPadding != topPadding || old.body != body;
}

class TreeBackButton extends StatelessWidget {
  const TreeBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(LineIcons.angleLeft),
    );
  }
}
