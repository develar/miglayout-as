package org.jetbrains.migLayout.flash {
import net.miginfocom.layout.AbstractMigLayout;
import net.miginfocom.layout.Grid;
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

    var b:Vector.<int> = new <int>[0, 0, container.width, container.height];
    if (grid.layout(b, lc.alignX, lc.alignY, getDebug(), true)) {
      grid = null;
      checkCache(container);
      grid.layout(b, lc.alignX, lc.alignY, getDebug(), false);
    }
  }

  private function getDebug():Boolean {
    return false;
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
}
}










