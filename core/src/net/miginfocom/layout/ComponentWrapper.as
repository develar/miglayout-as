package net.miginfocom.layout {
/** A class that wraps the important parts of a Component.
 * <p>
 * <b>NOTE!</b>.equals() and .hashcode() should be shunted to the wrapped component. E.g.
 * <pre>
 *   public int hashCode()
 {
 return getComponent().hashCode();
 }

 public final boolean equals(Object o)
 {
 if (o instanceof ComponentWrapper == false)
 return false;

 return getComponent().equals(((ComponentWrapper) o).getComponent());
 }
 * </pre>
 */
public interface ComponentWrapper {

  /** Returns the actual object that this wrapper is aggregating. This might be needed for getting
   * information about the object that the wrapper interface does not provide.
   * <p>
   * If this is a container the container should be returned instead.
   * @return The actual object that this wrapper is aggregating. Not <code>null</code>.
   */
  function get component():Object;

  /** Returns the current x coordinate for this component.
   * @return The current x coordinate for this component.
   */
  function get x():Number;

  /** Returns the current y coordinate for this component.
   * @return The current y coordinate for this component.
   */
  function get y():Number ;

  /** Returns the current width for this component.
   * @return The current width for this component.
   */
  function get width():Number;

  /** Returns the current height for this component.
   * @return The current height for this component.
   */
  function get height():Number;

  /** Returns the screen x-coordinate for the upper left coordinate of the component layout-able bounds.
   * @return The screen x-coordinate for the upper left coordinate of the component layout-able bounds.
   */
  function get screenLocationX():Number;

  /** Returns the screen y-coordinate for the upper left coordinate of the component layout-able bounds.
   * @return The screen y-coordinate for the upper left coordinate of the component layout-able bounds.
   */
  function get screenLocationY():Number;

  /** Returns the minimum width of the component.
   * @param hHint The Size hint for the other dimension. An implementation can use this value or the
   * current size for the widget in this dimension, or a combination of both, to calculate the correct size.<br>
   * Use -1 to denote that there is no hint. This corresponds with SWT.DEFAULT.
   * @return The minimum width of the component.
   * @since 3.5. Added the hint as a parameter knowing that a correction and recompilation is necessary for
   * any implementing classes. This change was worth it though.
   */
  function getMinimumWidth(hHint:int):Number;

  /** Returns the minimum height of the component.
   * @param wHint The Size hint for the other dimension. An implementation can use this value or the
   * current size for the widget in this dimension, or a combination of both, to calculate the correct size.<br>
   * Use -1 to denote that there is no hint. This corresponds with SWT.DEFAULT.
   * @return The minimum height of the component.
   * @since 3.5. Added the hint as a parameter knowing that a correction and recompilation is necessary for
   * any implementing classes. This change was worth it though.
   */
  function getMinimumHeight(wHint:Number):Number;

  /** Returns the preferred width of the component.
   * @param hHint The Size hint for the other dimension. An implementation can use this value or the
   * current size for the widget in this dimension, or a combination of both, to calculate the correct size.<br>
   * Use -1 to denote that there is no hint. This corresponds with SWT.DEFAULT.
   * @return The preferred width of the component.
   * @since 3.5. Added the hint as a parameter knowing that a correction and recompilation is necessary for
   * any implementing classes. This change was worth it though.
   */
  function getPreferredWidth(hHint:Number):Number;

  /** Returns the preferred height of the component.
   * @param wHint The Size hint for the other dimension. An implementation can use this value or the
   * current size for the widget in this dimension, or a combination of both, to calculate the correct size.<br>
   * Use -1 to denote that there is no hint. This corresponds with SWT.DEFAULT.
   * @return The preferred height of the component.
   * @since 3.5. Added the hint as a parameter knowing that a correction and recompilation is necessary for
   * any implementing classes. This change was worth it though.
   */
  function getPreferredHeight(wHint:Number):Number;

  /** Returns the maximum width of the component.
   * @param hHint The Size hint for the other dimension. An implementation can use this value or the
   * current size for the widget in this dimension, or a combination of both, to calculate the correct size.<br>
   * Use -1 to denote that there is no hint. This corresponds with SWT.DEFAULT.
   * @return The maximum width of the component.
   * @since 3.5. Added the hint as a parameter knowing that a correction and recompilation is necessary for
   * any implementing classes. This change was worth it though.
   */
  function getMaximumWidth(hHint:Number):Number;

  /** Returns the maximum height of the component.
   * @param wHint The Size hint for the other dimension. An implementation can use this value or the
   * current size for the widget in this dimension, or a combination of both, to calculate the correct size.<br>
   * Use -1 to denote that there is no hint. This corresponds with SWT.DEFAULT.
   * @return The maximum height of the component.
   * @since 3.5. Added the hint as a parameter knowing that a correction and recompilation is necessary for
   * any implementing classes. This change was worth it though.
   */
  function getMaximumHeight(wHint:Number):Number;

  /** Sets the component's bounds.
   * @param x The x coordinate.
   * @param y The y coordinate.
   * @param width The width.
   * @param height The height.
   */
  function setBounds(x:Number, y:Number, width:Number, height:Number):void ;

  /** Returns if the component's visibility is set to <code>true</code>. This should not return if the component is
   * actually visible, but if the visibility is set to true or not.
   * @return <code>true</code> means visible.
   */
  function get visible():Boolean;

  /** Returns the baseline for the component given the suggested height.
   * @param width The width to calculate for if other than the current. If <code>-1</code> the current size should be used.
   * @param height The height to calculate for if other than the current. If <code>-1</code> the current size should be used.
   * @return The baseline from the top or -1 if not applicable.
   */
  function getBaseline(width:Number, height:Number):Number;

  /** Returns if the component has a baseline and if it can be retrieved. Should for instance return
   * <code>false</code> for Swing before mustang.
   * @return If the component has a baseline and if it can be retrieved.
   */
  function get hasBaseline():Boolean;

  /** Returns the container for this component.
   * @return The container for this component. Will return <code>null</code> if the component has no parent.
   */
  function get parent():ContainerWrapper;

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

  /** Returns the DPI (Dots Per Inch) of the screen the component is currently in or for the default
   * screen if the component is not visible.
   * <p>
   * If headless mode {@link net.miginfocom.layout.PlatformDefaults#getDefaultDPI} will be returned.
   * @return The DPI.
   */
  function get horizontalScreenDPI():Number;

  /** Returns the DPI (Dots Per Inch) of the screen the component is currently in or for the default
   * screen if the component is not visible.
   * <p>
   * If headless mode {@link net.miginfocom.layout.PlatformDefaults#getDefaultDPI} will be returned.
   * @return The DPI.
   */
  function get verticalScreenDPI():Number;

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

  /** Returns a String id that can be used to reference the component in link constraints. This value should
   * return the default id for the component. The id can be set for a component in the constraints and if
   * so the value returned by this method will never be used. If there are no sensible id for the component
   * <code>null</code> should be returned.
   * <p>
   * For instance the Swing implementation returns the string returned from <code>Component.getName()</code>.
   * @return The string link id or <code>null</code>.
   */
  function get linkId():String;

  /** Returns a hash code that should be reasonably different for anything that might change the layout. This value is used to
   *  know if the component layout needs to clear any caches.
   * @return A hash code that should be reasonably different for anything that might change the layout. Returns -1 if the widget is
   * disposed.
   */
  function get layoutHashCode():int ;

  /** Returns the padding on a component by component basis. This method can be overridden to return padding to compensate for example for
   * borders that have shadows or where the outer most pixel is not the visual "edge" to align to.
   * <p>
   * Default implementation returns <code>null</code> for all components except for Windows XP's JTabbedPane which will return new Insets(0, 0, 2, 2).
   * <p>
   * <b>NOTE!</B> To reduce generated garbage the returned padding should never be changed so that the same insets can be returned many times.
   * @return <code>null</code> if no padding. <b>NOTE!</B> To reduce generated garbage the returned padding should never be changed so that
   * the same insets can be returned many times. [top, left, bottom, right]
   */
  function get visualPadding():Vector.<Number>;

  /** Paints component outline to indicate where it is.
   */
  function paintDebugOutline():void;

  /** Returns the type of component that this wrapper is wrapping.
   * <p>
   * This method can be invoked often so the result should be cached.
   * <p>
   * <b>NOTE!</b> This is misspelled. Keeping it that way though since this is only used by developers who
   * port MigLayout.
   * @param disregardScrollPane Is <code>true</code> any wrapping scroll pane should be disregarded and the type
   * of the scrolled component should be returned.
   * @return The type of component that this wrapper is wrapping. E.g. {@link #TYPE_LABEL}.
   */
  function getComponentType(disregardScrollPane:Boolean):int;
}
}