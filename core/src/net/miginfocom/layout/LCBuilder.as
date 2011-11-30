package net.miginfocom.layout {
// 1) getter/setter conflicts with chained method, so, extract it as separated class
// 2) reduce swf size (if client doesn't use API Creation of Constraints)
public final class LCBuilder {
  private const lc:LC = new LC();

  public function to():LC {
    return lc;
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
  public function pack(width:String = "pref", height:String = "pref"):LCBuilder {
    lc.packWidth = width != null ? ConstraintParser.parseBoundSize(width, false, false) : BoundSize.NULL_SIZE;
    lc.packHeight = height != null ? ConstraintParser.parseBoundSize(height, false, false) : BoundSize.NULL_SIZE;
    return this;
  }

  /** Sets the pack width and height alignment.
   * <p>
   * Same functionality as {@link #setPackHeightAlign(float)} and {@link #setPackWidthAlign(float)}
   * only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param alignX The pack width alignment. 0.5f is default.
   * @param alignY The pack height alignment. 0.5f is default.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @since 3.5
   */
  public final function packAlign(alignX:Number, alignY:Number):LCBuilder {
    lc.packWidthAlign = alignX;
    lc.packHeightAlign = alignY;
    return this;
  }

  /** Sets a wrap after the number of columns/rows that is defined in the {@link net.miginfocom.layout.AC}.
   * <p>
   * Same functionality as {@link #setWrapAfter(int 0)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function wrap():LCBuilder {
    lc.wrapAfter = 0;
    return this;
  }

  /** Same functionality as {@link LC#wrapAfter(int)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param count After what cell the grid should always auto wrap. If <code>0</code> the number of columns/rows in the
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function wrapAfter(count:int):LCBuilder {
    lc.wrapAfter = count;
    return this;
  }

  /** Same functionality as {@link #noCache(boolean true)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function noCache():LCBuilder {
    lc.noCache = true;
    return this;
  }

  /** Same functionality as {@link #flowX(boolean false)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function flowY():LCBuilder {
    lc.flowX = false;
    return this;
  }

  /** Same functionality as {@link #flowX(boolean true)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function flowX():LCBuilder {
    lc.flowX = true;
    return this;
  }

  /** Same functionality as {@link #fillX(boolean true)} and {@link #fillY(boolean true)} conmbined.T his method returns
   * <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function fill():LCBuilder {
    lc.fillX = true;
    lc.fillY = true;
    return this;
  }

  /** Same functionality as {@link #fillX(boolean true)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function fillX():LCBuilder {
    lc.fillX = true;
    return this;
  }

  /** Same functionality as {@link #setFillY(boolean true)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function fillY():LCBuilder {
    lc.fillY = true;
    return this;
  }

  /** Same functionality as {@link #setLeftToRight(Boolean)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param b <code>true</code> for forcing left-to-right. <code>false</code> for forcing right-to-left.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function leftToRight(value:Boolean):LCBuilder {
    lc.leftToRight = value ? 1 : -1;
    return this;
  }

  /** Same functionality as setLeftToRight(false) only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @since 3.7.2
   */
  public function rightToLeft():LCBuilder {
    lc.leftToRight = -1;
    return this;
  }

  /** Same functionality as {@link #setTopToBottom(boolean false)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function bottomToTop():LCBuilder {
    lc.topToBottom = false;
    return this;
  }

  /** Same functionality as {@link #setTopToBottom(boolean true)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @since 3.7.2
   */
  public function topToBottom():LCBuilder {
    lc.topToBottom = true;
    return this;
  }

  /** Same functionality as {@link #setNoGrid(boolean true)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function noGrid():LCBuilder {
    lc.noGrid = true;
    return this;
  }

  /** Same functionality as {@link #setVisualPadding(boolean false)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function noVisualPadding():LCBuilder {
    lc.visualPadding = false;
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
  public function insetsAll(allSides:String):LCBuilder {
    var insH:UnitValue = ConstraintParser.parseUnitValue(allSides, null, true);
    var insV:UnitValue = ConstraintParser.parseUnitValue(allSides, null, false);
    lc.insets = new <UnitValue>[insV, insH, insV, insH]; // No setter to avoid copy again
    return this;
  }

  public function insets2(s:String):LCBuilder {
    lc.insets = ConstraintParser.parseInsets(s, true);
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
  public function insets(top:String, left:String, bottom:String, right:String):LCBuilder {
    // No setter to avoid copy again
    lc.insets = new <UnitValue>[
      ConstraintParser.parseUnitValue(top, null, false),
      ConstraintParser.parseUnitValue(left, null, true),
      ConstraintParser.parseUnitValue(bottom, null, false),
      ConstraintParser.parseUnitValue(right, null, true)];
    return this;
  }

  /** Same functionality as <code>setAlignX(ConstraintParser.parseUnitValueOrAlign(unitValue, true))</code> only this method returns <code>this</code>
   * for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The align keyword or for instance "100px". E.g "left", "right", "leading" or "trailing".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @see LC#alignX(UnitValue)
   */
  public function alignX(value:String):LCBuilder {
    lc.alignX = ConstraintParser.parseUnitValueOrAlign(value, true, null);
    return this;
  }

  /** Same functionality as <code>setAlignY(ConstraintParser.parseUnitValueOrAlign(align, false))</code> only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The align keyword or for instance "100px". E.g "top" or "bottom".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @see LC#alignY(UnitValue)
   */
  public function alignY(value:String):LCBuilder {
    lc.alignY = ConstraintParser.parseUnitValueOrAlign(value, false, null);
    return this;
  }

  /** Sets both the alignX and alignY as the same time.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param ax The align keyword or for instance "100px". E.g "left", "right", "leading" or "trailing".
   * @param ay The align keyword or for instance "100px". E.g "top" or "bottom".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @see #alignX(String)
   * @see #alignY(String)
   */
  public function align(ax:String, ay:String):LCBuilder {
    if (ax != null) {
      alignX(ax);
    }

    if (ay != null) {
      alignY(ay);
    }

    return this;
  }

  /** Same functionality as <code>setGridGapX(ConstraintParser.parseBoundSize(boundsSize, true, true))</code> only this method
   * returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The <code>BoundSize</code> of the gap. This is a minimum and/or preferred and/or maximum size. E.g.
   * <code>"50:100:200"</code> or <code>"100px"</code>.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @see LC#gridGapX(BoundSize)
   */
  public function gridGapX(value:String):LCBuilder {
    lc.gridGapX = ConstraintParser.parseBoundSize(value, true, true);
    return this;
  }

  /** Same functionality as <code>setGridGapY(ConstraintParser.parseBoundSize(boundsSize, true, false))</code> only this method
   * returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The <code>BoundSize</code> of the gap. This is a minimum and/or preferred and/or maximum size. E.g.
   * <code>"50:100:200"</code> or <code>"100px"</code>.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @see #setGridGapY(BoundSize)
   */
  public function gridGapY(value:String):LCBuilder {
    lc.gridGapY = ConstraintParser.parseBoundSize(value, true, false);
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
  public function gridGap(gapx:String, gapy:String):LCBuilder {
    if (gapx != null) {
      gridGapX(gapx);
    }

    if (gapy != null) {
      gridGapY(gapy);
    }

    return this;
  }

  /** Same functionality as {@link #setDebugMillis(int repaintMillis)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The new debug repaint interval.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @see #setDebugMillis(int)
   */
  public function debug(value:int):LCBuilder {
    lc.debugMillis = value;
    return this;
  }

  /** Same functionality as {@link #setHideMode(int mode)} only this method returns <code>this</code> for chaining multiple calls.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The mode:<br>
   * 0 == Normal. Bounds will be calculated as if the component was visible.<br>
   * 1 == If hidden the size will be 0, 0 but the gaps remain.<br>
   * 2 == If hidden the size will be 0, 0 and gaps set to zero.<br>
   * 3 == If hidden the component will be disregarded completely and not take up a cell in the grid..
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   * @see #setHideMode(int)
   */
  public function hideMode(value:int):LCBuilder {
    lc.hideMode = value;
    return this;
  }

  /** The minimum width for the container. The value will override any value that is set on the container itself.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or Cheat Sheet at www.migcontainers.com.
   * @param value The width expressed as a <code>UnitValue</code>. E.g. "100px" or "200mm".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function minWidth(value:String):LCBuilder {
    ConstraintParser.minWidth(value, lc);
    return this;
  }

  /** The width for the container as a min and/or preferred and/or maximum width. The value will override any value that is set on
   * the container itself.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or Cheat Sheet at www.migcontainers.com.
   * @param value The width expressed as a <code>BoundSize</code>. E.g. "50:100px:200mm" or "100px".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function width(value:String):LCBuilder {
    lc.width = ConstraintParser.parseBoundSize(value, false, true);
    return this;
  }

  /** The maximum width for the container. The value will override any value that is set on the container itself.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or Cheat Sheet at www.migcontainers.com.
   * @param value The width expressed as a <code>UnitValue</code>. E.g. "100px" or "200mm".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function maxWidth(value:String):LCBuilder {
    ConstraintParser.maxWidth(value, lc);
    return this;
  }

  /** The minimum height for the container. The value will override any value that is set on the container itself.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or Cheat Sheet at www.migcontainers.com.
   * @param value The height expressed as a <code>UnitValue</code>. E.g. "100px" or "200mm".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function minHeight(value:String):LCBuilder {
    ConstraintParser.minHeight(value, lc);
    return this;
  }

  /** The height for the container as a min and/or preferred and/or maximum height. The value will override any value that is set on
   * the container itself.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcontainers.com.
   * @param value The height expressed as a <code>BoundSize</code>. E.g. "50:100px:200mm" or "100px".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function height(value:String):LCBuilder {
    lc.height = ConstraintParser.parseBoundSize(value, false, false);
    return this;
  }

  /**
   * The maximum height for the container. The value will override any value that is set on the container itself.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcontainers.com.
   * @param value The height expressed as a <code>UnitValue</code>. E.g. "100px" or "200mm".
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new LayoutConstraint().noGrid().gap().fill()</code>.
   */
  public function maxHeight(value:String):LCBuilder {
    ConstraintParser.maxHeight(value, lc);
    return this;
  }
}
}
