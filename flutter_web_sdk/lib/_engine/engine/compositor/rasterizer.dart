// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of dart._engine;

/// A class that can rasterize [LayerTree]s into a given [Surface].
class Rasterizer {
  final Surface surface;
  final CompositorContext context = CompositorContext();

  Rasterizer(this.surface);

  /// Creates a new frame from this rasterizer's surface, draws the given
  /// [LayerTree] into it, and then submits the frame.
  void draw(LayerTree layerTree) {
    if (layerTree == null) {
      return;
    }

    final ui.Size physicalSize = ui.window.physicalSize;
    final ui.Size frameSize = ui.Size(
      physicalSize.width.truncate().toDouble(),
      physicalSize.height.truncate().toDouble(),
    );

    if (frameSize.isEmpty) {
      return;
    }
    layerTree.frameSize = frameSize;

    final SurfaceFrame frame = surface.acquireFrame(layerTree.frameSize);
    final SkCanvas canvas = frame.skiaCanvas;
    final Frame compositorFrame = context.acquireFrame(canvas);

    compositorFrame.raster(layerTree, ignoreRasterCache: true);
    frame.submit();
  }
}
