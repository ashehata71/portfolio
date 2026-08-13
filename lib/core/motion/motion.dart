import 'package:flutter/material.dart';

/// The page's motion vocabulary.
///
/// Three idioms, and only three:
///
/// 1. **Propagate** — the hero reuse graph routes its edges outward and sends a
///    signal down them. This is the signature; the boldest motion lives here.
/// 2. **Stagger** — page load and section reveal. Children enter off a single
///    controller with `Interval`s, never a pile of independent timers.
/// 3. **Respond** — hover, focus and press. Under [fast], driven by a
///    controller so it can interrupt itself cleanly.
///
/// Every one of them collapses to its final state instantly when the platform
/// asks for reduced motion.
abstract final class Motion {
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration base = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 620);
  static const Duration stagger = Duration(milliseconds: 85);

  /// Entry curve shared by every staggered reveal, so the whole page moves on
  /// one rhythm.
  static const Curve enter = Curves.easeOutCubic;

  /// Sharper curve for interaction feedback and the routed edges.
  static const Curve emphasized = Cubic(0.2, 0, 0, 1);

  /// True when the platform (OS setting, or `prefers-reduced-motion` on web)
  /// has asked for animation to be turned off.
  static bool isReduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  /// [duration], or zero when motion is reduced.
  static Duration resolve(BuildContext context, Duration duration) =>
      isReduced(context) ? Duration.zero : duration;
}

/// Reveals [children] in sequence off one [AnimationController]: each child
/// fades up through [rise] logical pixels on [Motion.enter], offset from its
/// predecessor by [stagger].
///
/// Set [play] to start. The reveal is one-way — children never re-hide.
class StaggeredGroup extends StatefulWidget {
  const StaggeredGroup({
    super.key,
    required this.play,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.itemDuration = Motion.slow,
    this.stagger = Motion.stagger,
    this.initialDelay = Duration.zero,
    this.rise = 20,
    this.layout,
  });

  /// Flip to true to run the reveal.
  final bool play;

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;

  /// How long a single child takes to arrive.
  final Duration itemDuration;

  /// Gap between one child starting and the next.
  final Duration stagger;

  /// Held before the first child moves — lets a section header land first.
  final Duration initialDelay;

  /// Distance each child travels upward as it fades in.
  final double rise;

  /// How the revealed children are arranged. Defaults to a `Column`; pass a
  /// `Wrap` builder for chip clusters so they assemble piece by piece.
  final Widget Function(List<Widget> children)? layout;

  @override
  State<StaggeredGroup> createState() => _StaggeredGroupState();
}

class _StaggeredGroupState extends State<StaggeredGroup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _totalDuration,
  );
  List<CurvedAnimation> _entries = <CurvedAnimation>[];

  Duration get _totalDuration {
    final int count = widget.children.length;
    if (count == 0) return widget.itemDuration;
    return widget.initialDelay +
        widget.itemDuration +
        widget.stagger * (count - 1);
  }

  @override
  void initState() {
    super.initState();
    _buildEntries();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(covariant StaggeredGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children.length != oldWidget.children.length ||
        widget.itemDuration != oldWidget.itemDuration ||
        widget.stagger != oldWidget.stagger ||
        widget.initialDelay != oldWidget.initialDelay) {
      _controller.duration = _totalDuration;
      _buildEntries();
    }
    _sync();
  }

  /// Runs, jumps, or waits depending on [StaggeredGroup.play] and whether the
  /// platform wants reduced motion.
  void _sync() {
    if (!widget.play) return;
    if (Motion.isReduced(context)) {
      _controller.value = 1;
    } else if (!_controller.isAnimating && _controller.value != 1) {
      _controller.forward();
    }
  }

  void _buildEntries() {
    for (final CurvedAnimation entry in _entries) {
      entry.dispose();
    }
    final double total = _totalDuration.inMicroseconds.toDouble();
    final double delay = widget.initialDelay.inMicroseconds / total;
    final double step = widget.stagger.inMicroseconds / total;
    final double span = widget.itemDuration.inMicroseconds / total;

    _entries = <CurvedAnimation>[
      for (int i = 0; i < widget.children.length; i++)
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            (delay + step * i).clamp(0, 1),
            (delay + step * i + span).clamp(0, 1),
            curve: Motion.enter,
          ),
        ),
    ];
  }

  @override
  void dispose() {
    for (final CurvedAnimation entry in _entries) {
      entry.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> revealed = <Widget>[
      for (int i = 0; i < widget.children.length; i++)
        StaggeredEntry(
          animation: _entries[i],
          rise: widget.rise,
          child: widget.children[i],
        ),
    ];

    final Widget Function(List<Widget>)? layout = widget.layout;
    if (layout != null) return layout(revealed);

    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: revealed,
    );
  }
}

/// A single fade-and-rise entry. Kept public so bespoke layouts (the hero's
/// two-column split, for one) can drive entries off their own controller
/// without re-implementing the idiom.
class StaggeredEntry extends StatelessWidget {
  const StaggeredEntry({
    super.key,
    required this.animation,
    required this.child,
    this.rise = 20,
  });

  final Animation<double> animation;
  final double rise;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      // Content stays in the semantics tree even at zero opacity. Without
      // this, a screen reader cannot reach any section whose scroll-triggered
      // reveal has not run yet.
      alwaysIncludeSemantics: true,
      // `child` is passed through so the subtree below never rebuilds per
      // frame — only the transform does.
      child: AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (BuildContext context, Widget? child) => Transform.translate(
          offset: Offset(0, rise * (1 - animation.value)),
          child: child,
        ),
      ),
    );
  }
}
