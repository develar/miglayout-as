package net.miginfocom.layout {
public class CCBuilder {
  // copied from ResizeConstraint due to flex compiler bug: public function growX(value:Number = ResizeConstraint.WEIGHT_100):CCBuilder [core (core)] Parameter initializer unknown or is not a compile-time constant.)
  private static const WEIGHT_100:Number = 100;

  internal const cc:CC = new CC();

  public function to():CC {
    return cc;
  }

  /** Specifies that the component should be put in the end group <code>s</code> and will thus share the same ending
   * coordinate as them within the group.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param s A name to associate on the group that should be the same for other rows/columns in the same group.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function endGroupX(s:String):CCBuilder {
    cc.horizontal.endGroup = s;
    return this;
  }

  /** Specifies that the component should be put in the size group <code>s</code> and will thus share the same size
   * as them within the group.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value A name to associate on the group that should be the same for other rows/columns in the same group.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function sizeGroupX(value:String):CCBuilder {
    cc.horizontal.sizeGroup = value;
    return this;
  }

  /** The minimum size for the component. The value will override any value that is set on the component itself.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The size expressed as a <code>UnitValue</code>. E.g. "100px" or "200mm".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function minWidth(value:String):CCBuilder {
    cc.horizontal.size = LayoutUtil.derive(cc.horizontal.size, ConstraintParser.parseUnitValue(value, null, true), null, null);
    return this;
  }

  /** The size for the component as a min and/or preferred and/or maximum size. The value will override any value that is set on
   * the component itself.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The size expressed as a <code>BoundSize</code>. E.g. "50:100px:200mm" or "100px".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function width(value:String):CCBuilder {
    cc.horizontal.size = ConstraintParser.parseBoundSize(value, false, true);
    return this;
  }

  /** The maximum size for the component. The value will override any value that is set on the component itself.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The size expressed as a <code>UnitValue</code>. E.g. "100px" or "200mm".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function maxWidth(value:String):CCBuilder {
    cc.horizontal.size = LayoutUtil.derive(cc.horizontal.size, null, null, ConstraintParser.parseUnitValue(value, null, true));
    return this;
  }

  /** The horizontal gap before and/or after the component. The gap is towards cell bounds and/or other component bounds.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param before The size of the gap expressed as a <code>BoundSize</code>. E.g. "50:100px:200mm" or "100px!".
   * @param after The size of the gap expressed as a <code>BoundSize</code>. E.g. "50:100px:200mm" or "100px!".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function gapX(before:String, after:String):CCBuilder {
    if (before != null) {
      cc.horizontal.gapBefore = ConstraintParser.parseBoundSize(before, true, true);
    }

    if (after != null) {
      cc.horizontal.gapAfter = ConstraintParser.parseBoundSize(after, true, true);
    }

    return this;
  }

  /** Same functionality as <code>getHorizontal().setAlign(ConstraintParser.parseUnitValue(unitValue, true))</code> only this method
   * returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param align The align keyword or for instance "100px". E.g "left", "right", "leading" or "trailing".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function alignX(align:String):CCBuilder {
    cc.horizontal.align = ConstraintParser.parseUnitValueOrAlign(align, true, null);
    return this;
  }

  /** The grow priority compared to other components in the same cell.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param p The grow priority.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function growPrioX(p:int):CCBuilder {
    cc.horizontal.growPriority = p;
    return this;
  }

  /** Grow priority for the component horizontally and optionally vertically.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param widthHeight The new shrink weight and height. 1-2 arguments, never null.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @since 3.7.2
   */
  public function growPrio(...widthHeight):CCBuilder {
    //noinspection FallthroughInSwitchStatementJS
    switch (widthHeight.length) {
      default:
        throw new ArgumentError("Illegal argument count: " + widthHeight.length);
      case 2:
        growPrioY(widthHeight[1]);
      case 1:
        growPrioX(widthHeight[0]);
    }
    return this;
  }

  /** Grow weight for the component horizontally. It default to weight <code>100</code>.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #growX(float)
   */
  public function growX(value:Number = WEIGHT_100):CCBuilder {
    cc.horizontal.grow = value;
    return this;
  }

  /** grow weight for the component horizontally and optionally vertically.
   * @since 3.7.2
   */
  public function grow(x:Number = WEIGHT_100, y:Number = WEIGHT_100):CCBuilder {
    growX(x);
    growY(y);
    return this;
  }

  /** The shrink priority compared to other components in the same cell.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param p The shrink priority.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function shrinkPrioX(p:int):CCBuilder {
    cc.horizontal.shrinkPriority = p;
    return this;
  }

  /** Shrink priority for the component horizontally and optionally vertically.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param widthHeight The new shrink weight and height. 1-2 arguments, never null.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @since 3.7.2
   */
  public function shrinkPrio(...widthHeight):CCBuilder {
    //noinspection FallthroughInSwitchStatementJS
    switch (widthHeight.length) {
      default:
        throw new ArgumentError("Illegal argument count: " + widthHeight.length);
      case 2:
        shrinkPrioY(widthHeight[1]);
      case 1:
        shrinkPrioX(widthHeight[0]);
    }
    return this;
  }

  /** Shrink weight for the component horizontally.
   * <p>
   * @param value The new shrink weight.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function shrinkX(value:Number):CCBuilder {
    cc.horizontal.shrink = value;
    return this;
  }

  /** Shrink weight for the component horizontally and optionally vertically.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param widthHeight The new shrink weight and height. 1-2 arguments, never null.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @since 3.7.2
   */
  public function shrink(...widthHeight):CCBuilder {
    switch (widthHeight.length) {
      default:
        throw new ArgumentError("Illegal argument count: " + widthHeight.length);
      case 2:
        shrinkY(widthHeight[1]);
      case 1:
        shrinkX(widthHeight[0]);
    }
    return this;
  }

  /** The end group that this component should be placed in.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The name of the group. If <code>null</code> that means no group (default)
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function endGroupY(value:String):CCBuilder {
    cc.vertical.endGroup = value;
    return this;
  }

  /** The end group(s) that this component should be placed in.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param xy The end group for x and y respectively. 1-2 arguments, not null.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @since 3.7.2
   */
  public function endGroup(...xy):CCBuilder {
    //noinspection FallthroughInSwitchStatementJS
    switch (xy.length) {
      default:
        throw new ArgumentError("Illegal argument count: " + xy.length);
      case 2:
        endGroupY(xy[1]);
      case 1:
        endGroupX(xy[0]);
    }
    return this;
  }

  /** The size group that this component should be placed in.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param s The name of the group. If <code>null</code> that means no group (default)
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function sizeGroupY(s:String):CCBuilder {
    cc.vertical.sizeGroup = s;
    return this;
  }

  /** The size group(s) that this component should be placed in.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param xy The size group for x and y respectively. 1-2 arguments, not null.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @since 3.7.2
   */
  public function sizeGroup(...xy):CCBuilder {
    //noinspection FallthroughInSwitchStatementJS
    switch (xy.length) {
      default:
        throw new ArgumentError("Illegal argument count: " + xy.length);
      case 2:
        sizeGroupY(xy[1]);
      case 1:
        sizeGroupX(xy[0]);
    }
    return this;
  }

  /** The minimum size for the component. The value will override any value that is set on the component itself.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The size expressed as a <code>UnitValue</code>. E.g. "100px" or "200mm".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function minHeight(value:String):CCBuilder {
    cc.vertical.size = LayoutUtil.derive(cc.vertical.size, ConstraintParser.parseUnitValue(value, null, false), null, null);
    return this;
  }

  /** The size for the component as a min and/or preferred and/or maximum size. The value will override any value that is set on
   * the component itself.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param size The size expressed as a <code>BoundSize</code>. E.g. "50:100px:200mm" or "100px".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function height(size:String):CCBuilder {
    cc.vertical.size = ConstraintParser.parseBoundSize(size, false, false);
    return this;
  }

  /** The maximum size for the component. The value will override any value that is set on the component itself.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param size The size expressed as a <code>UnitValue</code>. E.g. "100px" or "200mm".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function maxHeight(size:String):CCBuilder {
    cc.vertical.size = LayoutUtil.derive(cc.vertical.size, null, null, ConstraintParser.parseUnitValue(size, null, false));
    return this;
  }

  /** The vertical gap before (normally above) and/or after (normally below) the component. The gap is towards cell bounds and/or other component bounds.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param before The size of the gap expressed as a <code>BoundSize</code>. E.g. "50:100px:200mm" or "100px!".
   * @param after The size of the gap expressed as a <code>BoundSize</code>. E.g. "50:100px:200mm" or "100px!".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function gapY(before:String, after:String):CCBuilder {
    if (before != null) {
      cc.vertical.gapBefore = ConstraintParser.parseBoundSize(before, true, false);
    }

    if (after != null) {
      cc.vertical.gapAfter = ConstraintParser.parseBoundSize(after, true, false);
    }

    return this;
  }

  /** Same functionality as <code>getVertical().setAlign(ConstraintParser.parseUnitValue(unitValue, true))</code> only this method
   * returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param align The align keyword or for instance "100px". E.g "top" or "bottom".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function alignY(align:String):CCBuilder {
    cc.vertical.align = ConstraintParser.parseUnitValueOrAlign(align, false, null);
    return this;
  }

  /** The grow priority compared to other components in the same cell.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param p The grow priority.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function growPrioY(p:int):CCBuilder {
    cc.vertical.growPriority = p;
    return this;
  }

  /** Grow weight for the component vertically. Defaults to <code>100</code>.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #growY(Float)
   */
  public function growY(v:Number = WEIGHT_100):CCBuilder {
    cc.vertical.grow = v;
    return this;
  }

  /** The shrink priority compared to other components in the same cell.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param p The shrink priority.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function shrinkPrioY(p:int):CCBuilder {
    cc.vertical.shrinkPriority = p;
    return this;
  }

  /** Shrink weight for the component horizontally.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param w The new shrink weight.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function shrinkY(w:Number):CCBuilder {
    cc.vertical.shrink = w;
    return this;
  }

  /** How this component, if hidden (not visible), should be treated.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param mode The mode. Default to the mode in the {@link net.miginfocom.layout.LC}.
   * 0 == Normal. Bounds will be calculated as if the component was visible.<br>
   * 1 == If hidden the size will be 0, 0 but the gaps remain.<br>
   * 2 == If hidden the size will be 0, 0 and gaps set to zero.<br>
   * 3 == If hidden the component will be disregarded completely and not take up a cell in the grid..
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function hideMode(mode:int):CCBuilder {
    cc.hideMode = mode;
    return this;
  }

  /** The id used to reference this component in some constraints.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param s The id or <code>null</code>. May consist of a groupID and an componentID which are separated by a dot: ".". E.g. "grp1.id1".
   * The dot should never be first or last if present.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   */
  public function id(s:String):CCBuilder {
    cc.id = s;
    return this;
  }

  /** Same functionality as {@link #tag(String tag)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param tag The new tag. May be <code>null</code>.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @see #tag(String)
   */
  public function tag(tag:String):CCBuilder {
    cc.tag = tag;
    return this;
  }

  /** Set the cell(s) that the component should occupy in the grid. Same functionality as {@link #setCellX(int col)} and
   * {@link #setCellY(int row)} together with {@link #setSpanX(int width)} and {@link #setSpanY(int height)}. This method
   * returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param colRowWidthHeight cellX, cellY, spanX, spanY repectively. 1-4 arguments, not null.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @see #setCellX(int)
   * @see #setCellY(int)
   * @see #setSpanX(int)
   * @see #setSpanY(int)
   * @since 3.7.2. Replacing cell(int, int) and cell(int, int, int, int)
   */
  public function cell(...colRowWidthHeight):CCBuilder {
    //noinspection FallthroughInSwitchStatementJS
    switch (colRowWidthHeight.length) {
      default:
        throw new ArgumentError("Illegal argument count: " + colRowWidthHeight.length);
      case 4:
        cc.spanY = colRowWidthHeight[3];
      case 3:
        cc.spanX = colRowWidthHeight[2];
      case 2:
        cc.cellY = colRowWidthHeight[1];
      case 1:
        cc.cellX = colRowWidthHeight[0];
    }
    return this;
  }

  /** Same functionality as <code>spanX(cellsX).spanY(cellsY)</code> which means this cell will span cells in both x and y.
   * This method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * Since 3.7.2 this takes an array/vararg whereas it previously only took two specific values, xSpan and ySpan.
   * @param cells spanX and spanY, when present, and in that order.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @see #setSpanY(int)
   * @see #setSpanX(int)
   * @see #spanY()
   * @see #spanX()
   * @since 3.7.2 Replaces span(int, int).
   */
  public function span(...cells):CCBuilder {
    if (cells == null || cells.length == 0) {
      cc.spanX = LayoutUtil.INF;
      cc.spanY = 1;
    } else if (cells.length == 1) {
      cc.spanX = cells[0];
      cc.spanY = 1;
    }
    else {
      cc.spanX = cells[0];
      cc.spanY = cells[1];
    }
    return this;
  }

  /** Corresponds exactly to the "gap left right top bottom" keyword.
   * @param args Same as for the "gap" keyword. Length 1-4, never null buf elements can be null.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @since 3.7.2
   */
  public function gap(...args):CCBuilder {
    //noinspection FallthroughInSwitchStatementJS
    switch (args.length) {
      default:
        throw new ArgumentError("Illegal argument count: " + args.length);
      case 4:
        gapBottom(args[3]);
      case 3:
        gapTop(args[2]);
      case 2:
        gapRight(args[1]);
      case 1:
        gapLeft(args[0]);
    }
    return this;
  }

  /** Sets the horizontal gap before the component.
   * <p>
   * Note! This is currently same as gapLeft(). This might change in 4.x.
   * @param boundsSize The size of the gap expressed as a <code>BoundSize</code>. E.g. "50:100px:200mm" or "100px!".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @since 3.7.2
   */
  public function gapBefore(boundsSize:String):CCBuilder {
    cc.horizontal.gapBefore = ConstraintParser.parseBoundSize(boundsSize, true, true);
    return this;
  }

  /** Sets the horizontal gap after the component.
   * <p>
   * Note! This is currently same as gapLeft(). This might change in 4.x.
   * @param boundsSize The size of the gap expressed as a <code>BoundSize</code>. E.g. "50:100px:200mm" or "100px!".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @since 3.7.2
   */
  public function gapAfter(boundsSize:String):CCBuilder {
    cc.horizontal.gapAfter = ConstraintParser.parseBoundSize(boundsSize, true, true);
    return this;
  }

  /** Sets the gap above the component.
   * @param boundsSize The size of the gap expressed as a <code>BoundSize</code>. E.g. "50:100px:200mm" or "100px!".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @since 3.7.2
   */
  public function gapTop(boundsSize:String):CCBuilder {
    cc.vertical.gapBefore = ConstraintParser.parseBoundSize(boundsSize, true, false);
    return this;
  }

  /** Sets the gap to the left the component.
   * @param boundsSize The size of the gap expressed as a <code>BoundSize</code>. E.g. "50:100px:200mm" or "100px!".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @since 3.7.2
   */
  public function gapLeft(boundsSize:String):CCBuilder {
    cc.horizontal.gapBefore = ConstraintParser.parseBoundSize(boundsSize, true, true);
    return this;
  }

  /** Sets the gap below the component.
   * @param boundsSize The size of the gap expressed as a <code>BoundSize</code>. E.g. "50:100px:200mm" or "100px!".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @since 3.7.2
   */
  public function gapBottom(boundsSize:String):CCBuilder {
    cc.vertical.gapAfter = ConstraintParser.parseBoundSize(boundsSize, true, false);
    return this;
  }

  /** Sets the gap to the right of the component.
   * @param boundsSize The size of the gap expressed as a <code>BoundSize</code>. E.g. "50:100px:200mm" or "100px!".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @since 3.7.2
   */
  public function gapRight(boundsSize:String):CCBuilder {
    cc.horizontal.gapAfter = ConstraintParser.parseBoundSize(boundsSize, true, true);
    return this;
  }

  /** Same functionality as {@link #spanY(int)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param cells The number of cells to span (i.e. merge).
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @see #spanY(int)
   */
  public function spanY(cells:int = 2097051):CCBuilder {
    cc.spanY = cells;
    return this;
  }

  /** Same functionality as {@link #spanX(int)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param cells The number of cells to span (i.e. merge).
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @see #spanY(int)
   */
  public function spanX(cells:int = 2097051):CCBuilder {
    cc.spanX = cells;
    return this;
  }

  /** Same functionality as <code>pushX(weightX).pushY(weightY)</code> which means this cell will push in both x and y dimensions.
   * This method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param weightX The weight used in the push.
   * @param weightY The weight used in the push.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @see #pushY(Float)
   * @see #pushX(Float)
   * @see #pushY()
   * @see #pushX()
   */
  public function push(weightX:Number = WEIGHT_100, weightY:Number = WEIGHT_100):CCBuilder {
    return pushX(weightX).pushY(weightY);
  }

  /** Same functionality as {@link #pushY(Number weight)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param weight The weight used in the push.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @see #setPushY(Float)
   */
  public function pushY(weight:Number = WEIGHT_100):CCBuilder {
    cc.pushY = weight;
    return this;
  }

  /** Same functionality as {@link #pushX(Number weight)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param weight The weight used in the push.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @see #setPushY(Float)
   */
  public function pushX(weight:Number = WEIGHT_100):CCBuilder {
    cc.pushX = weight;
    return this;
  }

  /** Same functionality as {@link #split(int parts)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param parts The number of parts (i.e. component slots) the cell should be divided into.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #split(int)
   */
  public function split(parts:int = 2097051):CCBuilder {
    cc.split = parts;
    return this;
  }

  /** Same functionality as {@link #skip(int)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param cells How many cells in the grid that should be skipped <b>before</b> the component that this constraint belongs to
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #skip(int)
   */
  public function skip(cells:int = 1):CCBuilder {
    cc.skip = cells;
    return this;
  }

  /** Same functionality as {@link #external(Boolean true)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #external(boolean)
   */
  public function external():CCBuilder {
    cc.external = true;
    return this;
  }

  /** Same functionality as {@link #flowX(Boolean .TRUE)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #setFlowX(Boolean)
   */
  public function flowX():CCBuilder {
    cc.flowX = 1;
    return this;
  }

  /** Same functionality as {@link #flowX(Boolean .FALSE)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #setFlowX(Boolean)
   */
  public function flowY():CCBuilder {
    cc.flowX = -1;
    return this;
  }
  
  /** Same functionality as {@link #newlineGapSize(BoundSize)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param gapSize The gap size that will override the gap size in the row/colum constraints if <code>!= null</code>. E.g. "5px" or "unrel".
   * If <code>null</code> or <code>""</code> the newline size will be set to the default size and turned on. This is different compared to
   * {@link #setNewlineGapSize(BoundSize)}.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #setNewlineGapSize(BoundSize)
   */
  public function newline(gapSize:String = null):CCBuilder {
    var bs:BoundSize;
    if (gapSize == null || (bs = ConstraintParser.parseBoundSize(gapSize, true, cc.flowX == -1)) == null) {
      cc.newline = true;
    }
    else {
      cc.newlineGapSize = bs;
    }
    return this;
  }

  /** Same functionality as {@link #wrapGapSize(BoundSize)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param gapSize The gap size that will override the gap size in the row/colum constraints if <code>!= null</code>. E.g. "5px" or "unrel".
   * If <code>null</code> or <code>""</code> the wrap size will be set to the default size and turned on. This is different compared to
   * {@link #setWrapGapSize(BoundSize)}.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #setWrapGapSize(BoundSize)
   */
  public function wrap(gapSize:String = null):CCBuilder {
    var bs:BoundSize;
    if (gapSize == null || (bs = ConstraintParser.parseBoundSize(gapSize, true, cc.flowX == -1)) == null) {
      cc.wrap = true;
    }
    else {
      cc.wrapGapSize = bs;
    }
    return this;
  }

  /** Same functionality as {@link CC#dockSide(int 0)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see CC#dockSide(int)
   */
  public function dockNorth():CCBuilder {
    cc.dockSide = 0;
    return this;
  }

  /** Same functionality as {@link CC#dockSide(int 1)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see CC#dockSide(int)
   */
  public function dockWest():CCBuilder {
    cc.dockSide = 1;
    return this;
  }

  /** Same functionality as {@link CC#dockSide(int 2)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see CC#dockSide(int)
   */
  public function dockSouth():CCBuilder {
    cc.dockSide = 2;
    return this;
  }

  /** Same functionality as {@link CC#dockSide(int 3)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see CC#dockSide(int)
   */
  public function dockEast():CCBuilder {
    cc.dockSide = 3;
    return this;
  }

  /** Sets the x-coordinate for the component. This is used to set the x coordinate position to a specific value. The component
   * bounds is still precalculated to the grid cell and this method should be seen as a way to correct the x position.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param x The x position as a UnitValue. E.g. "10" or "40mm" or "container.x+10".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #pos(UnitValue[])
   * @see CC#boundsInGrid(boolean)
   */
  public function x(x:String):CCBuilder {
    return corrPos(x, 0);
  }

  /** Sets the y-coordinate for the component. This is used to set the y coordinate position to a specific value. The component
   * bounds is still precalculated to the grid cell and this method should be seen as a way to correct the y position.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param y The y position as a UnitValue. E.g. "10" or "40mm" or "container.x+10".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #pos(UnitValue[])
   * @see CC#boundsInGrid(boolean)
   */
  public function y(y:String):CCBuilder {
    return corrPos(y, 1);
  }

  /** Sets the x2-coordinate for the component (right side). This is used to set the x2 coordinate position to a specific value. The component
   * bounds is still precalculated to the grid cell and this method should be seen as a way to correct the x position.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param x2 The x2 side's position as a UnitValue. E.g. "10" or "40mm" or "container.x2 - 10".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #pos(UnitValue[])
   * @see CC#boundsInGrid(boolean)
   */
  public function x2(x2:String):CCBuilder {
    return corrPos(x2, 2);
  }

  /** Sets the y2-coordinate for the component (bottom side). This is used to set the y2 coordinate position to a specific value. The component
   * bounds is still precalculated to the grid cell and this method should be seen as a way to correct the y position.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param y2 The y2 side's position as a UnitValue. E.g. "10" or "40mm" or "container.x2 - 10".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #pos(UnitValue[])
   * @see CC#boundsInGrid(boolean)
   */
  public function y2(y2:String):CCBuilder {
    return corrPos(y2, 3);
  }

  private function corrPos(uv:String, ix:int):CCBuilder {
    var pos:Vector.<UnitValue> = cc.pos;
    if (pos == null) {
      pos = new Vector.<UnitValue>(4, true);
      cc.pos = pos;
    }
    pos[ix] = ConstraintParser.parseUnitValue(uv, null, (ix % 2 == 0));
    cc.boundsInGrid = true;
    return this;
  }

  /** Same functionality as {@link #x(String x)}, {@link #y(String y)}, {@link #y2(String y)} and {@link #y2(String y)} toghether.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param x The x position as a UnitValue. E.g. "10" or "40mm" or "container.x+10".
   * @param y The y position as a UnitValue. E.g. "10" or "40mm" or "container.x+10".
   * @param x2 The x2 side's position as a UnitValue. E.g. "10" or "40mm" or "container.x2 - 10".
   * @param y2 The y2 side's position as a UnitValue. E.g. "10" or "40mm" or "container.x2 - 10".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #pos(UnitValue[])
   */
  public function pos(x:String, y:String, x2:String = null, y2:String = null):CCBuilder {
    var pos:Vector.<UnitValue> = cc.pos;
    if (pos == null) {
      pos = new Vector.<UnitValue>(4, true);
      cc.pos = pos;
    }

    pos[0] = ConstraintParser.parseUnitValue(x, null, true);
    pos[1] = ConstraintParser.parseUnitValue(y, null, false);

    if (x2 != null && y2 != null) {
      pos[2] = ConstraintParser.parseUnitValue(x2, null, true);
      pos[3] = ConstraintParser.parseUnitValue(y2, null, false);
    }

    cc.boundsInGrid = false;
    return this;
  }

  /** Same functionality as {@link CC#padding(UnitValue[])} but the unit values as absolute pixels. This method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param top The top padding that will be added to the y coordinate at the last stage in the layout.
   * @param left The top padding that will be added to the x coordinate at the last stage in the layout.
   * @param bottom The top padding that will be added to the y2 coordinate at the last stage in the layout.
   * @param right The top padding that will be added to the x2 coordinate at the last stage in the layout.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #tag(String)
   */
  public function pad(top:int, left:int, bottom:int, right:int):CCBuilder {
    cc.padding = new <UnitValue>[new UnitValue(top), new UnitValue(left), new UnitValue(bottom), new UnitValue(right)];
    return this;
  }

  /** Same functionality as <code>setPadding(ConstraintParser.parseInsets(pad, false))}</code> only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param pad The string to parse. E.g. "10 10 10 10" or "20". If less than 4 groups the last will be used for the missing.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new ComponentConstraint().noGrid().gap().fill()</code>.
   * @see #tag(String)
   */
  public function pad2(pad:String):CCBuilder {
    cc.padding = pad != null ? ConstraintParser.parseInsets(pad, false) : null;
    return this;
  }
}
}