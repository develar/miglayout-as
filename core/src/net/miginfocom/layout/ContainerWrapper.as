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
  function get leftToRight():Boolean;

  /** Paints a cell to indicate where it is.
   * @param x The x coordinate to start the drwaing.
   * @param y The x coordinate to start the drwaing.
   * @param width The width to draw/fill
   * @param height The height to draw/fill
   */
  function paintDebugCell(x:Number, y:Number, width:Number, height:Number, first:Boolean):void;

  /** Returns the pixel size of the screen that the component is currently in or for the default
   * screen if the component is not visible or <code>null</code>.
   * <p>
   * If in headless mode <code>1024</code> is returned.
   * @return The screen size. E.g. <code>1280</code>.
   */
  function get screenWidth():Number;

  /** Returns the pixel size of the screen that the component is currently in or for the default
   * screen if the component is not visible or <code>null</code>.
   * <p>
   * If in headless mode <code>768</code> is returned.
   * @return The screen size. E.g. <code>1024</code>.
   */
  function get screenHeight():Number;

  /** Returns the screen x-coordinate for the upper left coordinate of the component layout-able bounds.
   * @return The screen x-coordinate for the upper left coordinate of the component layout-able bounds.
   */
  function get screenLocationX():Number;

  /** Returns the screen y-coordinate for the upper left coordinate of the component layout-able bounds.
   * @return The screen y-coordinate for the upper left coordinate of the component layout-able bounds.
   */
  function get screenLocationY():Number;

  function get hasParent():Boolean;
}
}