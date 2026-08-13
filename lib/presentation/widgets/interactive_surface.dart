import 'package:flutter/material.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';

/// Every interactive thing on the page goes through here: nav links, social
/// icons, store links, project cards, the contact button.
///
/// It gives the "respond" motion idiom one implementation — a controller-driven
/// 0→1 hover value the caller can spend however it likes — and it guarantees
/// the quality floor in a single place: keyboard reachable, Enter/Space
/// activate, a visible focus ring, a labelled semantic button, and a tap
/// target that never drops below [AppDimens.minTapTarget].
class InteractiveSurface extends StatefulWidget {
  const InteractiveSurface({
    super.key,
    required this.onTap,
    required this.semanticLabel,
    required this.builder,
    this.tooltip,
    this.borderRadius,
    this.pressScale = 0.97,
    this.enforceMinTapTarget = true,
  });

  final VoidCallback onTap;

  /// What a screen reader announces. Required — icon-only buttons without one
  /// are the defect this widget exists to make impossible.
  final String semanticLabel;

  /// Receives the eased hover/focus progress, 0 at rest and 1 fully engaged.
  final Widget Function(BuildContext context, double hover) builder;

  final String? tooltip;

  /// Shape of the focus ring. Defaults to [AppDimens.radiusSm].
  final BorderRadius? borderRadius;

  /// How far the surface presses in on pointer-down.
  final double pressScale;

  /// Cards manage their own generous hit area; small icon links need padding.
  final bool enforceMinTapTarget;

  @override
  State<InteractiveSurface> createState() => _InteractiveSurfaceState();
}

class _InteractiveSurfaceState extends State<InteractiveSurface>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hover = AnimationController(
    vsync: this,
    duration: Motion.fast,
  );
  late final CurvedAnimation _eased = CurvedAnimation(
    parent: _hover,
    curve: Motion.emphasized,
  );

  bool _focused = false;
  bool _pressed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hover.duration = Motion.resolve(context, Motion.fast);
  }

  @override
  void dispose() {
    _eased.dispose();
    _hover.dispose();
    super.dispose();
  }

  void _setEngaged(bool engaged) {
    if (engaged) {
      _hover.forward();
    } else if (!_focused) {
      _hover.reverse();
    }
  }

  void _setPressed(bool pressed) {
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;
    final BorderRadius radius =
        widget.borderRadius ?? BorderRadius.circular(AppDimens.radiusSm);
    final bool reduced = Motion.isReduced(context);

    Widget surface = AnimatedBuilder(
      animation: _eased,
      builder: (BuildContext context, _) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            color: _focused ? tokens.signal : Colors.transparent,
            width: 2,
          ),
        ),
        child: widget.builder(context, _eased.value),
      ),
    );

    if (widget.enforceMinTapTarget) {
      surface = ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AppDimens.minTapTarget,
          minHeight: AppDimens.minTapTarget,
        ),
        child: Center(widthFactor: 1, heightFactor: 1, child: surface),
      );
    }

    if (!reduced) {
      surface = AnimatedScale(
        scale: _pressed ? widget.pressScale : 1,
        duration: Motion.fast,
        curve: Motion.emphasized,
        child: surface,
      );
    }

    if (widget.tooltip != null) {
      surface = Tooltip(message: widget.tooltip!, child: surface);
    }

    return Semantics(
      // A discrete node per link, so a screen reader announces exactly this
      // label instead of merging it with whatever sits next to it.
      container: true,
      button: true,
      label: widget.semanticLabel,
      excludeSemantics: true,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: _setEngaged,
        onShowFocusHighlight: (bool focused) {
          setState(() => _focused = focused);
          _setEngaged(focused);
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap();
              return null;
            },
          ),
        },
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          behavior: HitTestBehavior.opaque,
          child: surface,
        ),
      ),
    );
  }
}
