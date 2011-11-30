package org.jetbrains.migLayout.flash {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

import net.miginfocom.layout.CC;
import net.miginfocom.layout.ComponentType;
import net.miginfocom.layout.ComponentWrapper;
import net.miginfocom.layout.ConstraintParser;
import net.miginfocom.layout.ContainerWrapper;

public final class FlashContainerWrapper extends FlashComponentWrapper implements ContainerWrapper {
  private var _layout:MigLayout;

  function FlashContainerWrapper(c:DisplayObjectContainer, layout:MigLayout) {
    super(c, null, null);
    _layout = layout;
  }

  override public function getComponentType(disregardScrollPane:Boolean):int {
    return ComponentType.TYPE_CONTAINER;
  }

  private const _components:Vector.<ComponentWrapper> = new Vector.<ComponentWrapper>();
  public function get components():Vector.<ComponentWrapper> {
    //var container:DisplayObjectContainer = DisplayObjectContainer(c);
    //const n:int = componentCount;
    //var components:Vector.<ComponentWrapper> = new Vector.<ComponentWrapper>(n, true);
    //for (var i:int = 0; i < n; i++) {
    //  components[i] = new FlashComponentWrapper(container.getChildAt(i), this);
    //}
    return _components;
  }

  public function get componentCount():int {
    return DisplayObjectContainer(c).numChildren;
  }

  public function get layout():Object {
    return _layout;
  }

  public function get isLeftToRight():Boolean {
    return true;
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

  public function add(component:DisplayObject, constraints:Object = null):void {
    _components[_components.length] = new FlashComponentWrapper(component, this, constraints == null || constraints is String ? ConstraintParser.parseComponentConstraint(ConstraintParser.prepare(String(constraints))) : CC(constraints));
    DisplayObjectContainer(c).addChild(component);
  }

  public function layoutContainer():void {
    _layout.layoutContainer(this);
  }
}
}