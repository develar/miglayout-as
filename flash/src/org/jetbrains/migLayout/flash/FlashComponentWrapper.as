package org.jetbrains.migLayout.flash {
import flash.display.DisplayObject;
import flash.errors.IllegalOperationError;

import net.miginfocom.layout.CC;
import net.miginfocom.layout.ComponentType;
import net.miginfocom.layout.ComponentWrapper;
import net.miginfocom.layout.LayoutUtil;

public class FlashComponentWrapper implements ComponentWrapper {
  internal var c:DisplayObject;

  function FlashComponentWrapper(c:DisplayObject, constraints:CC) {
    this.c = c;
    _constraints = constraints;
  }

  private var _constraints:CC;
  public function get constraints():CC {
    return _constraints;
  }

  public function get x():Number {
    return c.x;
  }

  public function get y():Number {
    return c.y;
  }

  public function get actualWidth():int {
    return c.width;
  }

  public function get actualHeight():int {
    return c.height;
  }

  public function getMinimumWidth(hHint:int = -1):int {
    return getPreferredWidth();
  }

  public function getMinimumHeight(wHint:int = -1):int {
    return getPreferredHeight();
  }

  public function getPreferredWidth(hHint:int = -1):int {
    return c.width / c.scaleX;
  }

  public function getPreferredHeight(wHint:int = -1):int {
    return c.height / c.scaleY;
  }

  public function getMaximumWidth(hHint:int = -1):int {
    return 32767;
  }

  public function getMaximumHeight(wHint:int = -1):int {
    return 32767;
  }

  public function setBounds(x:Number, y:Number, w:int, h:int):void {
    c.x = x;
    c.y = y;
    c.width = w;
    c.height = h;
  }

  public function get visible():Boolean {
    return c.visible;
  }

  public function getBaseline(width:int, height:int):int {
    return -1;
  }

  public function get hasBaseline():Boolean {
    return false;
  }

  public function get linkId():String {
    return null;
  }

  public function get layoutHashCode():int {
    return LayoutUtil.calculateHash(this);
  }

  public function get visualPadding():Vector.<Number> {
    return null;
  }

  public function paintDebugOutline():void {
  }

  public function getComponentType(disregardScrollPane:Boolean):int {
    return ComponentType.TYPE_UNKNOWN;
  }

  public function set visible(value:Boolean):void {
    throw new IllegalOperationError("Burn in Hell, Adobe");
  }
}
}
