import 'package:flutter/material.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';
import 'package:portfolio/presentation/widgets/interactive_surface.dart';

/// A section the nav can jump to.
@immutable
class NavItem {
  const NavItem({required this.label, required this.sectionKey});

  final String label;
  final String sectionKey;
}

/// Desktop section nav with a single indicator that slides between items.
///
/// The indicator tracks the section you are actually reading and follows the
/// pointer on hover, so it doubles as a scroll position readout rather than
/// being pure decoration.
class NavRail extends StatefulWidget {
  const NavRail({
    super.key,
    required this.items,
    required this.activeKey,
    required this.onSelect,
  });

  final List<NavItem> items;

  /// Section currently in view.
  final String activeKey;

  final void Function(String sectionKey) onSelect;

  @override
  State<NavRail> createState() => _NavRailState();
}

class _NavRailState extends State<NavRail> {
  final GlobalKey _railKey = GlobalKey();
  late List<GlobalKey> _itemKeys;

  /// Measured position of the indicator, in rail-local coordinates.
  Rect? _indicator;
  int? _hovered;

  @override
  void initState() {
    super.initState();
    _itemKeys = List<GlobalKey>.generate(
      widget.items.length,
      (_) => GlobalKey(),
    );
  }

  @override
  void didUpdateWidget(covariant NavRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length != oldWidget.items.length) {
      _itemKeys = List<GlobalKey>.generate(
        widget.items.length,
        (_) => GlobalKey(),
      );
    }
  }

  /// The item the indicator should sit under, or null while the reader is in a
  /// section the nav doesn't list (the hero) and isn't pointing at anything.
  int? get _targetIndex {
    if (_hovered != null) return _hovered;
    final int active = widget.items.indexWhere(
      (NavItem item) => item.sectionKey == widget.activeKey,
    );
    return active < 0 ? null : active;
  }

  /// Measures the target item after layout. Widths are content-sized, so the
  /// indicator has to be measured rather than assumed.
  void _measure() {
    final int? index = _targetIndex;
    if (index == null) {
      if (_indicator != null && mounted) setState(() => _indicator = null);
      return;
    }
    final RenderBox? rail =
        _railKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? item =
        _itemKeys[index].currentContext?.findRenderObject() as RenderBox?;
    if (rail == null || item == null || !rail.hasSize || !item.hasSize) return;

    final Offset origin = rail.globalToLocal(item.localToGlobal(Offset.zero));
    final Rect next = origin & item.size;
    if (_indicator == next) return;
    if (!mounted) return;
    setState(() => _indicator = next);
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());

    return Stack(
      key: _railKey,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < widget.items.length; i++)
              MouseRegion(
                onEnter: (_) => setState(() => _hovered = i),
                onExit: (_) =>
                    setState(() => _hovered = _hovered == i ? null : _hovered),
                child: InteractiveSurface(
                  key: _itemKeys[i],
                  onTap: () => widget.onSelect(widget.items[i].sectionKey),
                  semanticLabel: 'Go to ${widget.items[i].label}',
                  enforceMinTapTarget: false,
                  builder: (BuildContext context, double hover) => Container(
                    height: AppDimens.minTapTarget,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceSm + 2,
                    ),
                    child: Text(
                      widget.items[i].label.toUpperCase(),
                      style: context.type.labelMedium?.copyWith(
                        color: Color.lerp(tokens.inkMuted, tokens.ink, hover),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (_indicator != null)
          AnimatedPositioned(
            duration: Motion.resolve(context, Motion.base),
            curve: Motion.emphasized,
            left: _indicator!.left,
            width: _indicator!.width,
            bottom: 6,
            height: 2,
            child: DecoratedBox(
              decoration: BoxDecoration(color: tokens.signal),
            ),
          ),
      ],
    );
  }
}
