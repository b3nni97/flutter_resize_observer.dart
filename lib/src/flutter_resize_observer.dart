import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A callback to be invoked when the size of the observed widget changes.
typedef ResizeCallback = void Function(Size oldSize, Size newSize);

/// A widget that calls a callback when the size of its [child] changes.
class ResizeObserver extends SingleChildRenderObjectWidget {
  /// The callback to be called when the size of [child] changes.
  final ResizeCallback onResized;

  final bool notifyOnInit;

  const ResizeObserver({
    super.key,
    required this.onResized,
    this.notifyOnInit = false,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderResizeObserver(
        onLayoutChangedCallback: onResized,
        notifyOnInit: notifyOnInit,
      );
}

class _RenderResizeObserver extends RenderProxyBox {
  final ResizeCallback onLayoutChangedCallback;
  final bool notifyOnInit;

  _RenderResizeObserver({
    RenderBox? child,
    required this.onLayoutChangedCallback,
    required this.notifyOnInit,
  }) : super(child);

  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _oldSize) {
      if (_oldSize != null || (_oldSize == null && notifyOnInit)) {
        onLayoutChangedCallback(_oldSize ?? size, size);
      }
      _oldSize = size;
    }
  }
}
