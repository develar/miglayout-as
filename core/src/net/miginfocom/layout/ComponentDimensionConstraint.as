package net.miginfocom.layout {
public final class ComponentDimensionConstraint extends DimConstraint {
  /** End group that this entity should be in for the dimension that this object is describing.
   * If this constraint is in an end group that is specified here. <code>null</code> means no end group
   * and all other values are legal. Components in the same end group
   * will have the same end coordinate.
   */
  public var endGroup:String;

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
                                     tag:String, refSize:int, adjacentSide:int, isLTR:Boolean, componentGap:BoundSize):Vector.<int> {
    var gap:BoundSize = adjacentSide < 2 ? gapBefore : gapAfter;
    var hasGap:Boolean = gap != null && gap.gapPush;
    if ((gap == null || gap.isUnset) && (adjGap == null || adjGap.isUnset) && comp != null) {
      if (componentGap == null) {
        gap = PlatformDefaults.getDefaultComponentGap(comp, adjacentComp, adjacentSide + 1, tag, isLTR);
      }
      else {
        gap = adjacentComp == null ? null : componentGap;
      }
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
