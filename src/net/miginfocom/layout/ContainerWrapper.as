package net.miginfocom.layout {
/** A class that wraps a container that contains components.
 */
public interface ContainerWrapper extends ComponentWrapper {
  /** Returns the components of the container that wrapper is wrapping.
   * @return The components of the container that wrapper is wrapping. Never <code>null</code>.
   */
  function get components():Vector.<ComponentWrapper>;

  /** Returns the number of components that this parent has.
   * @return The number of components that this parent has.
   */
  function get componentCount():int;

  /** Returns the <code>LayoutHandler</code> (in Swing terms) that is handling the layout of this container.
   * If there exist no such class the method should return the same as {@link #component}, which is the
   * container itself.
   * @return The layout handler instance. Never <code>null</code>.
   */
  function get layout():Object;

  /** Returns if this container is using left-to-right component ordering.
   * @return If this container is using left-to-right component ordering.
   */
  function get isLeftToRight():Boolean;

  /** Paints a cell to indicate where it is.
   * @param x The x coordinate to start the drwaing.
   * @param y The x coordinate to start the drwaing.
   * @param width The width to draw/fill
   * @param height The height to draw/fill
   */
  function paintDebugCell(x:Number, y:Number, width:Number, height:Number):void;
}
}