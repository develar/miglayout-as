package net.miginfocom.layout {
final internal class FlowSizeSpec {
  internal var sizes:Vector.<Vector.<int>>;  // [row/col index][min, pref, max]
  internal var resConstsInclGaps:Vector.<ResizeConstraint>;  // [row/col index]

  function FlowSizeSpec(sizes:Vector.<Vector.<int>>, resConstsInclGaps:Vector.<ResizeConstraint>) {
    this.sizes = sizes;
    this.resConstsInclGaps = resConstsInclGaps;
  }

  /**
   * @param constraints The constraints for the columns or rows. Last index will be used of <code>fromIx + len</code> is greater than this array's length.
   * @param targetSize The size to try to meet.
   * @param defGrow The default grow weight if the constraints does not have anyone that will grow. Comes from "push" in the CC.
   * @param fromIx
   * @param len
   * @param sizeType
   * @param eagerness How eager the algorithm should be to try to expand the sizes.
   * <ul>
   * <li>0 - Grow only rows/columns which have the <code>sizeType</code> set to be the containing components AND which has a grow weight &gt; 0.
   * <li>1 - Grow only rows/columns which have the <code>sizeType</code> set to be the containing components AND which has a grow weight &gt; 0 OR unspecified.
   * <li>2 - Grow all rows/columns that have a grow weight &gt; 0.
   * <li>3 - Grow all rows/columns that have a grow weight &gt; 0 OR unspecified.
   * </ul>
   * @return The new size.
   */
  internal function expandSizes(constraints:Vector.<CellConstraint>, defGrow:Vector.<Number>, targetSize:int, fromIx:int, len:int, sizeType:int, eagerness:int):int {
    var resConstr:Vector.<ResizeConstraint> = new Vector.<ResizeConstraint>(len, true);
    var sizesToExpand:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(len, true);
    var i:int;
    for (i = 0; i < len; i++) {
      var minPrefMax:Vector.<int> = sizes[i + fromIx];
      sizesToExpand[i] = new <int>[minPrefMax[sizeType], minPrefMax[LayoutUtil.PREF], minPrefMax[LayoutUtil.MAX]];

      if (eagerness <= 1 && i % 2 == 0) { // (i % 2 == 0) means only odd indexes, which is only rows/col indexes and not gaps.
        var cIx:int = (i + fromIx - 1) >> 1;
        var sz:BoundSize = constraints == null || constraints.length == 0 ? BoundSize.NULL_SIZE : LayoutUtil.getIndexSafe(constraints, cIx).size;
        if ((sizeType == LayoutUtil.MIN && sz.min != null && sz.min.unit != UnitValue.MIN_SIZE) ||
            (sizeType == LayoutUtil.PREF && sz.preferred != null && sz.preferred.unit != UnitValue.PREF_SIZE)) {
          continue;
        }
      }
      resConstr[i] = LayoutUtil.getIndexSafe2(resConstsInclGaps, i + fromIx);
    }

    var growW:Vector.<Number> = (eagerness == 1 || eagerness == 3) ? Grid.extractSubArray(constraints, defGrow, fromIx, len) : null;
    var newSizes:Vector.<int> = LayoutUtil.calculateSerial(sizesToExpand, resConstr, growW, LayoutUtil.PREF, targetSize);
    var newSize:int = 0;

    for (i = 0; i < len; i++) {
      var s:int = newSizes[i];
      sizes[i + fromIx][sizeType] = s;
      newSize += s;
    }
    return newSize;
  }
}
}
