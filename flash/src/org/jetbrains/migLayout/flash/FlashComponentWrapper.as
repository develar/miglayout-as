package org.jetbrains.migLayout.flash {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.geom.Point;

import net.miginfocom.layout.CC;

import net.miginfocom.layout.ComponentType;
import net.miginfocom.layout.ComponentWrapper;
import net.miginfocom.layout.ContainerWrapper;
import net.miginfocom.layout.LayoutUtil;
import net.miginfocom.layout.PlatformDefaults;
import net.miginfocom.layout.Strings;

internal class FlashComponentWrapper implements ComponentWrapper {
  protected var c:DisplayObject;
  private var parentWrapper:FlashContainerWrapper;

  function FlashComponentWrapper(c:DisplayObject, parentWrapper:FlashContainerWrapper, constraints:CC) {
    this.c = c;
    this.parentWrapper = parentWrapper;
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

  public function get width():Number {
    return c.width;
  }

  public function get height():Number {
    return c.height;
  }

  public function get screenLocationX():Number {
    return c.localToGlobal(new Point(c.x, c.y)).x;
  }

  public function get screenLocationY():Number {
    return c.localToGlobal(new Point(c.x, c.y)).y;
  }

  public function getMinimumWidth(hHint:int):Number {
    return 0;
  }

  public function getMinimumHeight(wHint:Number):Number {
    return 0;
  }

  public function getPreferredWidth(hHint:Number):Number {
    return c.width;
  }

  public function getPreferredHeight(wHint:Number):Number {
    return c.height;
  }

  public function getMaximumWidth(hHint:Number):Number {
    return 32767;
  }

  public function getMaximumHeight(wHint:Number):Number {
    return 32767;
  }

  public function setBounds(x:Number, y:Number, width:Number, height:Number):void {
    c.x = x;
    c.y = y;
    c.width = width;
    c.height = height;
  }

  public function get visible():Boolean {
    return c.visible;
  }

  public function getBaseline(width:Number, height:Number):Number {
    return -1;
  }

  public function get hasBaseline():Boolean {
    return false;
  }

  public function get parent():ContainerWrapper {
    var p:DisplayObjectContainer = c.parent;
    return p == null ? null : parentWrapper;
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

  public function get screenWidth():Number {
    return c.stage.width;
  }

  public function get screenHeight():Number {
    return c.stage.height;
  }

  public function get linkId():String {
    return c.name;
  }

  public function get layoutHashCode():int {
    return LayoutUtil.calculateHash(width, height, visible, linkId);
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
