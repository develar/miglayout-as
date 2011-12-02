package org.jetbrains.migLayout.flash {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Shape;

import net.miginfocom.layout.CC;
import net.miginfocom.layout.ComponentType;
import net.miginfocom.layout.ComponentWrapper;
import net.miginfocom.layout.ConstraintParser;
import net.miginfocom.layout.ContainerWrapper;

public final class FlashContainerWrapper extends FlashComponentWrapper implements ContainerWrapper {
  private static const DB_CELL_OUTLINE:uint = 0xff0000;
  
  internal var w:int;
  internal var h:int;

  override public function getPreferredWidth(hHint:Number):Number {
    return w;
  }

  override public function getPreferredHeight(wHint:Number):Number {
    return h;
  }

  function FlashContainerWrapper(c:DisplayObjectContainer, layout:MigLayout) {
    super(c, null, null);
    _layout = layout;
  }

  override public function getComponentType(disregardScrollPane:Boolean):int {
    return ComponentType.TYPE_CONTAINER;
  }

  private const _components:Vector.<ComponentWrapper> = new Vector.<ComponentWrapper>();
  public function get components():Vector.<ComponentWrapper> {
    return _components;
  }

  public function get componentCount():int {
    return DisplayObjectContainer(c).numChildren;
  }

  private var _layout:MigLayout;
  public function get layout():Object {
    return _layout;
  }

  public function get isLeftToRight():Boolean {
    return true;
  }

  public function paintDebugCell(x:Number, y:Number, width:Number, height:Number, first:Boolean):void {
    var container:DisplayObjectContainer = DisplayObjectContainer(c);
    var debugCanvas:Shape;
    if (first) {
      debugCanvas = Shape(container.getChildByName("migLayotDebugCanvas"));
      if (debugCanvas == null) {
        debugCanvas = new Shape();
        debugCanvas.name = "migLayotDebugCanvas";
        container.addChild(debugCanvas);
      }
      else {
        container.setChildIndex(debugCanvas, container.numChildren - 1);
      }
    }
    else {
      debugCanvas = Shape(container.getChildAt(container.numChildren - 1));
    }

    var g:Graphics = debugCanvas.graphics;
    if (first) {
      g.clear();
      g.lineStyle(1, DB_CELL_OUTLINE);
    }

    g.moveTo(x, y);
    g.drawRect(x, y, width, height);
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

  public function get screenWidth():Number {
    return c.stage.stageWidth;
  }

  public function get screenHeight():Number {
    return c.stage.stageHeight;
  }

  public function get hasParent():Boolean {
    return c.parent != null;
  }
}
}