package cocoa.layout
{
import apparat.math.FastMath;

/**
 * Contains the constraints for an instance of the {@link LC} layout manager.
 */
internal final class LC
{
  private var flags:uint = FLOW_X | TOP_TO_BOTTOM | VISUAL_PADDING;

	private var debugMillis:int = 0;

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

  public function get noCache():Boolean {
    return (flags & NO_CACHE) != 0;
  }

  public function set noCache(value:Boolean) {
    value ? flags |= NO_CACHE : flags &= ~NO_CACHE;
  }

  /**
   * If the laid out components' bounds in total is less than the final size of the container these align values will be used to align the components
   * in the parent. <code>null</code> is default and that means top/left alignment. The relative distances between the components will not be affected
   * by this property.
   */
  private var _alignX:UnitValue;

  public function get alignX():UnitValue {
    return _alignX;
  }

  /**
   * @param value The new alignment. Use {@link ConstraintParser# parseAlignKeywords(String, boolean)} to create the {@link UnitValue}. May be <code>null</code>.
   */
  public function set alignX(value:UnitValue):void {
    _alignX = value;
  }

  /**
   * If the laid out components' bounds in total is less than the final size of the container these align values will be used to align the components
   * in the parent. <code>null</code> is default and that means top/left alignment. The relative distances between the components will not be affected
   * by this property.
   */
  private var _alignY:UnitValue;

  public function get alignY():UnitValue {
    return _alignY;
  }

  /**
   * @param value The new alignment. Use {@link ConstraintParser# parseAlignKeywords(String, boolean)} to create the {@link UnitValue}. May be <code>null</code>.
   */
  public function set alignY(value:UnitValue):void {
    _alignY = value;
  }

  /**
   * If <code>&gt; 0</code> the debug decorations will be repainted every <code>millis</code>. No debug information if <code>&lt;= 0</code> (default).
   * @return The current debug repaint interval.
   */
  public function get getDebugMillis():int {
    return debugMillis;
  }

  /**
   * If <code>&gt; 0</code> the debug decorations will be repainted every <code>millis</code>. No debug information if <code>&lt;= 0</code> (default).
   * @param millis The new debug repaint interval.
   */
  public function setDebugMillis(millis:int):void {
    debugMillis = millis;
  }

  public function get fillX():Boolean {
    return (flags & FILL_X) != 0;
  }

  public function set fillX(value:Boolean) {
    value ? flags |= FILL_X : flags &= ~FILL_X;
  }

	public function get fillY():Boolean
	{
		return (flags & FILL_Y) != 0;
	}

	public function set fillY(value:Boolean) {
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
  private var _gridGapX:BoundSize;
  public function get gridGapX():BoundSize {
    return _gridGapX;
  }

  public function set gridGapX(value:BoundSize) {
    _gridGapX = value;
  }

  private var _gridGapY:BoundSize;
	/**
   * If non-<code>null</code> (<code>null</code> is default) these value will be used as the default gaps between the rows in the grid.
	 * @return The default grid gap between rows in the grid. <code>null</code> if the platform default is used.
	 */
  public function get gridGapY():BoundSize {
    return _gridGapY;
  }

  /**
   * If non-<code>null</code> (<code>null</code> is default) these value will be used as the default gaps between the rows in the grid.
   * @param value The default grid gap between rows in the grid. If <code>null</code> the platform default is used.
   */
  public function set gridGapY(value:BoundSize):void {
    _gridGapY = value;
  }

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

  public function setHideMode(mode:int):void {
    if (mode < 0 || mode > 3) {
      throw new ArgumentError("Wrong hideMode: " + mode);
    }

    _hideMode = mode;
  }

  /**
   * The insets for the layed out panel. The insets will be an empty space around the components in the panel. <code>null</code> values
	 * means that the default panel insets for the platform is used. See {@l ink PlatformDefaults#setDialogInsets(net.miginfocom.layout.UnitValue, net.miginfocom.layout.UnitValue, net.miginfocom.layout.UnitValue, net.miginfocom.layout.UnitValue)}.
	 * @return The insets. Of length 4 (top, left, bottom, right) or <code>null</code>. The elements (1 to 4) may be <code>null</code>. The array is a copy and can be used freely.
	 * @ see net.miginfocom.layout.ConstraintParser#parseInsets(String, boolean)
	 */
  private var _insets:Vector.<UnitValue>; // Never null elememts but if unset array is null
  public function get insets():Vector.<UnitValue> {
    return _insets != null ? new <UnitValue>[_insets[0], _insets[1], _insets[2], _insets[3]] : null;
  }

  public function set insets(value:Vector.<UnitValue>) {
    _insets = value != null ? new <UnitValue>[value[0], value[1], value[2], value[3]] : null;
  }

  /**
   * If the layout should be forced to be left-to-right or right-to-left. A value of <code>null</code> is default and
	 * means that this will be picked up from the {@l ink java.util.Locale} that the container being layed out is reporting.
	 * @return <code>Boolean.TRUE</code> if force left-to-right. <code>Boolean.FALSE</code> if force tight-to-left. <code>null</code>
	 * for the default "let the current Locale decide".
	 */
  private var _leftToRight:int;
  public function get leftToRight():int {
    return _leftToRight;
  }

  public function set leftToRight(value:int):void {
    _leftToRight = value;
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
  public function set packHeightAlign(value:Number) {
    phAlign = FastMath.max(0, FastMath.min(1, value));
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
  public function set packWidthAlign(value:Number) {
    pwAlign = FastMath.max(0, FastMath.min(1, value));
  }

  private var _width:BoundSize = BoundSize.NULL_SIZE;

	/** Returns the minimum/preferred/maximum size for the container that this layout constraint is set for. Any of these
	 * sizes that is not <code>null</code> will be returned directly instead of determining the correspondig size through
	 * asking the components in this container.
	 * @return The width for the container that this layout constraint is set for. Not <code>null</code> but
	 * all sizes can be <code>null</code>.
	 * @since 3.5
	 */
	public function get width():BoundSize
	{
		return _width;
	}

	/** Sets the minimum/preferred/maximum size for the container that this layout constraint is set for. Any of these
	 * sizes that is not <code>null</code> will be returned directly instead of determining the correspondig size through
	 * asking the components in this container.
	 * @param value The width for the container that this layout constraint is set for. <code>null</code> is translated to
	 * a bound size containing only null sizes.
	 * @since 3.5
	 */
	public function set width(value:BoundSize):void
	{
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

	/** Short for, and thus same as, <code>.pack("pref", "pref")</code>.
	 * <p>
	 * Same functionality as {@link # setPackHeight(BoundSize)} and {@link # setPackWidth(net.miginfocom.layout.BoundSize)}
	 * only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @since 3.5
	 */
  public function pack():LC {
    return pack2("pref", "pref");
  }

  /** Sets the pack width and height.
	 * <p>
	 * Same functionality as {@link # setPackHeight(BoundSize)} and {@link # setPackWidth(net.miginfocom.layout.BoundSize)}
	 * only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param width The pack width. May be <code>null</code>.
	 * @param height The pack height. May be <code>null</code>.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @since 3.5
	 */
	public function pack2(width:String, height:String):LC
	{
		setPackWidth(width != null ? ConstraintParser.parseBoundSize(width, false, false) : BoundSize.NULL_SIZE);
		setPackHeight(height != null ? ConstraintParser.parseBoundSize(height, false, false) : BoundSize.NULL_SIZE);
		return this;
	}

	/** Sets the pack width and height alignment.
	 * <p>
	 * Same functionality as {@link # setPackHeightAlign(float)} and {@link # setPackWidthAlign(float)}
	 * only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param alignX The pack width alignment. 0.5f is default.
	 * @param alignY The pack height alignment. 0.5f is default.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @since 3.5
	 */
	public final LC packAlign(float alignX, float alignY)
	{
		setPackWidthAlign(alignX);
		setPackHeightAlign(alignY);
		return this;
	}

	/** Sets a wrap after the number of columns/rows that is defined in the {@link net.miginfocom.layout.AC}.
	 * <p>
	 * Same functionality as {@link #setWrapAfter(int 0)} only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC wrap()
	{
		setWrapAfter(0);
		return this;
	}

	/** Same functionality as {@link #setWrapAfter(int)} only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param count After what cell the grid should always auto wrap. If <code>0</code> the number of columns/rows in the
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC wrapAfter(int count)
	{
		setWrapAfter(count);
		return this;
	}

	/** Same functionality as {@link #setNoCache(boolean true)} only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC noCache()
	{
		setNoCache(true);
		return this;
	}

	/** Same functionality as {@link #setFlowX(boolean false)} only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC flowY()
	{
		setFlowX(false);
		return this;
	}

	/** Same functionality as {@link #setFlowX(boolean true)} only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC flowX()
	{
		setFlowX(true);
		return this;
	}

	/** Same functionality as {@link #setFillX(boolean true)} and {@link #setFillY(boolean true)} conmbined.T his method returns
	 * <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC fill()
	{
		setFillX(true);
		setFillY(true);
		return this;
	}

	/** Same functionality as {@link #setFillX(boolean true)} only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC fillX()
	{
		setFillX(true);
		return this;
	}

	/** Same functionality as {@link #setFillY(boolean true)} only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC fillY()
	{
		setFillY(true);
		return this;
	}

	/** Same functionality as {@link #setLeftToRight(Boolean)} only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param b <code>true</code> for forcing left-to-right. <code>false</code> for forcing right-to-left.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC leftToRight(boolean b)
	{
		setLeftToRight(b ? Boolean.TRUE : Boolean.FALSE); // Not .valueOf due to retroweaver...
		return this;
	}

	/** Same functionality as setLeftToRight(false) only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @since 3.7.2
	 */
	public final LC rightToLeft()
	{
		setLeftToRight(Boolean.FALSE);
		return this;
	}

	/** Same functionality as {@link #setTopToBottom(boolean false)} only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC bottomToTop()
	{
		setTopToBottom(false);
		return this;
	}

	/** Same functionality as {@link #setTopToBottom(boolean true)} only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @since 3.7.2
	 */
	public final LC topToBottom()
	{
		setTopToBottom(true);
		return this;
	}

	/** Same functionality as {@link #setNoGrid(boolean true)} only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC noGrid()
	{
		setNoGrid(true);
		return this;
	}

	/** Same functionality as {@link #setVisualPadding(boolean false)} only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC noVisualPadding()
	{
		setVisualPadding(false);
		return this;
	}

	/** Sets the same inset (expressed as a <code>UnitValue</code>, e.g. "10px" or "20mm") all around.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param allSides The unit value to set for all sides. May be <code>null</code> which means that the default panel insets
	 * for the platform is used.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @see #setInsets(UnitValue[])
	 */
	public final LC insetsAll(String allSides)
	{
		UnitValue insH = ConstraintParser.parseUnitValue(allSides, true);
		UnitValue insV = ConstraintParser.parseUnitValue(allSides, false);
		insets = new UnitValue[] {insV, insH, insV, insH}; // No setter to avoid copy again
		return this;
	}

	/** Same functionality as <code>setInsets(ConstraintParser.parseInsets(s, true))</code>. This method returns <code>this</code>
	 * for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param s The string to parse. E.g. "10 10 10 10" or "20". If less than 4 groups the last will be used for the missing.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @see #setInsets(UnitValue[])
	 */
	public final LC insets(String s)
	{
		insets = ConstraintParser.parseInsets(s, true);
		return this;
	}

	/** Sets the different insets (expressed as a <code>UnitValue</code>s, e.g. "10px" or "20mm") for the corresponding sides.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param top The top inset. E.g. "10px" or "10mm" or "related". May be <code>null</code> in which case the default inset for this
	 * side for the platform will be used.
	 * @param left The left inset. E.g. "10px" or "10mm" or "related". May be <code>null</code> in which case the default inset for this
	 * side for the platform will be used.
	 * @param bottom The bottom inset. E.g. "10px" or "10mm" or "related". May be <code>null</code> in which case the default inset for this
	 * side for the platform will be used.
	 * @param right The right inset. E.g. "10px" or "10mm" or "related". May be <code>null</code> in which case the default inset for this
	 * side for the platform will be used.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @see #setInsets(UnitValue[])
	 */
	public final LC insets(String top, String left, String bottom, String right)
	{
		insets = new UnitValue[] { // No setter to avoid copy again
				ConstraintParser.parseUnitValue(top, false),
				ConstraintParser.parseUnitValue(left, true),
				ConstraintParser.parseUnitValue(bottom, false),
				ConstraintParser.parseUnitValue(right, true)};
		return this;
	}

	/** Same functionality as <code>setAlignX(ConstraintParser.parseUnitValueOrAlign(unitValue, true))</code> only this method returns <code>this</code>
	 * for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param align The align keyword or for instance "100px". E.g "left", "right", "leading" or "trailing".
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @see #setAlignX(UnitValue)
	 */
	public final LC alignX(String align)
	{
		setAlignX(ConstraintParser.parseUnitValueOrAlign(align, true, null));
		return this;
	}

	/** Same functionality as <code>setAlignY(ConstraintParser.parseUnitValueOrAlign(align, false))</code> only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param align The align keyword or for instance "100px". E.g "top" or "bottom".
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @see #setAlignY(UnitValue)
	 */
	public final LC alignY(String align)
	{
		setAlignY(ConstraintParser.parseUnitValueOrAlign(align, false, null));
		return this;
	}

	/** Sets both the alignX and alignY as the same time.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param ax The align keyword or for instance "100px". E.g "left", "right", "leading" or "trailing".
	 * @param ay The align keyword or for instance "100px". E.g "top" or "bottom".
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @see #_alignX(String)
	 * @see #_alignY(String)
	 */
	public final LC align(String ax, String ay)
	{
		if (ax != null)
			alignX(ax);

		if (ay != null)
			alignY(ay);

		return this;
	}

	/** Same functionality as <code>setGridGapX(ConstraintParser.parseBoundSize(boundsSize, true, true))</code> only this method
	 * returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param boundsSize The <code>BoundSize</code> of the gap. This is a minimum and/or preferred and/or maximum size. E.g.
	 * <code>"50:100:200"</code> or <code>"100px"</code>.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @see #setGridGapX(BoundSize)
	 */
	public final LC gridGapX(String boundsSize)
	{
		setGridGapX(ConstraintParser.parseBoundSize(boundsSize, true, true));
		return this;
	}

	/** Same functionality as <code>setGridGapY(ConstraintParser.parseBoundSize(boundsSize, true, false))</code> only this method
	 * returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param boundsSize The <code>BoundSize</code> of the gap. This is a minimum and/or preferred and/or maximum size. E.g.
	 * <code>"50:100:200"</code> or <code>"100px"</code>.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @see #setGridGapY(BoundSize)
	 */
	public final LC gridGapY(String boundsSize)
	{
		setGridGapY(ConstraintParser.parseBoundSize(boundsSize, true, false));
		return this;
	}

	/** Sets both grid gaps at the same time. see {@link #gridGapX(String)} and {@link #gridGapY(String)}.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param gapx The <code>BoundSize</code> of the gap. This is a minimum and/or preferred and/or maximum size. E.g.
	 * <code>"50:100:200"</code> or <code>"100px"</code>.
	 * @param gapy The <code>BoundSize</code> of the gap. This is a minimum and/or preferred and/or maximum size. E.g.
	 * <code>"50:100:200"</code> or <code>"100px"</code>.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @see #gridGapX(String)
	 * @see #gridGapY(String)
	 */
	public final LC gridGap(String gapx, String gapy)
	{
		if (gapx != null)
			gridGapX(gapx);

		if (gapy != null)
			gridGapY(gapy);

		return this;
	}

	/** Same functionality as {@link #setDebugMillis(int repaintMillis)} only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param repaintMillis The new debug repaint interval.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @see #setDebugMillis(int)
	 */
	public final LC debug(int repaintMillis)
	{
		setDebugMillis(repaintMillis);
		return this;
	}

	/** Same functionality as {@link #setHideMode(int mode)} only this method returns <code>this</code> for chaining multiple calls.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param mode The mode:<br>
	 * 0 == Normal. Bounds will be caclulated as if the component was visible.<br>
	 * 1 == If hidden the size will be 0, 0 but the gaps remain.<br>
	 * 2 == If hidden the size will be 0, 0 and gaps set to zero.<br>
	 * 3 == If hidden the component will be disregarded completely and not take up a cell in the grid..
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 * @see #setHideMode(int)
	 */
	public final LC hideMode(int mode)
	{
		setHideMode(mode);
		return this;
	}

	/** The minimum width for the container. The value will override any value that is set on the container itself.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or Cheat Sheet at www.migcontainers.com.
	 * @param width The width expressed as a <code>UnitValue</code>. E.g. "100px" or "200mm".
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC minWidth(String width)
	{
		setWidth(LayoutUtil.derive(getWidth(), ConstraintParser.parseUnitValue(width, true), null, null));
		return this;
	}

	/** The width for the container as a min and/or preferref and/or maximum width. The value will override any value that is set on
	 * the container itself.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or Cheat Sheet at www.migcontainers.com.
	 * @param width The width expressed as a <code>Boundwidth</code>. E.g. "50:100px:200mm" or "100px".
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC width(String width)
	{
		setWidth(ConstraintParser.parseBoundSize(width, false, true));
		return this;
	}

	/** The maximum width for the container. The value will override any value that is set on the container itself.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or Cheat Sheet at www.migcontainers.com.
	 * @param width The width expressed as a <code>UnitValue</code>. E.g. "100px" or "200mm".
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC maxWidth(String width)
	{
		setWidth(LayoutUtil.derive(getWidth(), null, null, ConstraintParser.parseUnitValue(width, true)));
		return this;
	}

	/** The minimum height for the container. The value will override any value that is set on the container itself.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or Cheat Sheet at www.migcontainers.com.
	 * @param height The height expressed as a <code>UnitValue</code>. E.g. "100px" or "200mm".
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC minHeight(String height)
	{
		setHeight(LayoutUtil.derive(getHeight(), ConstraintParser.parseUnitValue(height, false), null, null));
		return this;
	}

	/** The height for the container as a min and/or preferref and/or maximum height. The value will override any value that is set on
	 * the container itself.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcontainers.com.
	 * @param height The height expressed as a <code>Boundheight</code>. E.g. "50:100px:200mm" or "100px".
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public final LC height(String height)
	{
		setHeight(ConstraintParser.parseBoundSize(height, false, false));
		return this;
	}

	/**
   * The maximum height for the container. The value will override any value that is set on the container itself.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcontainers.com.
	 * @param height The height expressed as a <code>UnitValue</code>. E.g. "100px" or "200mm".
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
	 */
	public function LC maxHeight(height:String):void
	{
		setHeight(LayoutUtil.derive(height(), null, null, ConstraintParser.parseUnitValue(height, false)));
		return this;
	}
}
}