package org.jetbrains.migLayout.flash {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.geom.Point;

import net.miginfocom.layout.CC;
import net.miginfocom.layout.ComponentType;
import net.miginfocom.layout.ComponentWrapper;
import net.miginfocom.layout.ConstraintParser;
import net.miginfocom.layout.ContainerWrapper;
import net.miginfocom.layout.ContainerWrappers;
import net.miginfocom.layout.PlatformDefaults;

public class FlashContainerWrapper extends FlashComponentWrapper implements ContainerWrapper {
  internal var w:int;
  internal var h:int;

  public function get horizontalScreenDPI():Number {
    return PlatformDefaults.defaultDPI;
  }

  public function get verticalScreenDPI():Number {
    return PlatformDefaults.defaultDPI;
  }

  public function getPixelUnitFactor(isHor:Boolean):Number {
    return 1;
  }

  override public function getPreferredWidth(hHint:int = -1):int {
    return w;
  }

  override public function getPreferredHeight(wHint:int = -1):int {
    return h;
  }

  function FlashContainerWrapper(c:DisplayObjectContainer, layout:MigLayout) {
    super(c, null);
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
    return _components.length;
  }

  private var _layout:MigLayout;
  public function getLayout():Object {
    return _layout;
  }

  public function get leftToRight():Boolean {
    return true;
  }

  public function paintDebugCell(x:Number, y:Number, width:Number, height:Number, first:Boolean):void {
    ContainerWrappers.paintDebugCell(DisplayObjectContainer(c), x,  y,  width, height, first);
  }

  override public function get layoutHashCode():int {
    return 0;
  }

  public function add(component:DisplayObject, constraints:Object = null):void {
    _components[_components.length] = new FlashComponentWrapper(component, constraints == null || constraints is String ? ConstraintParser.parseComponentConstraint(constraints as String) : CC(constraints));
    DisplayObjectContainer(c).addChild(component);
  }

  public function layoutContainer():void {
    _layout.layoutContainer(this);
  }

  public function get screenLocationX():Number {
    return c.localToGlobal(new Point()).x;
  }

  public function get screenLocationY():Number {
    return c.localToGlobal(new Point()).y;
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