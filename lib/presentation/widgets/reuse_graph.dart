import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';

/// **The signature element.**
///
/// One module Ahmed built, and the apps that now import it. The edges route
/// themselves outward on load — a bright head travelling the wire, each
/// consumer landing as its trace arrives — because propagation *is* the claim
/// the page is making. Hovering sends another signal down the wires.
///
/// This is the only place on the page that spends motion loudly. Everything
/// around it stays still.
///
/// Sizing comes from the box the graph is handed, not from the window — it
/// sits inside a card inside a section, so the page breakpoint says nothing
/// useful about how much room it actually has.
class ReuseGraph extends StatefulWidget {
  const ReuseGraph({
    super.key,
    required this.play,
    required this.source,
    required this.sourceKicker,
    required this.consumers,
    required this.description,
  });

  /// Flip to true to route the graph.
  final bool play;

  /// The module at the root of the fan.
  final String source;

  /// Small mono line above [source].
  final String sourceKicker;

  /// What imports it, top to bottom.
  final List<String> consumers;

  /// Spoken instead of the diagram by a screen reader.
  final String description;

  @override
  State<ReuseGraph> createState() => _ReuseGraphState();
}

class _ReuseGraphState extends State<ReuseGraph> with TickerProviderStateMixin {
  /// Routes the graph, once.
  late final AnimationController _route = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );

  /// Sends a signal down the finished wires. Runs on load, then on hover.
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  /// Entry animations, built once per consumer list rather than per frame —
  /// `CurvedAnimation`s need disposing.
  late CurvedAnimation _sourceEntry;
  late List<CurvedAnimation> _nodeEntries;

  bool _hovered = false;

  /// Fraction of the route timeline before the first edge starts drawing.
  static const double _edgeStart = 0.16;
  static const double _edgeStep = 0.07;
  static const double _edgeSpan = 0.34;

  /// Width below which the graph switches to its compact metrics.
  static const double _tightWidth = 340;

  @override
  void initState() {
    super.initState();
    _sourceEntry = CurvedAnimation(
      parent: _route,
      curve: const Interval(0, 0.16, curve: Motion.enter),
    );
    _buildNodeEntries();
    _pulse.addStatusListener(_onPulseComplete);
    _route.addStatusListener(_onRouteComplete);
  }

  void _buildNodeEntries() {
    _nodeEntries = <CurvedAnimation>[
      for (int i = 0; i < widget.consumers.length; i++)
        CurvedAnimation(parent: _route, curve: _nodeInterval(i)),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(covariant ReuseGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.consumers.length != oldWidget.consumers.length) {
      for (final CurvedAnimation entry in _nodeEntries) {
        entry.dispose();
      }
      _buildNodeEntries();
    }
    _sync();
  }

  void _sync() {
    if (!widget.play) return;
    if (Motion.isReduced(context)) {
      _route.value = 1;
      _pulse.value = 0;
    } else if (!_route.isAnimating && _route.value != 1) {
      _route.forward();
    }
  }

  void _onRouteComplete(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    if (!mounted || Motion.isReduced(context)) return;
    _pulse.forward(from: 0);
  }

  void _onPulseComplete(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    if (!mounted || !_hovered || Motion.isReduced(context)) return;
    _pulse.forward(from: 0);
  }

  void _onHover(bool hovered) {
    _hovered = hovered;
    if (!hovered || Motion.isReduced(context)) return;
    if (_route.value == 1 && !_pulse.isAnimating) _pulse.forward(from: 0);
  }

  /// Timeline window during which edge [index] draws.
  Interval _edgeInterval(int index) => Interval(
        _edgeStart + _edgeStep * index,
        math.min(1, _edgeStart + _edgeStep * index + _edgeSpan),
        curve: Motion.emphasized,
      );

  /// Consumer [index] lands just as its trace arrives.
  Interval _nodeInterval(int index) {
    final double start = _edgeStart + _edgeStep * index + _edgeSpan * 0.72;
    return Interval(
      math.min(0.98, start),
      math.min(1, start + 0.16),
      curve: Motion.enter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;

    return Semantics(
      label: widget.description,
      excludeSemantics: true,
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double width = constraints.maxWidth;
            // Below this the fan has to give up padding and type size to keep
            // a readable horizontal run.
            final bool tight = width < _tightWidth;
            final double rowHeight = tight ? 46 : 56;
            final double labelSize = tight ? 10.5 : 12;
            final double nodePadding =
                tight ? AppDimens.spaceSm : AppDimens.spaceMd;

            final double sourceWidth = math.min(158, width * 0.38);
            // The fan needs a real horizontal run to read as routing rather
            // than as a bracket.
            final double destLeft =
                sourceWidth + math.max(tight ? 44 : 56, width * 0.18);
            final double height = widget.consumers.length * rowHeight;
            final double sourceY = height / 2;

            final Offset sourceAnchor = Offset(sourceWidth + 4, sourceY);
            final List<Offset> destAnchors = <Offset>[
              for (int i = 0; i < widget.consumers.length; i++)
                Offset(destLeft - 6, rowHeight * i + rowHeight / 2),
            ];

            return SizedBox(
              width: width,
              height: height,
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  // Traces sit behind the nodes and repaint on their own.
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: AnimatedBuilder(
                        animation: Listenable.merge(<Listenable>[
                          _route,
                          _pulse,
                        ]),
                        builder: (BuildContext context, _) => CustomPaint(
                          painter: _TracePainter(
                            source: sourceAnchor,
                            destinations: destAnchors,
                            progress: _route.value,
                            pulse: _pulse.isAnimating ? _pulse.value : null,
                            idleColor: tokens.rule,
                            signalColor: tokens.signal,
                            edgeInterval: _edgeInterval,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── Source module ──────────────────────────────────────
                  Positioned(
                    left: 0,
                    top: sourceY - 34,
                    width: sourceWidth,
                    child: StaggeredEntry(
                      animation: _sourceEntry,
                      rise: 8,
                      child: _SourceNode(
                        label: widget.source,
                        kicker: widget.sourceKicker,
                        labelSize: labelSize,
                      ),
                    ),
                  ),

                  // ── Consumers ──────────────────────────────────────────
                  for (int i = 0; i < widget.consumers.length; i++)
                    Positioned(
                      left: destLeft,
                      top: rowHeight * i + rowHeight / 2 - 15,
                      child: StaggeredEntry(
                        animation: _nodeEntries[i],
                        rise: 6,
                        child: _ConsumerNode(
                          label: widget.consumers[i],
                          labelSize: labelSize,
                          horizontalPadding: nodePadding,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _route.removeStatusListener(_onRouteComplete);
    _pulse.removeStatusListener(_onPulseComplete);
    _sourceEntry.dispose();
    for (final CurvedAnimation entry in _nodeEntries) {
      entry.dispose();
    }
    _route.dispose();
    _pulse.dispose();
    super.dispose();
  }
}

class _SourceNode extends StatelessWidget {
  const _SourceNode({
    required this.label,
    required this.kicker,
    required this.labelSize,
  });

  final String label;
  final String kicker;
  final double labelSize;

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;

    return Column(
      // Stretches to the full node width so the traces leave the module's
      // edge instead of floating away from it.
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          kicker.toUpperCase(),
          style: context.type.labelSmall?.copyWith(color: tokens.inkMuted),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: tokens.signal,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: context.type.labelLarge?.copyWith(
              color: tokens.onSignal,
              fontSize: labelSize + 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ConsumerNode extends StatelessWidget {
  const _ConsumerNode({
    required this.label,
    required this.labelSize,
    required this.horizontalPadding,
  });

  final String label;
  final double labelSize;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: AppDimens.spaceSm,
      ),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        border: Border.all(color: tokens.rule),
      ),
      child: Text(
        label,
        style: context.type.labelMedium?.copyWith(
          color: tokens.ink,
          fontSize: labelSize,
        ),
      ),
    );
  }
}

/// Paints the routed edges: a settled hairline behind, a bright head at the
/// drawing tip, and an optional signal travelling the finished wire.
class _TracePainter extends CustomPainter {
  const _TracePainter({
    required this.source,
    required this.destinations,
    required this.progress,
    required this.pulse,
    required this.idleColor,
    required this.signalColor,
    required this.edgeInterval,
  });

  final Offset source;
  final List<Offset> destinations;

  /// Routing progress, 0–1.
  final double progress;

  /// Signal position, 0–1, or null when no signal is travelling.
  final double? pulse;

  final Color idleColor;
  final Color signalColor;
  final Interval Function(int index) edgeInterval;

  /// Length of the bright leading segment, in logical pixels.
  static const double _headLength = 26;

  /// How far apart the per-edge signals are staggered, as a timeline fraction.
  static const double _pulseStep = 0.09;

  Path _edgePath(Offset from, Offset to) {
    final double midX = (from.dx + to.dx) / 2;
    return Path()
      ..moveTo(from.dx, from.dy)
      ..cubicTo(midX, from.dy, midX, to.dy, to.dx, to.dy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trace = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..color = idleColor;

    final Paint live = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = signalColor;

    final Paint dot = Paint()..color = signalColor;

    for (int i = 0; i < destinations.length; i++) {
      final double t = edgeInterval(i).transform(progress.clamp(0, 1));
      if (t <= 0) continue;

      final Path path = _edgePath(source, destinations[i]);
      final metric = path.computeMetrics().first;
      final double drawn = metric.length * t;

      // Settled hairline, as far as the edge has routed.
      canvas.drawPath(metric.extractPath(0, drawn), trace);

      if (t < 1) {
        // Bright head leading the route.
        canvas.drawPath(
          metric.extractPath(math.max(0, drawn - _headLength), drawn),
          live,
        );
        canvas.drawCircle(
          metric.getTangentForOffset(drawn)?.position ?? destinations[i],
          3,
          dot,
        );
      } else {
        // Landed: a small terminal marker.
        canvas.drawCircle(destinations[i], 2.5, dot);

        final double? p = pulse;
        if (p != null) {
          final double local =
              ((p - _pulseStep * i) / (1 - _pulseStep * 3)).clamp(0.0, 1.0);
          if (local > 0 && local < 1) {
            final double at = metric.length * local;
            canvas.drawPath(
              metric.extractPath(math.max(0, at - _headLength), at),
              live,
            );
            canvas.drawCircle(
              metric.getTangentForOffset(at)?.position ?? destinations[i],
              3.5,
              dot,
            );
          }
        }
      }
    }

    // Source terminal.
    canvas.drawCircle(source, 3, dot);
  }

  @override
  bool shouldRepaint(covariant _TracePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pulse != pulse ||
        oldDelegate.source != source ||
        oldDelegate.destinations != destinations ||
        oldDelegate.idleColor != idleColor ||
        oldDelegate.signalColor != signalColor;
  }
}
