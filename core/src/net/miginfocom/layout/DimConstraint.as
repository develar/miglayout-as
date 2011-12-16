package net.miginfocom.layout {
/** A simple value holder for a constraint for one dimension.
 */
[Abstract]
internal class DimConstraint {
  /** How this entity can be resized in the dimension that this constraint represents.
   */
  internal const resize:ResizeConstraint = new ResizeConstraint();

  /** Size group that this entity should be in for the dimension that this object is describing.
   * If this constraint is in a size group that is specified here. <code>null</code> means no size group
   * and all other values are legal. Components/columns/rows in the same size group
   * will have the same min/preferred/max size; that of the largest in the group for the first two and the
   * smallest for max.
   */
  public var sizeGroup:String;

  /** Alignment used either as a default value for sub-entities or for this entity.
   */
  public var align:UnitValue;

  private var _size:BoundSize = BoundSize.NULL_SIZE;     // Min, pref, max. Never null, but sizes can be null.

  /** Gap before this entity. The gap is an empty space and can have a min/preferred/maximum size so that it can shrink and
   * grow depending on available space. Gaps are against other entities' edges and not against other entities' gaps.
   */
  public var gapBefore:BoundSize;

  /** Gap after this entity. The gap is an empty space and can have a min/preferred/maximum size so that it can shrink and
   * grow depending on available space. Gaps are against other entities' edges and not against other entities' gaps.
   */
  public var gapAfter:BoundSize;

  /** Returns the grow priority. Relative priority is used for determining which entities gets the extra space first.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return The grow priority.
   */
  public function get growPriority():int {
    return resize.growPrio;
  }

  /** Sets the grow priority. Relative priority is used for determining which entities gets the extra space first.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The new grow priority.
   */
  public function set growPriority(value:int):void {
    resize.growPrio = value;
  }

  /** Returns the grow weight.<p>
   * Grow weight is how flexible the entity should be, relative to other entities, when it comes to growing. <code>null</code> or
   * zero mean it will never grow. An entity that has twice the grow weight compared to another entity will get twice
   * as much of available space.
   * <p>
   * GrowWeight are only compared within the same GrowPrio.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return The current grow weight.
   */
  public function get grow():Number {
    return resize.grow;
  }

  /** Sets the grow weight.<p>
   * Grow weight is how flexible the entity should be, relative to other entities, when it comes to growing. <code>null</code> or
   * zero mean it will never grow. An entity that has twice the grow weight compared to another entity will get twice
   * as much of available space.
   * <p>
   * GrowWeight are only compared within the same GrowPrio.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param weight The new grow weight.
   */
  public function set grow(weight:Number):void {
    resize.grow = weight;
  }

  /** Returns the shrink priority. Relative priority is used for determining which entities gets smaller first when space is scarce.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return The shrink priority.
   */
  public function get shrinkPriority():int {
    return resize.shrinkPrio;
  }

  /** Sets the shrink priority. Relative priority is used for determining which entities gets smaller first when space is scarce.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param p The new shrink priority.
   */
  public function set shrinkPriority(p:int):void {
    resize.shrinkPrio = p;
  }

  /** Returns the shrink priority. Relative priority is used for determining which entities gets smaller first when space is scarce.
   * Shrink weight is how flexible the entity should be, relative to other entities, when it comes to shrinking. <code>null</code> or
   * zero mean it will never shrink (default). An entity that has twice the shrink weight compared to another entity will get twice
   * as much of available space.
   * <p>
   * Shrink(Weight) are only compared within the same ShrinkPrio.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return The current shrink weight.
   */
  public function get shrink():Number {
    return resize.shrink;
  }

  /** Sets the shrink priority. Relative priority is used for determining which entities gets smaller first when space is scarce.
   * Shrink weight is how flexible the entity should be, relative to other entities, when it comes to shrinking. <code>null</code> or
   * zero mean it will never shrink (default). An entity that has twice the shrink weight compared to another entity will get twice
   * as much of available space.
   * <p>
   * Shrink(Weight) are only compared within the same ShrinkPrio.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The new shrink weight.
   */
  public function set shrink(value:Number):void {
    resize.shrink = value;
  }

  internal function get gapAfterPush():Boolean {
    return gapAfter != null && gapAfter.gapPush;
  }

  internal function get gapBeforePush():Boolean {
    return gapBefore != null && gapBefore.gapPush;
  }

  /** Returns the min/preferred/max size for the entity in the dimension that this object describes.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return The current size. Never <code>null</code> since v3.5.
   * @see net.miginfocom.layout.ConstraintParser#parseBoundSize(String, boolean, boolean).
   */
  public function get size():BoundSize {
    return _size;
  }

  /** Sets the min/preferred/max size for the entity in the dimension that this object describes.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The new size. May be <code>null</code>.
   */
  public function set size(value:BoundSize):void {
    if (value != null) {
      value.checkNotLinked();
      _size = value;
    }
    else {
      _size = BoundSize.NULL_SIZE;
    }
  }

  /** Returns the gaps as pixel values.
   * @param parent The parent. Used to get the pixel values.
   * @param comp The component that the gap is for. If not for a component it is <code>null</code>.
   * @param adjGap The gap that the adjacent component, if any, has towards <code>comp</code>.
   * @param adjacentComp The adjacent component if any. May be <code>null</code>.
   * @param refSize The reference size used to get the pixel sizes.
   * @param adjacentSide What side the <code>adjacentComp</code> is on. 0 = top, 1 = left, 2 = bottom, 3 = right.
   * @param tag The tag string that the component might be tagged with in the component constraints. May be <code>null</code>.
   * @param isLTR If it is left-to-right.
   * @return The [min,preferred,max] sizes for the specified gap. Uses {@link net.miginfocom.layout.LayoutUtil#NOT_SET}
   * for gap sizes that are <code>null</code>. Returns <code>null</code> if there was no gap specified. A new and free to use array.
   */
  internal function getComponentGaps(parent:ContainerWrapper, comp:ComponentWrapper, adjGap:BoundSize, adjacentComp:ComponentWrapper, tag:String, refSize:int, adjacentSide:int, isLTR:Boolean):Vector.<int> {
    var gap:BoundSize = adjacentSide < 2 ? gapBefore : gapAfter;
    var hasGap:Boolean = gap != null && gap.gapPush;
    if ((gap == null || gap.isUnset) && (adjGap == null || adjGap.isUnset) && comp != null) {
      gap = PlatformDefaults.getDefaultComponentGap(comp, adjacentComp, adjacentSide + 1, tag, isLTR);
    }

    if (gap == null) {
      return hasGap ? new <int>[0, 0, LayoutUtil.NOT_SET] : null;
    }

    var ret:Vector.<int> = new <int>[3];
    var uv:UnitValue;
    for (var i:int = LayoutUtil.MIN; i <= LayoutUtil.MAX; i++) {
      ret[i] = (uv = gap.getSize(i)) != null ? uv.getPixels(refSize, parent, null) : LayoutUtil.NOT_SET;
    }
    return ret;
  }
}
}