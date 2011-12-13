package net.miginfocom.layout {
/**
 * Contains the constraints for an instance of the {@link LC} layout manager.
 */
public final class LC {
  private var flags:uint = FLOW_X | TOP_TO_BOTTOM | VISUAL_PADDING;

  /**
   * If components have sizes or positions linked to the bounds of the parent in some way (as for instance the <code>"%"</code> unit has) the cache
   * must be turned off for the panel. If components does not get the correct or expected size or position try to set this property to <code>true</code>.
   */
  private static const NO_CACHE:uint = 1 << 0;
  private static const FLOW_X:uint = 1 << 1;
  // If the layout should always claim the whole bounds of the laid out container even if the preferred size is smaller.
  private static const FILL_X:uint = 1 << 2;
  // If the layout should always claim the whole bounds of the laid out container even if the preferred size is smaller.
  private static const FILL_Y:uint = 1 << 3;
  // If the layout should go from the default top-to-bottom in the grid instead of the optinal bottom-to-top.
  private static const TOP_TO_BOTTOM:uint = 1 << 4;
  // If the whole layout should be non grid based. It is the same as setting the "nogrid" property on every row/column in the grid.
  private static const NO_GRID:uint = 1 << 5;
  // If visual padding should be automatically used and compensated for by this layout instance.
  private static const VISUAL_PADDING:uint = 1 << 6;

  private static const LTR:uint = 1 << 7;
  private static const HAS_LTR:uint = 1 << 8;

  public function get noCache():Boolean {
    return (flags & NO_CACHE) != 0;
  }

  public function set noCache(value:Boolean):void {
    value ? flags |= NO_CACHE : flags &= ~NO_CACHE;
  }

  /**
   * If the laid out components' bounds in total is less than the final size of the container these align values will be used to align the components
   * in the parent. <code>null</code> is default and that means top/left alignment. The relative distances between the components will not be affected
   * by this property.
   */
  public var alignX:UnitValue;

  /**
   * If the laid out components' bounds in total is less than the final size of the container these align values will be used to align the components
   * in the parent. <code>null</code> is default and that means top/left alignment. The relative distances between the components will not be affected
   * by this property.
   */
  public var alignY:UnitValue;

  private var _debugMillis:int = 0;
  /**
   * If <code>&gt; 0</code> the debug decorations will be repainted every <code>millis</code>. No debug information if <code>&lt;= 0</code> (default).
   * @return The current debug repaint interval.
   */
  public function get debugMillis():int {
    return _debugMillis;
  }

  /**
   * If <code>&gt; 0</code> the debug decorations will be repainted every <code>millis</code>. No debug information if <code>&lt;= 0</code> (default).
   * @param value The new debug repaint interval.
   */
  public function set debugMillis(value:int):void {
    _debugMillis = value;
  }

  public function get fillX():Boolean {
    return (flags & FILL_X) != 0;
  }

  public function set fillX(value:Boolean):void {
    value ? flags |= FILL_X : flags &= ~FILL_X;
  }

  public function get fillY():Boolean {
    return (flags & FILL_Y) != 0;
  }

  public function set fillY(value:Boolean):void {
    value ? flags |= FILL_Y : flags &= ~FILL_Y;
  }

  /** The default flow direction. Normally (which is <code>true</code>) this is horizontal and that means that the "next" component
   * will be put in the cell to the right (or to the left if left-to-right is false).
   * @return <code>true</code> is the default flow horizontally.
   * @see # setLeftToRight(Boolean)
   */
  public function get flowX():Boolean {
    return (flags & FLOW_X) != 0;
  }

  /** The default flow direction. Normally (which is <code>true</code>) this is horizontal and that means that the "next" component
   * will be put in the cell to the right (or to the left if left-to-right is false).
   * @param value <code>true</code> is the default flow horizontally.
   * @see # setLeftToRight(Boolean)
   */
  public function set flowX(value:Boolean):void {
    value ? flags |= FLOW_X : flags &= ~FLOW_X;
  }

  /**
   * If non-<code>null</code> (<code>null</code> is default) these value will be used as the default gaps between the columns in the grid.
   * The default grid gap between columns in the grid. <code>null</code> if the platform default is used.
   */
  public var gridGapX:BoundSize;

  /**
   * If non-<code>null</code> (<code>null</code> is default) these value will be used as the default gaps between the rows in the grid.
   * @return The default grid gap between rows in the grid. <code>null</code> if the platform default is used.
   */
  public var gridGapY:BoundSize;

  /**
   * How a component that is hidden (not visible) should be treated by default.
   * 0 == Normal. Bounds will be caclulated as if the component was visible.<br>
   * 1 == If hidden the size will be 0, 0 but the gaps remain.<br>
   * 2 == If hidden the size will be 0, 0 and gaps set to zero.<br>
   * 3 == If hidden the component will be disregarded completely and not take up a cell in the grid..
   */
  private var _hideMode:int = 0;

  public function get hideMode():int {
    return _hideMode;
  }

  public function set hideMode(mode:int):void {
    if (mode < 0 || mode > 3) {
      throw new ArgumentError("Wrong hideMode: " + mode);
    }

    _hideMode = mode;
  }

  /**
  * The insets for the layed out panel. The insets will be an empty space around the components in the panel. <code>null</code> values
  * means that the default panel insets for the platform is used. See {@link PlatformDefaults#setDialogInsets(net.miginfocom.layout.UnitValue, net.miginfocom.layout.UnitValue, net.miginfocom.layout.UnitValue, net.miginfocom.layout.UnitValue)}.
  * Of length 4 (top, left, bottom, right) or <code>null</code>. The elements (1 to 4) may be <code>null</code>.
  * @see net.miginfocom.layout.ConstraintParser#parseInsets(String, boolean)
  */
  public var insets:Vector.<UnitValue>;

  /** If the layout should be forced to be left-to-right or right-to-left. A value of <code>null</code> is default and
     * means that this will be picked up from the {@link java.util.Locale} that the container being layed out is reporting.
   * @return <code>Boolean.TRUE</code> if force left-to-right. <code>Boolean.FALSE</code> if force tight-to-left. <code>null</code>
   * for the default "let the current Locale decide".
   */
  public function get leftToRight():int {
    return (flags & HAS_LTR) == 0 ? 0 : (flags & LTR) == 0 ? -1 : 1;
  }

  public function set leftToRight(value:int):void {
    if (value == -1) {
      flags &= ~HAS_LTR;
    }
    else {
      value ? flags |= LTR : flags &= ~LTR;
      flags |= HAS_LTR;
    }
  }

  public function get noGrid():Boolean {
    return (flags & NO_GRID) != 0;
  }

  public function set noGrid(value:Boolean):void {
    value ? flags |= NO_GRID : flags &= ~NO_GRID;
  }

  public function get topToBottom():Boolean {
    return (flags & TOP_TO_BOTTOM) != 0;
  }

  public function set topToBottom(value:Boolean):void {
    value ? flags |= TOP_TO_BOTTOM : flags &= ~TOP_TO_BOTTOM;
  }

  public function get visualPadding():Boolean {
    return (flags & VISUAL_PADDING) != 0;
  }

  public function set visualPadding(value:Boolean):void {
    value ? flags |= VISUAL_PADDING : flags &= ~VISUAL_PADDING;
  }

  private var _wrapAfter:int = LayoutUtil.INF;

  /** Returns after what cell the grid should always auto wrap.
   * @return After what cell the grid should always auto wrap. If <code>0</code> the number of columns/rows in the
   * {@l ink net.miginfocom.layout.AC} is used. <code>LayoutUtil.INF</code> is used for no auto wrap.
   */
  public function get wrapAfter():int {
    return _wrapAfter;
  }

  /** Sets after what cell the grid should always auto wrap.
   * @param value After what cell the grid should always auto wrap. If <code>0</code> the number of columns/rows in the
   * {@l ink net.miginfocom.layout.AC} is used. <code>LayoutUtil.INF</code> is used for no auto wrap.
   */
  public function set wrapAfter(value:int):void {
    _wrapAfter = value;
  }

  private var _packW:BoundSize = BoundSize.NULL_SIZE;

  /**
   * Returns the "pack width" for the <b>window</b> that this container is located in. When the size of this container changes
   * the size of the window will be corrected to be within this BoundsSize. It can be used to set the minimum and/or maximum size of the window
   * as well as the size window should optimally get. This optimal size is normaly its "preferred" size which is why "preferred"
   * is the normal value to set here.
   * <p>
   * ":push" can be appended to the bound size to only push the size bigger and never shrink it if the preferred size gets smaller.
   * <p>
   * E.g. "pref", "100:pref", "pref:700", "300::700", "pref:push"
   * @return The current value. Never <code>null</code>. Check if not set with <code>.isUnset()</code>.
   * @since 3.5
   */
  public function get packWidth():BoundSize {
    return _packW;
  }

  /**
   * Sets the "pack width" for the <b>window</b> that this container is located in. When the size of this container changes
   * the size of the window will be corrected to be within this BoundsSize. It can be used to set the minimum and/or maximum size of the window
   * as well as the size window should optimally get. This optimal size is normaly its "preferred" size which is why "preferred"
   * is the normal value to set here.
   * <p>
   * ":push" can be appended to the bound size to only push the size bigger and never shrink it if the preferred size gets smaller.
   * <p>
   * E.g. "pref", "100:pref", "pref:700", "300::700", "pref:push"
   * @param size The new pack size. If <code>null</code> it will be corrected to an "unset" BoundSize.
   * @since 3.5
   */
  public function set packWidth(size:BoundSize):void {
    _packW = size != null ? size : BoundSize.NULL_SIZE;
  }

  private var _packH:BoundSize = BoundSize.NULL_SIZE;

  /** Returns the "pack height" for the <b>window</b> that this container is located in. When the size of this container changes
   * the size of the window will be corrected to be within this BoundsSize. It can be used to set the minimum and/or maximum size of the window
   * as well as the size window should optimally get. This optimal size is normaly its "preferred" size which is why "preferred"
   * is the normal value to set here.
   * <p>
   * ":push" can be appended to the bound size to only push the size bigger and never shrink it if the preferred size gets smaller.
   * <p>
   * E.g. "pref", "100:pref", "pref:700", "300::700", "pref:push"
   * @return The current value. Never <code>null</code>. Check if not set with <code>.isUnset()</code>.
   * @since 3.5
   */
  public function get packHeight():BoundSize {
    return _packH;
  }

  /** Sets the "pack height" for the <b>window</b> that this container is located in. When the size of this container changes
   * the size of the window will be corrected to be within this BoundsSize. It can be used to set the minimum and/or maximum size of the window
   * as well as the size window should optimally get. This optimal size is normaly its "preferred" size which is why "preferred"
   * is the normal value to set here.
   * <p>
   * ":push" can be appended to the bound size to only push the size bigger and never shrink it if the preferred size gets smaller.
   * <p>
   * E.g. "pref", "100:pref", "pref:700", "300::700", "pref:push"
   * @param value The new pack size. If <code>null</code> it will be corrected to an "unset" BoundSize.
   * @since 3.5
   */
  public function set packHeight(value:BoundSize):void {
    _packH = value != null ? value : BoundSize.NULL_SIZE;
  }

  /** If there is a resize of the window due to packing (see {@link # setPackHeight(BoundSize)} this value, which is between 0f and 1f,
   * decides where the extra/surpurflous size is placed. 0f means that the window will resize so that the upper part moves up and the
   * lower side stays in the same place. 0.5f will expand/reduce the window equally upwards and downwards. 1f will do the opposite of 0f
   * of course.
   * @return The pack alignment. Always between 0f and 1f, inclusive.
   * @since 3.5
   */
  private var phAlign:Number = 0.5;

  public function get packHeightAlign():Number {
    return phAlign;
  }

  /**
   * @param value The pack alignment. Always between 0f and 1f, inclusive. Values outside this will be truncated.
   */
  public function set packHeightAlign(value:Number):void {
    phAlign = Math.max(0, Math.min(1, value));
  }

  /**
   * If there is a resize of the window due to packing (see {@link # setPackHeight(BoundSize)} this value, which is between 0f and 1f,
   * decides where the extra/surpurflous size is placed. 0f means that the window will resize so that the left part moves left and the
   * right side stays in the same place. 0.5f will expand/reduce the window equally to the right and lefts. 1f will do the opposite of 0f
   * of course.
   */
  private var pwAlign:Number = 0.5;

  /**
   * @return The pack alignment. Always between 0f and 1f, inclusive.
   * @since 3.5
   */
  public function get packWidthAlign():Number {
    return pwAlign;
  }

  /**
   * @param value The pack alignment. Always between 0f and 1f, inclusive. Values outside this will be truncated.
   * @since 3.5
   */
  public function set packWidthAlign(value:Number):void {
    pwAlign = Math.max(0, Math.min(1, value));
  }

  private var _width:BoundSize = BoundSize.NULL_SIZE;

  /** Returns the minimum/preferred/maximum size for the container that this layout constraint is set for. Any of these
   * sizes that is not <code>null</code> will be returned directly instead of determining the correspondig size through
   * asking the components in this container.
   * @return The width for the container that this layout constraint is set for. Not <code>null</code> but
   * all sizes can be <code>null</code>.
   * @since 3.5
   */
  public function get width():BoundSize {
    return _width;
  }

  /** Sets the minimum/preferred/maximum size for the container that this layout constraint is set for. Any of these
   * sizes that is not <code>null</code> will be returned directly instead of determining the correspondig size through
   * asking the components in this container.
   * @param value The width for the container that this layout constraint is set for. <code>null</code> is translated to
   * a bound size containing only null sizes.
   * @since 3.5
   */
  public function set width(value:BoundSize):void {
    _width = value != null ? value : BoundSize.NULL_SIZE;
  }

  private var _height:BoundSize = BoundSize.NULL_SIZE;

  /** Returns the minimum/preferred/maximum size for the container that this layout constraint is set for. Any of these
   * sizes that is not <code>null</code> will be returned directly instead of determining the correspondig size through
   * asking the components in this container.
   * @return The height for the container that this layout constraint is set for. Not <code>null</code> but
   * all sizes can be <code>null</code>.
   * @since 3.5
   */
  public function get height():BoundSize {
    return _height;
  }

  /** Sets the minimum/preferred/maximum size for the container that this layout constraint is set for. Any of these
   * sizes that is not <code>null</code> will be returned directly instead of determining the correspondig size through
   * asking the components in this container.
   * @param value The height for the container that this layout constraint is set for. <code>null</code> is translated to
   * a bound size containing only null sizes.
   * @since 3.5
   */
  public function set height(value:BoundSize):void {
    _height = value != null ? value : BoundSize.NULL_SIZE;
  }
}
}