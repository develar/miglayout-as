package org.jetbrains.migLayout.flex {
import mx.core.IVisualElement;
import mx.styles.IAdvancedStyleClient;

import net.miginfocom.layout.CC;
import net.miginfocom.layout.ComponentWrapper;
import net.miginfocom.layout.LayoutUtil;

public class FlexComponentWrapper implements ComponentWrapper {
  internal var c:IVisualElement;

  public function FlexComponentWrapper(c:IVisualElement) {
    this.c = c;
  }

  public function get x():Number {
    return c.getLayoutBoundsX();
  }

  public function get y():Number {
    return c.getLayoutBoundsY();
  }

  public function get actualWidth():int {
    return c.getLayoutBoundsWidth();
  }

  public function get actualHeight():int {
    return c.getLayoutBoundsHeight();
  }

  public function getMinimumWidth(hHint:int = -1):int {
    return c.getMinBoundsWidth();
  }

  public function getMinimumHeight(wHint:int = -1):int {
    return c.getMinBoundsHeight();
  }

  public function getPreferredWidth(hHint:int = -1):int {
    return c.getPreferredBoundsWidth();
  }

  public function getPreferredHeight(wHint:int = -1):int {
    return c.getPreferredBoundsHeight();
  }

  public function getMaximumWidth(hHint:int = -1):int {
    return c.getMaxBoundsWidth();
  }

  public function getMaximumHeight(wHint:int = -1):int {
    return c.getMaxBoundsHeight();
  }

  public function setBounds(x:Number, y:Number, w:int, h:int):void {
    c.setLayoutBoundsPosition(x, y);
    c.setLayoutBoundsSize(w, h);
  }

  public function get visible():Boolean {
    return c.visible && c.includeInLayout;
  }

  public function set visible(value:Boolean):void {
    throw new Error("Burn in Hell, Adobe.");
  }

  public function getBaseline(w:int, h:int):int {
    return c.baselinePosition;
  }

  public function get hasBaseline():Boolean {
    return true;
  }

  public function get linkId():String {
    return c is IAdvancedStyleClient ? IAdvancedStyleClient(c).id : null;
  }

  public function get layoutHashCode():int {
    return LayoutUtil.calculateHash(this);
  }

  public function get visualPadding():Vector.<int> {
    return null;
  }

  public function paintDebugOutline():void {
  }

  public function getComponentType(disregardScrollPane:Boolean):int {
    return 0;
  }

  public function get constraints():CC {
    return null;
  }
}
}
