package org.jetbrains.migLayout.flex {
import flash.utils.getQualifiedClassName;

import mx.core.IVisualElement;
import mx.styles.IAdvancedStyleClient;

import net.miginfocom.layout.CC;
import net.miginfocom.layout.ComponentWrapper;
import net.miginfocom.layout.ConstraintParser;
import net.miginfocom.layout.LayoutUtil;

internal class FlexComponentWrapper implements ComponentWrapper {
  // https://plus.google.com/u/0/106049295903830073464/posts/HgNfitcmzSP
  private static const MIN_EQUALS_PREF:uint = 1 << 0;
  
  internal var c:IVisualElement;
  
  private var flags:uint;
  
  internal function set element(element:IVisualElement):void {
    c = element;

    var fqn:String = getQualifiedClassName(element);
    if (fqn == "spark.components::Label") {
      flags = MIN_EQUALS_PREF;
    }
    else {
      flags = 0;
    }
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
    return (flags & MIN_EQUALS_PREF) == 0 ? c.getMinBoundsWidth() : c.getPreferredBoundsWidth();
  }

  public function getMinimumHeight(wHint:int = -1):int {
    return (flags & MIN_EQUALS_PREF) == 0 ? c.getMinBoundsHeight() : c.getPreferredBoundsHeight();
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

  //noinspection JSFieldCanBeLocal
  private var _constraints:CC;
  private var constraintsSource:Object;

  public function get constraints():CC {
    var source:Object = c.left;
    if (source != constraintsSource) {
      constraintsSource = source;
      if (source is CC) {
        _constraints = CC(source);
      }
      else {
        _constraints = ConstraintParser.parseComponentConstraint(source as String);
      }
    }

    return _constraints;
  }
}
}
