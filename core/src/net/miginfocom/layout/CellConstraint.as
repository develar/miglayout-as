package net.miginfocom.layout {
public final class CellConstraint extends DimConstraint {
  /** If the component in the row/column that this constraint should default be grown in the same dimension that
   * this constraint represents (width for column and height for a row).
   */
  public var fill:Boolean;

  /** Returns if the row/column should default to flow and not to grid behaviour. This means that the whole row/column
   * will be one cell and all components will end up in that cell.
   */
  public var noGrid:Boolean;

  public function getAlignOrDefault(isHor:Boolean):UnitValue {
    if (align != null) {
      return align;
    }

    if (isHor) {
      return UnitValue.LEADING;
    }

    return fill || !PlatformDefaults.defaultRowAlignmentBaseline ? UnitValue.CENTER : UnitValue.BASELINE_IDENTITY;
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
    var gap:BoundSize = before ? gapBefore : gapAfter;
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
}
}
