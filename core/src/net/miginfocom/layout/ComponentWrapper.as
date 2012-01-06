package net.miginfocom.layout {
/** A class that wraps the important parts of a Component.
 */
public interface ComponentWrapper {
  /** Returns the current x coordinate for this component.
   * @return The current x coordinate for this component.
   */
  function get x():Number;

  /** Returns the current y coordinate for this component.
   * @return The current y coordinate for this component.
   */
  function get y():Number;

  /** Returns the current width for this component.
   * @return The current width for this component.
   */
  function get actualWidth():int;

  /** Returns the current height for this component.
   * @return The current height for this component.
   */
  function get actualHeight():int;

  /** Returns the minimum width of the component.
   * @param hHint The Size hint for the other dimension. An implementation can use this value or the
   * current size for the widget in this dimension, or a combination of both, to calculate the correct size.<br>
   * Use -1 to denote that there is no hint. This corresponds with SWT.DEFAULT.
   * @return The minimum width of the component.
   * @since 3.5. Added the hint as a parameter knowing that a correction and recompilation is necessary for
   * any implementing classes. This change was worth it though.
   */
  function getMinimumWidth(hHint:int = -1):int;

  /** Returns the minimum height of the component.
   * @param wHint The Size hint for the other dimension. An implementation can use this value or the
   * current size for the widget in this dimension, or a combination of both, to calculate the correct size.<br>
   * Use -1 to denote that there is no hint. This corresponds with SWT.DEFAULT.
   * @return The minimum height of the component.
   * @since 3.5. Added the hint as a parameter knowing that a correction and recompilation is necessary for
   * any implementing classes. This change was worth it though.
   */
  function getMinimumHeight(wHint:int = -1):int;

  /** Returns the preferred width of the component.
   * @param hHint The Size hint for the other dimension. An implementation can use this value or the
   * current size for the widget in this dimension, or a combination of both, to calculate the correct size.<br>
   * Use -1 to denote that there is no hint. This corresponds with SWT.DEFAULT.
   * @return The preferred width of the component.
   * @since 3.5. Added the hint as a parameter knowing that a correction and recompilation is necessary for
   * any implementing classes. This change was worth it though.
   */
  function getPreferredWidth(hHint:int = -1):int;

  /** Returns the preferred height of the component.
   * @param wHint The Size hint for the other dimension. An implementation can use this value or the
   * current size for the widget in this dimension, or a combination of both, to calculate the correct size.<br>
   * Use -1 to denote that there is no hint. This corresponds with SWT.DEFAULT.
   * @return The preferred height of the component.
   * @since 3.5. Added the hint as a parameter knowing that a correction and recompilation is necessary for
   * any implementing classes. This change was worth it though.
   */
  function getPreferredHeight(wHint:int = -1):int;

  /** Returns the maximum width of the component.
   * @param hHint The Size hint for the other dimension. An implementation can use this value or the
   * current size for the widget in this dimension, or a combination of both, to calculate the correct size.<br>
   * Use -1 to denote that there is no hint. This corresponds with SWT.DEFAULT.
   * @return The maximum width of the component.
   * @since 3.5. Added the hint as a parameter knowing that a correction and recompilation is necessary for
   * any implementing classes. This change was worth it though.
   */
  function getMaximumWidth(hHint:int = -1):int;

  /** Returns the maximum height of the component.
   * @param wHint The Size hint for the other dimension. An implementation can use this value or the
   * current size for the widget in this dimension, or a combination of both, to calculate the correct size.<br>
   * Use -1 to denote that there is no hint. This corresponds with SWT.DEFAULT.
   * @return The maximum height of the component.
   * @since 3.5. Added the hint as a parameter knowing that a correction and recompilation is necessary for
   * any implementing classes. This change was worth it though.
   */
  function getMaximumHeight(wHint:int = -1):int;

  /** Sets the component's bounds.
   * @param x The x coordinate.
   * @param y The y coordinate.
   * @param w The width.
   * @param h The height.
   */
  function setBounds(x:Number, y:Number, w:int, h:int):void;

  /** Returns if the component's visibility is set to <code>true</code>. This should not return if the component is
   * actually visible, but if the visibility is set to true or not.
   * @return <code>true</code> means visible.
   */
  function get visible():Boolean;

  // Ignore it. Any impl (empty) allowable. Burn in Hell, Adobe. We need to fix compiler.
  function set visible(value:Boolean):void;

  /** Returns the baseline for the component given the suggested height.
   * @param width The width to calculate for if other than the current. If <code>-1</code> the current size should be used.
   * @param height The height to calculate for if other than the current. If <code>-1</code> the current size should be used.
   * @return The baseline from the top or -1 if not applicable.
   */
  function getBaseline(width:int, height:int):int;

  /** Returns if the component has a baseline and if it can be retrieved.
   * @return If the component has a baseline and if it can be retrieved.
   */
  function get hasBaseline():Boolean;

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
  function get layoutHashCode():int;

  /** Returns the padding on a component by component basis. This method can be overridden to return padding to compensate for example for
   * borders that have shadows or where the outer most pixel is not the visual "edge" to align to.
   * <p>
   * Default implementation returns <code>null</code> for all components except for Windows XP's JTabbedPane which will return new Insets(0, 0, 2, 2).
   * <p>
   * <b>NOTE!</B> To reduce generated garbage the returned padding should never be changed so that the same insets can be returned many times.
   * @return <code>null</code> if no padding. <b>NOTE!</B> To reduce generated garbage the returned padding should never be changed so that
   * the same insets can be returned many times. [top, left, bottom, right]
   */
  function get visualPadding():Vector.<int>;

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
   * @return The type of component that this wrapper is wrapping. E.g. {@link ComponentType#TYPE_LABEL}.
   */
  function getComponentType(disregardScrollPane:Boolean):int;

  function get constraints():CC;
}
}