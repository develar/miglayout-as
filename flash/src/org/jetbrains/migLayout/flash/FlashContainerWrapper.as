package org.jetbrains.migLayout.flash {
import flash.display.DisplayObjectContainer;

import net.miginfocom.layout.ComponentType;
import net.miginfocom.layout.ComponentWrapper;
import net.miginfocom.layout.ContainerWrapper;

internal class FlashContainerWrapper extends FlashComponentWrapper implements ContainerWrapper {
  private var _layout:MigLayout;

  function FlashContainerWrapper(c:DisplayObjectContainer, layout:MigLayout) {
    super(c, null);
    _layout = layout;
  }

  override public function getComponentType(disregardScrollPane:Boolean):int {
    return ComponentType.TYPE_CONTAINER;
  }

  public function get components():Vector.<ComponentWrapper> {
    var container:DisplayObjectContainer = DisplayObjectContainer(c);
    const n:int = componentCount;
    var components:Vector.<ComponentWrapper> = new Vector.<ComponentWrapper>(n, true);
    for (var i:int = 0; i < n; i++) {
      components[i] = new FlashComponentWrapper(container.getChildAt(i), this);
    }
    return components;
  }

  public function get componentCount():int {
    return DisplayObjectContainer(c).numChildren;
  }

  public function get layout():Object {
    return _layout;
  }

  public function get isLeftToRight():Boolean {
    return false;
  }

  public function paintDebugCell(x:Number, y:Number, width:Number, height:Number):void {
    //if (!c.visible) {
    //  return;
    //}
    
    //var g:Graphics = c.
  }
  

  override public function get layoutHashCode():int {
    return 0;
  }
}
}
