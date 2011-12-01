package org.jetbrains.migLayout.flash {
import flash.display.DisplayObjectContainer;

import net.miginfocom.layout.AbstractMigLayout;
import net.miginfocom.layout.Grid;
import net.miginfocom.layout.LayoutUtil;
import net.miginfocom.layout.PlatformDefaults;

public class MigLayout extends AbstractMigLayout {
  private var lastHash:int = -1;
  private var lastInvalidW:Number;
  private var lastInvalidH:Number;

  public function MigLayout(layoutConstraints:String = null, colConstraints:String = null, rowConstraints:String = null) {
    super(layoutConstraints, colConstraints, rowConstraints);
  }

  public function layoutContainer(container:FlashContainerWrapper):void {
    checkCache(container);

    var w:Number;
    var h:Number;
    var o:DisplayObjectContainer = DisplayObjectContainer(container.component);
    if (o.parent == o.stage) {
      w = o.stage.stageWidth;
      h = o.stage.stageHeight;
    }
    else {
      w = LayoutUtil.getSizeSafe(grid != null ? grid.width : null, LayoutUtil.PREF);
      h = LayoutUtil.getSizeSafe(grid != null ? grid.height : null, LayoutUtil.PREF);
    }
    
    container.w = w;
    container.h = h;

    trace(w, h);

    var b:Vector.<int> = new <int>[0, 0, w, h];
    if (grid.layout(b, lc.alignX, lc.alignY, _debug, true)) {
      grid = null;
      checkCache(container);
      grid.layout(b, lc.alignX, lc.alignY, _debug, false);
    }
  }

  private var _debug:Boolean;
  public function set debug(value:Boolean):void {
    _debug = true;
  }

  /** Check if something has changed and if so recreate it to the cached objects.
   * @param container The container that is the target for this layout manager.
   */
  private function checkCache(container:FlashContainerWrapper):void {
    if (container == null) {
      return;
    }

    if (dirty) {
      grid = null;
    }

    // Check if the grid is valid
    var mc:int = PlatformDefaults.modCount;
    if (lastModCount != mc) {
      grid = null;
      lastModCount = mc;
    }

    var hash:int = 0;
    for each (var componentWrapper:FlashComponentWrapper in container.components) {
      hash ^= componentWrapper.layoutHashCode;
      hash += 285134905;
    }

    if (hash != lastHash) {
      grid = null;
      lastHash = hash;
    }

    if (lastInvalidW != container.width || lastInvalidH != container.height) {
      if (grid != null) {
        grid.invalidateContainerSize();
      }

      lastInvalidW = container.width;
      lastInvalidH = container.height;
    }

    //setDebug(par, getDebugMillis() > 0);

    if (grid == null) {
      grid = new Grid(container, lc, rowSpecs, colSpecs, null);
    }

    dirty = false;
  }

  //private function calculateSize(container:FlashContainerWrapper, sizeType:int) {
  //  checkCache(container);
  //  var w:Number = LayoutUtil.getSizeSafe(grid != null ? grid.width : null, sizeType);
  //  var h:Number = LayoutUtil.getSizeSafe(grid != null ? grid.height : null, sizeType);
  //  return new Dimension(w, h);
  //}
}
}










