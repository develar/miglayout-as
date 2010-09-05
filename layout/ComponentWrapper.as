package cocoa.layout {
public interface ComponentWrapper {
  function getHeight():Number;

  function getMinimumWidth(height:Number):Number;

  function getWidth():Number;

  function getMinimumHeight(width:Number):Number;

  function getPreferredWidth(height:Number):Number;

  function getPreferredHeight(width:Number):Number;

  function getMaximumWidth(height:Number):Number;

  function getMaximumHeight(width:Number):Number;
}
}