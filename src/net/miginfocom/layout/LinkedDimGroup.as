package net.miginfocom.layout {
/** A number of component wraps that share a layout "something" <b>in one dimension</b>
	 */
internal final class LinkedDimGroup {
  internal static const TYPE_SERIAL:int= 0;
  internal static const TYPE_PARALLEL:int= 1;
  internal static const TYPE_BASELINE:int = 2;

  internal var linkCtx:String;
  internal var span:int;
  private var linkType:int;
  internal var isHor:Boolean, fromEnd:Boolean;

  internal var _compWraps:Vector.<CompWrap> = new Vector.<CompWrap>();

  private var sizes:Vector.<int>;
  internal var lStart:int = 0, lSize:int = 0;  // Currently mostly for debug painting

  function LinkedDimGroup(linkCtx:String, span:int, linkType:int, isHor:Boolean, fromEnd:Boolean) {
    this.linkCtx = linkCtx;
    this.span = span;
    this.linkType = linkType;
    this.isHor = isHor;
    this.fromEnd = fromEnd;
  }

  internal function addCompWrap(cw:CompWrap):void {
    _compWraps[_compWraps.length] = cw;
    sizes = null;
  }

  internal function setCompWraps(cws:Vector.<CompWrap>):void {
    if (_compWraps != cws) {
      _compWraps = cws;
      sizes = null;
    }
  }

  internal function layout(dc:DimConstraint, start:int, size:int, spanCount:int):void {
    lStart = start;
    lSize = size;

    if (_compWraps.length == 0) {
      return;
    }

    var parent:ContainerWrapper = _compWraps[0].comp.parent;
    if (linkType == TYPE_PARALLEL) {
      Grid.layoutParallel(parent, _compWraps, dc, start, size, isHor, fromEnd);
    }
    else if (linkType == TYPE_BASELINE) {
      Grid.layoutBaseline(parent, _compWraps, dc, start, size, LayoutUtil.PREF, spanCount);
    }
    else {
      Grid.layoutSerial(parent, _compWraps, dc, start, size, isHor, spanCount, fromEnd);
    }
  }

  /** Returns the min/pref/max sizes for this cell. Returned array <b>must not be altered</b>
   * @return A shared min/pref/max array of sizes. Always of length 3 and never <code>null</code>. Will always be of type STATIC and PIXEL.
   */
  internal function getMinPrefMax():Vector.<int> {
    if (sizes == null && _compWraps.length > 0) {
      sizes = new Vector.<int>(3, true);
      for (var sType:int = LayoutUtil.MIN; sType <= LayoutUtil.PREF; sType++) {
        if (linkType == TYPE_PARALLEL) {
          sizes[sType] = Grid.getTotalSizeParallel(_compWraps, sType, isHor);
        } else if (linkType == TYPE_BASELINE) {
          var aboveBelow:Vector.<int> = Grid.getBaselineAboveBelow(_compWraps, sType, false);
          sizes[sType] = aboveBelow[0] + aboveBelow[1];
        }
        else {
          sizes[sType] = Grid.getTotalSizeSerial(_compWraps, sType, isHor);
        }
      }
      sizes[LayoutUtil.MAX] = LayoutUtil.INF;
    }
    return sizes;
  }
}
}
