package net.miginfocom.layout {
/** A class that wraps a container that contains components.
 */
public interface ContainerWrapper extends ComponentWrapper {
  /** Returns the DPI (Dots Per Inch) of the screen the component is currently in or for the default
   * screen if the component is not visible.
   * <p>
   * If headless mode {@link net.miginfocom.layout.PlatformDefaults#defaultDPI} will be returned.
   * @return The DPI.
   */
  function get horizontalScreenDPI():Number;

  /** Returns the DPI (Dots Per Inch) of the screen the component is currently in or for the default
   * screen if the component is not visible.
   * <p>
   * If headless mode {@link net.miginfocom.layout.PlatformDefaults#defaultDPI} will be returned.
   * @return The DPI.
   */
  function get verticalScreenDPI():Number;

  /** Returns the pixel unit factor for the horizontal or vertical dimension.
   * <p>
   * The factor is 1 for both dimensions on the normal font in a JPanel on Windows. The factor should increase with a bigger "X".
   * <p>
   * This is the Swing version:
   * <pre>
   * Rectangle2D r = fm.getStringBounds("X", parent.getGraphics());
   * wFactor = r.getWidth() / 6;
   * hFactor = r.getHeight() / 13.27734375f;
   * </pre>
   * @param isHor If it is the horizontal factor that should be returned.
   * @return The factor.
   */
  function getPixelUnitFactor(isHor:Boolean):Number;

  /** Returns the components of the container that wrapper is wrapping.
   * @return The components of the container that wrapper is wrapping. Never <code>null</code>.
   */
  function get components():Vector.<ComponentWrapper>;

  /** Returns the number of components that this parent has.
   * @return The number of components that this parent has.
   */
  function get componentCount():int;

  /** Returns the <code>LayoutHandler</code> (in Swing terms) that is handling the layout of this container.
   * @return The layout handler instance. Never <code>null</code>.
   */
  function getLayout():Object;

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