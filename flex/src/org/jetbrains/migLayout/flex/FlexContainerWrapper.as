package org.jetbrains.migLayout.flex {
import flash.geom.Point;

import mx.core.FlexGlobals;
import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.core.LayoutDirection;
import mx.core.UIComponent;

import net.miginfocom.layout.ComponentWrapper;
import net.miginfocom.layout.ContainerWrapper;

import spark.components.Application;

internal final class FlexContainerWrapper extends FlexComponentWrapper implements ContainerWrapper {
  private var componentWrappers:Vector.<ComponentWrapper>;
  private var componentWrappersDirty:Boolean = true;

  public function FlexContainerWrapper(container:IVisualElementContainer) {
    c = IVisualElement(container);
  }

  public function get horizontalScreenDPI():Number {
    return Application(FlexGlobals.topLevelApplication).applicationDPI;
  }

  public function get verticalScreenDPI():Number {
    return horizontalScreenDPI;
  }

  public function getPixelUnitFactor(isHor:Boolean):Number {
    return 1;
  }

  internal function setContainer(container:IVisualElementContainer):void {
    c = IVisualElement(container);
    componentWrappersDirty = true;
  }

  private function syncComponents():void {
    var container:IVisualElementContainer = IVisualElementContainer(c);
    var numElements:int = container.numElements;
    if (componentWrappers == null) {
      componentWrappers = new Vector.<ComponentWrapper>(numElements);
    }
    else {
      componentWrappers.length = numElements;
    }

    for (var i:int = 0; i < numElements; i++) {
      createWrapper(i, container);
    }
  }

  private function createWrapper(i:int, container:IVisualElementContainer):void {
    // reduce object allocation
    var wrapper:FlexComponentWrapper = FlexComponentWrapper(componentWrappers[i]);
    if (wrapper == null) {
      componentWrappers[i] = wrapper = new FlexComponentWrapper();
    }
    wrapper.element = container.getElementAt(i);
  }

  public function get components():Vector.<ComponentWrapper> {
    if (componentWrappersDirty) {
      syncComponents();
      componentWrappersDirty = false;
    }

    return componentWrappers;
  }

  public function get componentCount():int {
    return IVisualElementContainer(c).numElements;
  }

  public function getLayout():Object {
    return null;
  }

  public function get leftToRight():Boolean {
    return c.layoutDirection != LayoutDirection.RTL;
  }

  public function paintDebugCell(x:Number, y:Number, width:Number, height:Number, first:Boolean):void {
  }

  public function get screenWidth():Number {
    return UIComponent(c).screen.width;
  }

  public function get screenHeight():Number {
    return UIComponent(c).screen.height;
  }

  public function get screenLocationX():Number {
    return UIComponent(c).localToGlobal(new Point()).x;
  }

  public function get screenLocationY():Number {
    return UIComponent(c).localToGlobal(new Point()).y;
  }

  public function get hasParent():Boolean {
    return UIComponent(c).parent != null;
  }

  internal function elementAdded(index:int):void {
    if (!componentWrappersDirty) {
      createWrapper(index, IVisualElementContainer(c));
    }
  }

  internal function elementRemoved(index:int):void {
    if (!componentWrappersDirty) {
      var wrapper:FlexComponentWrapper = FlexComponentWrapper(componentWrappers[index]);
      if (wrapper != null) {
        wrapper.c = null;
      }
    }
  }
}
}
