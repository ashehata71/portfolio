import 'package:flutter/material.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';

/// The datasheet section break, shared by every section so vertical rhythm and
/// heading treatment stay identical.
///
/// Anatomy, top to bottom: a heavy rule that draws left-to-right as the
/// section arrives, then the title in the display face with an optional mono
/// [meta] datum pinned to the right, then the content.
///
/// [meta] must carry something true — a span of years, a count of shipped
/// products. It is information, not ornament; leave it null when there is
/// nothing honest to put there.
class SectionWrapper extends StatefulWidget {
  const SectionWrapper({
    super.key,
    required this.title,
    required this.isVisible,
    required this.child,
    this.meta,
  });

  final String title;

  /// Drives the reveal. Set by the page's scroll listener.
  final bool isVisible;

  final Widget child;

  /// Short mono fact shown opposite the title.
  final String? meta;

  @override
  State<SectionWrapper> createState() => _SectionWrapperState();
}

class _SectionWrapperState extends State<SectionWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final CurvedAnimation _rule = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.6, curve: Motion.emphasized),
  );
  late final CurvedAnimation _header = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.18, 0.85, curve: Motion.enter),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(covariant SectionWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    if (!widget.isVisible) return;
    if (Motion.isReduced(context)) {
      _controller.value = 1;
    } else if (!_controller.isAnimating && _controller.value != 1) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _rule.dispose();
    _header.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;
    final bool isWide = MediaQuery.sizeOf(context).width > AppDimens.breakpoint;

    return Padding(
      padding: EdgeInsets.only(
        top: isWide ? AppDimens.sectionGap : AppDimens.sectionGapNarrow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Rule draws out from the left as the section arrives.
          AnimatedBuilder(
            animation: _rule,
            builder: (BuildContext context, _) => Transform.scale(
              scaleX: _rule.value,
              alignment: Alignment.centerLeft,
              child: Container(
                  height: 2, width: double.infinity, color: tokens.ink),
            ),
          ),
          const SizedBox(height: AppDimens.spaceMd),
          StaggeredEntry(
            animation: _header,
            rise: 12,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.title,
                    style: isWide
                        ? context.type.headlineLarge
                        : context.type.headlineMedium,
                  ),
                ),
                if (widget.meta != null) ...<Widget>[
                  const SizedBox(width: AppDimens.spaceMd),
                  Text(
                    widget.meta!.toUpperCase(),
                    style: context.type.labelSmall,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: isWide ? AppDimens.spaceXl : AppDimens.spaceLg),
          widget.child,
        ],
      ),
    );
  }
}
