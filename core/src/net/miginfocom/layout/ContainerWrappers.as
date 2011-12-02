package net.miginfocom.layout {
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Shape;

public final class ContainerWrappers {
  private static const DB_CELL_OUTLINE:uint = 0xff0000;
  private static const DEBUG_CANVAS_NAME:String = "migLayoutDebugCanvas";

  public static function paintDebugCell(container:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, first:Boolean):void {
    var debugCanvas:Shape;
    if (first) {
      debugCanvas = Shape(container.getChildByName(DEBUG_CANVAS_NAME));
      if (debugCanvas == null) {
        debugCanvas = new Shape();
        debugCanvas.name = DEBUG_CANVAS_NAME;
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

    g.drawRect(x, y, width, height);
  }
}
}
