package cocoa.layout {
public class UnitConverter {
  public static const UNABLE:int = -87654312;

  public function convertToPixels(value:Number, unitStr:String, isHor:Boolean, refValue:Number, parent:ContainerWrapper, comp:ComponentWrapper):Number {
    throw new Error("abstract")
  }
}
}