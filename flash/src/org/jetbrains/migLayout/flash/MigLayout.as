package org.jetbrains.migLayout.flash {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

import net.miginfocom.layout.AbstractMigLayout;
import net.miginfocom.layout.ComponentWrapper;
import net.miginfocom.layout.ContainerWrapper;
import net.miginfocom.layout.Grid;
import net.miginfocom.layout.PlatformDefaults;

public class MigLayout extends AbstractMigLayout {
  private var cacheParentW:FlashContainerWrapper;

  public function MigLayout(layoutConstraints:String = null, colConstraints:String = null, rowConstraints:String = null) {
    super(layoutConstraints, colConstraints, rowConstraints);
  }

  public function layoutContainer(parent:Sprite):void {
    var b:Vector.<int> = new <int>[0, 0, parent.width, parent.height];
    if (grid.layout(b, lc.alignX, lc.alignY, getDebug(), true)) {
      grid = null;
      checkCache(parent);
      grid.layout(b, lc.alignX, lc.alignY, getDebug(), false);
    }
  }

  private function getDebug():Boolean {
    return false;
  }

  /** Check if something has changed and if so recreate it to the cached objects.
   * @param parent The parent that is the target for this layout manager.
   */
  private function checkCache(parent:Sprite):void {
    if (parent == null) {
      return;
    }

    if (dirty) {
      grid = null;
    }

    cleanConstraintMaps(parent);

    // Check if the grid is valid
    var mc:int = PlatformDefaults.modCount;
    if (lastModCount != mc) {
      grid = null;
      lastModCount = mc;
    }

    var par:ContainerWrapper = checkParent(parent);
    //setDebug(par, getDebugMillis() > 0);

    if (grid == null) {
      grid = new Grid(par, lc, rowSpecs, colSpecs, ccMap, null);
    }

    dirty = false;
  }

  private function checkParent(parent:DisplayObjectContainer):ContainerWrapper {
    if (cacheParentW == null || cacheParentW.component != parent) {
      cacheParentW = new FlashContainerWrapper(parent, this);
    }

    return cacheParentW;
  }

  private function cleanConstraintMaps(parent:DisplayObjectContainer):void {
    var removed:Vector.<ComponentWrapper> = new Vector.<ComponentWrapper>();
    var componentWrapper:ComponentWrapper;
    for (var adobeBurnInHell:Object in ccMap) {
      componentWrapper = ComponentWrapper(adobeBurnInHell);
      if (DisplayObject(componentWrapper.component).parent != parent) {
        removed[removed.length] = componentWrapper;
        delete scrConstrMap[componentWrapper.component];
      }
    }

    for each (componentWrapper in removed) {
      delete ccMap[componentWrapper];
    }
  }
}
}










