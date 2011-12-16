package net.miginfocom.layout {
/** A simple value holder for one component's constraint.
 */
public final class CC {
  private static const DEF_GAP:BoundSize = BoundSize.NULL_SIZE;    // Only used to denote default wrap/newline gap.

	internal static const DOCK_SIDES:Vector.<String> = new <String>["north", "west", "south", "east"];

  private static const FLOW_X:uint = 1 << 0;
  private static const HAS_FLOW_X:uint = 1 << 1;
  
  private static const EXTERNAL:uint = 1 << 2;
  private static const BOUNDS_IN_GRID:uint = 1 << 3;

  private var flags:uint;
	// See the getters and setters for information about the properties below.

	private var dock:int = -1;

  private var _pos:Vector.<UnitValue>; // [x1, y1, x2, y2]

  private var _padding:Vector.<UnitValue>;   // top, left, bottom, right

  private var _skip:int = 0;

  private var _split:int = 1;

  private var _spanX:int = 1, _spanY:int = 1;

  private var _cellX:int = -1, _cellY:int = 0; // If cellX is -1 then cellY is also considered -1. cellY is never negative.

  private var _tag:String;

  private var _id:String;

  private var _hideMode:int = -1;

  private var hor:ComponentConstraint = new ComponentConstraint();
  private var ver:ComponentConstraint = new ComponentConstraint();

  private var _newline:BoundSize;

	private var _wrap:BoundSize;

	private var _pushX:Number, _pushY:Number;

	// ***** Tmp cache field

	private static const EMPTY_ARR:Vector.<String> = new Vector.<String>(0, true);

	private var linkTargets:Vector.<String>;

  internal function getLinkTargets():Vector.<String> {
    if (linkTargets == null) {
      var targets:Vector.<String>;
      if (_pos != null) {
        targets = new Vector.<String>();
        for (var i:int = 0; i < _pos.length; i++) {
          addLinkTargetIDs(targets, _pos[i]);
        }
      }

      linkTargets = targets == null || targets.length == 0 ? EMPTY_ARR : targets;
    }
    return linkTargets;
  }

  private static function addLinkTargetIDs(targets:Vector.<String>, uv:UnitValue):void {
    var subUv:UnitValue;
    var linkId:String;
    if (uv != null) {
      if ((linkId = uv.linkTargetId) != null) {
        targets[targets.length] = linkId;
      }
      else {
        for (var i:int = uv.subUnitCount - 1; i >= 0; i--) {
          if ((subUv = uv.getSubUnitValue(i)).isLinkedDeep) {
            addLinkTargetIDs(targets, subUv);
          }
        }
      }
    }
  }

	/** Returns the horizontal dimension constraint for this component constraint. It has constraints for the horizontal size
	 * and grow/shink priorities and weights.
	 * <p>
	 * Note! If any changes is to be made it must be made direct when the object is returned. It is not allowed to save the
	 * constraint for later use.
	 * @return The current dimension constraint. Never <code>null</code>.
	 */
	public function get horizontal():ComponentConstraint {
		return hor;
	}

	/** Sets the horizontal dimension constraint for this component constraint. It has constraints for the horizontal size
	 * and grow/shrink priorities and weights.
	 * @param value The new dimension constraint. If <code>null</code> it will be reset to <code>new DimConstraint();</code>
	 */
	public function set horizontal(value:ComponentConstraint):void {
		hor = value != null ? value : new ComponentConstraint();
	}

	/** Returns the vertical dimension constraint for this component constraint. It has constraints for the vertical size
	 * and grow/shrink priorities and weights.
	 * <p>
	 * Note! If any changes is to be made it must be made direct when the object is returned. It is not allowed to save the
	 * constraint for later use.
	 * @return The current dimension constraint. Never <code>null</code>.
	 */
	public function get vertical():ComponentConstraint {
		return ver;
	}

	/** Sets the vertical dimension constraint for this component constraint. It has constraints for the vertical size
	 * and grow/shrink priorities and weights.
	 * @param value The new dimension constraint. If <code>null</code> it will be reset to <code>new DimConstraint();</code>
	 */
	public function set vertical(value:ComponentConstraint):void {
		ver = value != null ? value : new ComponentConstraint();
	}

	/** Returns the vertical or horizontal dim constraint.
	 * <p>
	 * Note! If any changes is to be made it must be made direct when the object is returned. It is not allowed to save the
	 * constraint for later use.
	 * @param isHor If the horizontal constraint should be returned.
	 * @return The dim constraint. Never <code>null</code>.
	 */
	public function getDimConstraint(isHor:Boolean):DimConstraint {
		return isHor ? hor : ver;
	}

	/** Returns the absolute positioning of one or more of the edges. This will be applied last in the layout cycle and will not
	 * affect the flow or grid positions. The positioning is relative to the parent and can not (as padding) be used
	 * to adjust the edges relative to the old value. May be <code>null</code> and elements may be <code>null</code>.
	 * <code>null</code> value(s) for the x2 and y2 will be interpreted as to keep the preferred size and thus the x1
	 * and x2 will just absolutely positions the component.
	 * <p>
	 * Note that {@link #boundsInGrid(Boolean)} changes the interpretation of thisproperty slightly.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The current value as a new array, free to modify.
	 */
  public function get pos():Vector.<UnitValue> {
    return _pos;
  }

	/** Sets absolute positioning of one or more of the edges. This will be applied last in the layout cycle and will not
	 * affect the flow or grid positions. The positioning is relative to the parent and can not (as padding) be used
	 * to adjust the edges relative to the old value. May be <code>null</code> and elements may be <code>null</code>.
	 * <code>null</code> value(s) for the x2 and y2 will be interpreted as to keep the preferred size and thus the x1
	 * and x2 will just absolutely positions the component.
	 * <p>
	 * Note that {@link #boundsInGrid(Boolean)} changes the interpretation of thisproperty slightly.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param value <code>UnitValue[] {x, y, x2, y2}</code>. Must be <code>null</code> or of length 4. Elements can be <code>null</code>.
	 */
	public function set pos(value:Vector.<UnitValue>):void {
		_pos = value;
		linkTargets = null;
	}

	/** Returns if the absolute <code>pos</code> value should be corrections to the component that is in a normal cell. If <code>false</code>
	 * the value of <code>pos</code> is truly absolute in that it will not affect the grid or have a default bounds in the grid.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The current value.
	 * @see #pos()
	 */
  internal function get boundsInGrid():Boolean {
		return (flags & BOUNDS_IN_GRID) != 0;
	}

	/** Sets if the absolute <code>pos</code> value should be corrections to the component that is in a normal cell. If <code>false</code>
	 * the value of <code>pos</code> is truly absolute in that it will not affect the grid or have a default bounds in the grid.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param value <code>true</code> for bounds taken from the grid position. <code>false</code> is default.
	 * @see #pos(UnitValue[])
	 */
  internal function set boundsInGrid(value:Boolean):void {
    value ? flags |= BOUNDS_IN_GRID : flags &= ~BOUNDS_IN_GRID;
	}

	/** Returns the absolute cell position in the grid or <code>-1</code> if cell positioning is not used.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The current value.
	 */
	public function get cellX():int {
		return _cellX;
	}

	/** Set an absolute cell x-position in the grid. If &gt;= 0 this point points to the absolute cell that this constaint's component should occupy.
	 * If there's already a component in that cell they will split the cell. The flow will then continue after this cell.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param x The x-position or <code>-1</code> to disable cell positioning.
	 */
	public function set cellX(x:int):void {
		_cellX = x;
	}

	/** Returns the absolute cell position in the grid or <code>-1</code> if cell positioning is not used.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The current value.
	 */
	public function get cellY():int {
		return _cellX < 0 ? -1 : _cellY;
	}

	/** Set an absolute cell x-position in the grid. If &gt;= 0 this point points to the absolute cell that this constaint's component should occupy.
	 * If there's already a component in that cell they will split the cell. The flow will then continue after this cell.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param y The y-position or <code>-1</code> to disable cell positioning.
	 */
  public function set cellY(y:int):void {
    if (y < 0) {
      _cellX = -1;
    }
    _cellY = y < 0 ? 0 : y;
  }

	/** Sets the docking side. -1 means no docking.<br>
	 * Valid sides are: <code> north = 0, west = 1, south = 2, east = 3</code>.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The current side.
	 */
	public function get dockSide():int {
		return dock;
	}

  /** Sets the docking side. -1 means no docking.<br>
   * Valid sides are: <code> north = 0, west = 1, south = 2, east = 3</code>.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value -1 or 0-3.
   */
  public function set dockSide(value:int):void {
    if (value < -1 || value > 3) {
      throw new ArgumentError("Illegal dock side: " + value);
    }
    dock = value;
  }

	/** Returns if this component should have its bounds handled by an external source and not this layout manager.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The current value.
	 */
	public function get external():Boolean {
		return (flags & EXTERNAL) != 0;
	}

	/** If this boolean is true this component is not handled in any way by the layout manager and the component can have its bounds set by an external
	 * handler which is normally by the use of some <code>component.setBounds(x, y, width, height)</code> directly (for Swing).
	 * <p>
	 * The bounds <b>will not</b> affect the minimum and preferred size of the container.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param value <code>true</code> means that the bounds are not changed.
	 */
	public function set external(value:Boolean):void {
    value ? flags |= EXTERNAL : flags &= ~EXTERNAL;
	}

	/** Returns if the flow in the <b>cell</b> is in the horizontal dimension. Vertical if <code>-1</code>. Only the first
	 * component is a cell can set the flow.
	 * <p>
	 * If <code>0</code> the flow direction is inherited by from the {@link net.miginfocom.layout.LC}.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The current value.
	 */
	public function get flowX():int {
		return (flags & HAS_FLOW_X) == 0 ? 0 : (flags & FLOW_X) == 0 ? -1 : 1;
	}

	/** Sets if the flow in the <b>cell</b> is in the horizontal dimension. Vertical if <code>false</code>. Only the first
	 * component is a cell can set the flow.
	 * <p>
	 * If <code>null</code> the flow direction is inherited by from the {@link net.miginfocom.layout.LC}.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param value <code>Boolean.TRUE</code> means horizontal flow in the cell.
	 */
	public function set flowX(value:int):void {
    if (value == -1) {
      flags &= ~HAS_FLOW_X;
    }
    else {
      value ? flags |= FLOW_X : flags &= ~FLOW_X;
      flags |= HAS_FLOW_X;
    }
	}

	/** Sets how a component that is hidden (not visible) should be treated by default.
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The mode:<br>
	 * 0 == Normal. Bounds will be calculated as if the component was visible.<br>
	 * 1 == If hidden the size will be 0, 0 but the gaps remain.<br>
	 * 2 == If hidden the size will be 0, 0 and gaps set to zero.<br>
	 * 3 == If hidden the component will be disregarded completely and not take up a cell in the grid..
	 */
	public function get hideMode():int {
		return _hideMode;
	}

	/** Sets how a component that is hidden (not visible) should be treated by default.
	 * @param value The mode:<br>
	 * 0 == Normal. Bounds will be calculated as if the component was visible.<br>
	 * 1 == If hidden the size will be 0, 0 but the gaps remain.<br>
	 * 2 == If hidden the size will be 0, 0 and gaps set to zero.<br>
   * 3 == If hidden the component will be disregarded completely and not take up a cell in the grid..
   */
  public function set hideMode(value:int):void {
    if (value < -1 || value > 3) {
      throw new ArgumentError("Wrong hideMode: " + value);
    }

    _hideMode = value;
  }

	/** Returns the id used to reference this component in some constraints.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The id or <code>null</code>. May consist of a groupID and an componentID which are separated by a dot: ".". E.g. "grp1.id1".
	 * The dot should never be first or last if present.
	 */
	public function get id():String {
		return _id;
	}

	/** Sets the id used to reference this component in some constraints.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param value The id or <code>null</code>. May consist of a groupID and an componentID which are separated by a dot: ".". E.g. "grp1.id1".
	 * The dot should never be first or last if present.
	 */
	public function set id(value:String):void {
		_id = value;
	}

  /** Returns the absolute resizing in the last stage of the layout cycle. May be <code>null</code> and elements may be <code>null</code>.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return The current value. <code>null</code> or of length 4.
   */
  public function get padding():Vector.<UnitValue> {
    return _padding != null ? _padding.slice() : null;
  }

  /** Sets the absolute resizing in the last stage of the layout cycle. These values are added to the edges and can thus for
   * instance be used to grow or reduce the size or move the component an absolute number of pixels. May be <code>null</code>
   * and elements may be <code>null</code>.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value top, left, bottom right. Must be <code>null</code> or of length 4.
   */
  public function set padding(value:Vector.<UnitValue>):void {
    _padding = value != null ? value.slice() : null;
  }

	/** Returns how many cells in the grid that should be skipped <b>before</b> the component that this constraint belongs to.
	 * <p>
	 * Note that only the first component will be checked for this property.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The current value. 0 if no skip.
	 */
	public function get skip():int {
		return _skip;
	}

	/** Sets how many cells in the grid that should be skipped <b>before</b> the component that this constraint belongs to.
	 * <p>
	 * Note that only the first component will be checked for this property.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param value How many cells in the grid that should be skipped <b>before</b> the component that this constraint belongs to
	 */
	public function set skip(value:int):void {
		_skip = value;
	}

	/** Returns the number of cells the cell that this constraint's component will span in the indicated dimension. <code>1</code> is default and
	 * means that it only spans the current cell. <code>LayoutUtil.INF</code> is used to indicate a span to the end of the column/row.
	 * <p>
	 * Note that only the first component will be checked for this property.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The current value.
	 */
	public function get spanX():int {
		return _spanX;
	}

	/** Sets the number of cells the cell that this constraint's component will span in the indicated dimension. <code>1</code> is default and
	 * means that it only spans the current cell. <code>LayoutUtil.INF</code> is used to indicate a span to the end of the column/row.
	 * <p>
	 * Note that only the first component will be checked for this property.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param value The number of cells to span (i.e. merge).
	 */
	public function set spanX(value:int):void {
		_spanX = value;
	}

	/** Returns the number of cells the cell that this constraint's component will span in the indicated dimension. <code>1</code> is default and
	 * means that it only spans the current cell. <code>LayoutUtil.INF</code> is used to indicate a span to the end of the column/row.
	 * <p>
	 * Note that only the first component will be checked for this property.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The current value.
	 */
	public function get spanY():int {
		return _spanY;
	}

	/** Sets the number of cells the cell that this constraint's component will span in the indicated dimension. <code>1</code> is default and
	 * means that it only spans the current cell. <code>LayoutUtil.INF</code> is used to indicate a span to the end of the column/row.
	 * <p>
	 * Note that only the first component will be checked for this property.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param value The number of cells to span (i.e. merge).
	 */
	public function set spanY(value:int):void {
		_spanY = value;
	}

	/** "pushx" indicates that the column that this component is in (this first if the component spans) should default to growing.
	 * If any other column has been set to grow this push value on the component does nothing as the column's explicit grow weight
	 * will take precedence. Push is normally used when the grid has not been defined in the layout.
	 * <p>
	 * If multiple components in a column has push weights set the largest one will be used for the column.
	 * @return The current push value. Default is <code>null</code>.
	 */
	public function get pushX():Number {
		return _pushX;
	}

	/** "pushx" indicates that the column that this component is in (this first if the component spans) should default to growing.
	 * If any other column has been set to grow this push value on the component does nothing as the column's explicit grow weight
	 * will take precedence. Push is normally used when the grid has not been defined in the layout.
	 * <p>
	 * If multiple components in a column has push weights set the largest one will be used for the column.
	 * @param weight The new push value. Default is <code>null</code>.
	 */
	public function set pushX(weight:Number):void {
		_pushX = weight;
	}

	/** "pushx" indicates that the row that this component is in (this first if the component spans) should default to growing.
	 * If any other row has been set to grow this push value on the component does nothing as the row's explicit grow weight
	 * will take precedence. Push is normally used when the grid has not been defined in the layout.
	 * <p>
	 * If multiple components in a row has push weights set the largest one will be used for the row.
	 * @return The current push value. Default is <code>null</code>.
	 */
	public function get pushY():Number {
		return _pushY;
	}

	/** "pushx" indicates that the row that this component is in (this first if the component spans) should default to growing.
	 * If any other row has been set to grow this push value on the component does nothing as the row's explicit grow weight
	 * will take precedence. Push is normally used when the grid has not been defined in the layout.
	 * <p>
	 * If multiple components in a row has push weights set the largest one will be used for the row.
	 * @param value The new push value. Default is <code>null</code>.
	 */
	public function set pushY(value:Number):void {
		_pushY = value;
	}

	/** Returns in how many parts the current cell (that this constraint's component will be in) should be split in. If for instance
	 * it is split in two, the next component will also share the same cell. Note that the cell can also span a number of
	 * cells, which means that you can for instance span three cells and split that big cell for two components. Split can be
	 * set to a very high value to make all components in the same row/column share the same cell (e.g. <code>LayoutUtil.INF</code>).
	 * <p>
	 * Note that only the first component will be checked for this property.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The current value.
	 */
	public function get split():int {
		return _split;
	}

	/** Sets in how many parts the current cell (that this constraint's component will be in) should be split in. If for instance
	 * it is split in two, the next component will also share the same cell. Note that the cell can also span a number of
	 * cells, which means that you can for instance span three cells and split that big cell for two components. Split can be
	 * set to a very high value to make all components in the same row/column share the same cell (e.g. <code>LayoutUtil.INF</code>).
	 * <p>
	 * Note that only the first component will be checked for this property.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param value The number of parts (i.e. component slots) the cell should be divided into.
	 */
	public function set split(value:int):void {
		_split = value;
	}

	/** Tags the component with metadata. Currently only used to tag buttons with for instance "cancel" or "ok" to make them
	 * show up in the correct order depending on platform. See {@link PlatformDefaults#buttonOrder(String)} for information.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The current value. May be <code>null</code>.
	 */
	public function get tag():String {
		return _tag;
	}

	/** Optinal tag that gives more context to this constraint's component. It is for instance used to tag buttons in a
	 * button bar with the button type such as "ok", "help" or "cancel".
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param tag The new tag. May be <code>null</code>.
	 */
	public function set tag(tag:String):void {
		_tag = tag;
	}

	/** Returns if the flow should wrap to the next line/column <b>after</b> the component that this constraint belongs to.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The current value.
	 */
	public function get wrap():Boolean {
		return _wrap != null;
	}

	/** Sets if the flow should wrap to the next line/column <b>after</b> the component that this constraint belongs to.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param value <code>true</code> means wrap after.
	 */
	public function set wrap(value:Boolean):void {
		_wrap = value ? (_wrap || DEF_GAP) : null;
	}

	/** Returns the wrap size if it is a custom size. If wrap was set to true with {@link #wrap(Boolean)} then this method will
	 * return <code>null</code> since that means that the gap size should be the default one as defined in the rows spec.
	 * @return The custom gap size. NOTE! Will return <code>null</code> for both no wrap <b>and</b> default wrap.
	 * @see #wrap()
	 * @see #wrap(Boolean)
	 * @since 2.4.2
	 */
	public function get wrapGapSize():BoundSize {
		return _wrap == DEF_GAP ? null : _wrap;
	}

	/** Set the wrap size and turns wrap on if <code>!= null</code>.
	 * @param value The custom gap size. NOTE! <code>null</code> will not turn on or off wrap, it will only set the wrap gap size to "default".
	 * A non-null value will turn on wrap though.
	 * @see #wrap()
	 * @see #wrap(Boolean)
	 * @since 2.4.2
	 */
	public function set wrapGapSize(value:BoundSize):void {
		_wrap = value == null ? (_wrap != null ? DEF_GAP : null) : value;
	}

	/** Returns if the flow should wrap to the next line/column <b>before</b> the component that this constraint belongs to.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return The current value.
	 */
	public function get newline():Boolean {
		return _newline != null;
	}

	/** Sets if the flow should wrap to the next line/column <b>before</b> the component that this constraint belongs to.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param b <code>true</code> means wrap before.
	 */
	public function set newline(b:Boolean):void {
		_newline = b ? (_newline == null ? DEF_GAP : _newline) : null;
	}

	/** Returns the newline size if it is a custom size. If newline was set to true with {@link #newline(Boolean)} then this method will
	 * return <code>null</code> since that means that the gap size should be the default one as defined in the rows spec.
	 * @return The custom gap size. NOTE! Will return <code>null</code> for both no newline <b>and</b> default newline.
	 * @see #newline()
	 * @see #newline(Boolean)
	 * @since 2.4.2
	 */
	public function get newlineGapSize():BoundSize {
		return _newline == DEF_GAP ? null : _newline;
	}

	/** Set the newline size and turns newline on if <code>!= null</code>.
	 * @param s The custom gap size. NOTE! <code>null</code> will not turn on or off newline, it will only set the newline gap size to "default".
	 * A non-null value will turn on newline though.
	 * @see #newline()
	 * @see #newline(Boolean)
	 * @since 2.4.2
	 */
	public function set newlineGapSize(s:BoundSize):void {
		_newline = s == null ? (_newline != null ? DEF_GAP : null) : s;
	}
}
}