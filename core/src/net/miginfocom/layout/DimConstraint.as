package net.miginfocom.layout {
/** A simple value holder for a constraint for one dimension.
 */
public final class DimConstraint {
  /** How this entity can be resized in the dimension that this constraint represents.
   */
  internal const resize:ResizeConstraint = new ResizeConstraint();

  // Look at the properties' getter/setter methods for explanation

  private var _sizeGroup:String;            // A "context" compared with equals.

  private var _size:BoundSize = BoundSize.NULL_SIZE;     // Min, pref, max. Never null, but sizes can be null.

  private var _gapBefore:BoundSize, _gapAfter:BoundSize;

  private var _align:UnitValue;


  // **************  Only applicable on components! *******************

  private var _endGroup:String;            // A "context" compared with equals.


  // **************  Only applicable on rows/columns! *******************

  private var _fill:Boolean;

  private var _noGrid:Boolean;

  /** Empty constructor.
   */
  public function DimConstraint() {
  }

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

  public function getAlignOrDefault(isCols:Boolean):UnitValue {
    if (_align != null) {
      return _align;
    }

    if (isCols) {
      return UnitValue.LEADING;
    }

    return _fill || !PlatformDefaults.defaultRowAlignmentBaseline ? UnitValue.CENTER : UnitValue.BASELINE_IDENTITY;
  }

  /** Returns the alignment used either as a default value for sub-entities or for this entity.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return The alignment.
   */
  public function get align():UnitValue {
    return _align;
  }

  /** Sets the alignment used wither as a default value for sub-entities or for this entity.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The new shrink priority. E.g. {@link UnitValue#CENTER} or {@link net.miginfocom.layout.UnitValue#LEADING}.
   */
  public function set align(value:UnitValue):void {
    _align = value;
  }

  /** Returns the gap after this entity. The gap is an empty space and can have a min/preferred/maximum size so that it can shrink and
   * grow depending on available space. Gaps are against other entities' edges and not against other entities' gaps.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return The gap after this entity
   */
  public function get gapAfter():BoundSize {
    return _gapAfter;
  }

  /** Sets the gap after this entity. The gap is an empty space and can have a min/preferred/maximum size so that it can shrink and
   * grow depending on available space. Gaps are against other entities' edges and not against other entities' gaps.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The new gap.
   * @see net.miginfocom.layout.ConstraintParser#parseBoundSize(String, boolean, boolean).
   */
  public function set gapAfter(value:BoundSize):void {
    _gapAfter = value;
  }

  internal function get hasGapAfter():Boolean {
    return _gapAfter != null && !_gapAfter.isUnset;
  }

  internal function get gapAfterPush():Boolean {
    return _gapAfter != null && _gapAfter.gapPush;
  }

  /** Returns the gap before this entity. The gap is an empty space and can have a min/preferred/maximum size so that it can shrink and
   * grow depending on available space. Gaps are against other entities' edges and not against other entities' gaps.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return The gap before this entity
   */
  public function get gapBefore():BoundSize {
    return _gapBefore;
  }

  /** Sets the gap before this entity. The gap is an empty space and can have a min/preferred/maximum size so that it can shrink and
   * grow depending on available space. Gaps are against other entities' edges and not against other entities' gaps.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The new gap.
   * @see net.miginfocom.layout.ConstraintParser#parseBoundSize(String, boolean, boolean).
   */
  public function set gapBefore(value:BoundSize):void {
    _gapBefore = value;
  }

  internal function get hasGapBefore():Boolean {
    return _gapBefore != null && !_gapBefore.isUnset;
  }

  internal function get gapBeforePush():Boolean {
    return _gapBefore != null && _gapBefore.gapPush;
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
    }
    _size = value;
  }

  /** Returns the size group that this entity should be in for the dimension that this object is describing.
   * If this constraint is in a size group that is specified here. <code>null</code> means no size group
   * and all other values are legal. Comparison with .equals(). Components/columnss/rows in the same size group
   * will have the same min/preferred/max size; that of the largest in the group for the first two and the
   * smallest for max.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return The current size group. May be <code>null</code>.
   */
  public function get sizeGroup():String {
    return _sizeGroup;
  }

  /** Sets the size group that this entity should be in for the dimension that this object is describing.
   * If this constraint is in a size group that is specified here. <code>null</code> means no size group
   * and all other values are legal. Comparison with .equals(). Components/columnss/rows in the same size group
   * will have the same min/preferred/max size; that of the largest in the group for the first two and the
   * smallest for max.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The new size group. <code>null</code> disables size grouping.
   */
  public function set sizeGroup(value:String):void {
    _sizeGroup = value;
  }

  // **************  Only applicable on components ! *******************

  /** Returns the end group that this entity should be in for the demension that this object is describing.
   * If this constraint is in an end group that is specified here. <code>null</code> means no end group
   * and all other values are legal. Comparison with .equals(). Components in the same end group
   * will have the same end coordinate.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return The current end group. <code>null</code> may be returned.
   */
  public function get endGroup():String {
    return _endGroup;
  }

  /** Sets the end group that this entity should be in for the demension that this object is describing.
   * If this constraint is in an end group that is specified here. <code>null</code> means no end group
   * and all other values are legal. Comparison with .equals(). Components in the same end group
   * will have the same end coordinate.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value The new end group. <code>null</code> disables end grouping.
   */
  public function set endGroup(value:String):void {
    _endGroup = value;
  }

  // **************  Not applicable on components below ! *******************

  /** Returns if the component in the row/column that this constraint should default be grown in the same dimension that
   * this constraint represents (width for column and height for a row).
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return code>true</code> means that components should grow.
   */
  public function get fill():Boolean {
    return _fill;
  }

  /** Sets if the component in the row/column that this constraint should default be grown in the same dimension that
   * this constraint represents (width for column and height for a row).
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value <code>true</code> means that components should grow.
   */
  public function set fill(value:Boolean):void {
    _fill = value;
  }

  /** Returns if the row/column should default to flow and not to grid behaviour. This means that the whole row/column
   * will be one cell and all components will end up in that cell.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>true</code> means that the whole row/column should be one cell.
   */
  public function get noGrid():Boolean {
    return _noGrid;
  }

  /** Sets if the row/column should default to flow and not to grid behaviour. This means that the whole row/column
   * will be one cell and all components will end up in that cell.
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @param value <code>true</code> means that the whole row/column should be one cell.
   */
  public function set noGrid(value:Boolean):void {
    _noGrid = value;
  }

  /** Returns the gaps as pixel values.
   * @param parent The parent. Used to get the pixel values.
   * @param defGap The default gap to use if there is no gap set on this object (i.e. it is null).
   * @param refSize The reference size used to get the pixel sizes.
   * @param before IF it is the gap before rather than the gap after to return.
   * @return The [min,preferred,max] sizes for the specified gap. Uses {@link net.miginfocom.layout.LayoutUtil#NOT_SET}
   * for gap sizes that are <code>null</code>. Returns <code>null</code> if there was no gap specified. A new and free to use array.
   */
  internal function getRowGaps(parent:ContainerWrapper, defGap:BoundSize, refSize:int, before:Boolean):Vector.<int> {
    var gap:BoundSize = before ? _gapBefore : _gapAfter;
    if (gap == null || gap.isUnset) {
      gap = defGap;
    }

    if (gap == null || gap.isUnset) {
      return null;
    }

    var ret:Vector.<int> = new Vector.<int>(3, true);
    var uv:UnitValue;
    for (var i:int = LayoutUtil.MIN; i <= LayoutUtil.MAX; i++) {
      ret[i] = (uv = gap.getSize(i)) != null ? uv.getPixels(refSize, parent, null) : LayoutUtil.NOT_SET;
    }
    return ret;
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
  internal function getComponentGaps(parent:ContainerWrapper, comp:ComponentWrapper, adjGap:BoundSize, adjacentComp:ComponentWrapper,
                                     tag:String, refSize:int, adjacentSide:int, isLTR:Boolean):Vector.<int> {
    var gap:BoundSize = adjacentSide < 2 ? _gapBefore : _gapAfter;

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

  // ************************************************
  // Persistence Delegate and Serializable combined.
  // ************************************************

  //private function readResolve():Object {
  //	return LayoutUtil.getSerializedObject(this);
  //}
  //
  //public function readExternal(in:ObjectInput):void , ClassNotFoundException
  //{
  //	LayoutUtil.setSerializedObject(this, LayoutUtil.readAsXML(in));
  //}
  //
  //public function writeExternal(out:ObjectOutput):void {
  //	if (getClass() == DimConstraint.class)
  //		LayoutUtil.writeAsXML(out, this);
  //}
}
}