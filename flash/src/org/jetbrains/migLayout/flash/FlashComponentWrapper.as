package org.jetbrains.migLayout.flash {
import flash.display.DisplayObject;

import net.miginfocom.layout.CC;
import net.miginfocom.layout.ComponentType;
import net.miginfocom.layout.ComponentWrapper;
import net.miginfocom.layout.LayoutUtil;
import net.miginfocom.layout.PlatformDefaults;

internal class FlashComponentWrapper implements ComponentWrapper {
  protected var c:DisplayObject;

  function FlashComponentWrapper(c:DisplayObject, constraints:CC) {
    this.c = c;
    _constraints = constraints;
  }

  private var _constraints:CC;
  public function get constraints():CC {
    return _constraints;
  }
  
  public function get component():Object {
    return c;
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
    return 0;
  }

  public function getMinimumHeight(wHint:int = -1):int {
    return 0;
  }

  public function getPreferredWidth(hHint:int = -1):int {
    return c.width;
  }

  public function getPreferredHeight(wHint:int = -1):int {
    return c.height;
  }

  public function getMaximumWidth(hHint:int = -1):int {
    return 32767;
  }

  public function getMaximumHeight(wHint:int = -1):int {
    return 32767;
  }

  public function setBounds(x:Number, y:Number, width:int, height:int):void {
    c.x = x;
    c.y = y;
    c.width = width;
    c.height = height;
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

  public function getPixelUnitFactor(isHor:Boolean):Number {
    return 1;
  }

  public function get horizontalScreenDPI():Number {
    return PlatformDefaults.defaultDPI;
  }

  public function get verticalScreenDPI():Number {
    return PlatformDefaults.defaultDPI;
  }

  public function get linkId():String {
    return c.name;
  }

  public function get layoutHashCode():int {
    return LayoutUtil.calculateHash(actualWidth, actualHeight, visible, linkId);
  }

  public function get visualPadding():Vector.<Number> {
    return null;
  }

  public function paintDebugOutline():void {
  }

  public function getComponentType(disregardScrollPane:Boolean):int {
    return ComponentType.TYPE_UNKNOWN;
  }
}
}
