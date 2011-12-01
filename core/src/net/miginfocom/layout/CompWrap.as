package net.miginfocom.layout {
/** Wraps a {@link net.miginfocom.layout.ComponentWrapper} together with its constraint. Caches a lot of information about the component so
 * for instance not the preferred size has to be calculated more than once.
 */
internal final class CompWrap {
  internal var comp:ComponentWrapper;
	internal var cc:CC;
	internal var pos:Vector.<UnitValue>;
	private var gaps:Vector.<Vector.<int>>; // [top,left(actually before),bottom,right(actually after)][min,pref,max]

	internal const horSizes:Vector.<int> = new Vector.<int>(3, true);
	internal const verSizes:Vector.<int> = new Vector.<int>(3, true);

  internal var x:int = LayoutUtil.NOT_SET, y:int = LayoutUtil.NOT_SET, w:int = LayoutUtil.NOT_SET, h:int = LayoutUtil.NOT_SET;

	internal var forcedPushGaps:int = 0;   // 1 == before, 2 = after. Bitwise.

  function CompWrap(c:ComponentWrapper, cc:CC, eHideMode:int, pos:Vector.<UnitValue>, callbackSz:Vector.<BoundSize>) {
    this.comp = c;
    this.cc = cc;
    this.pos = pos;

    var i:int;
		if (eHideMode <= 0) {
			var hBS:BoundSize = (callbackSz != null && callbackSz[0] != null) ? callbackSz[0] : cc.horizontal.size;
			var vBS:BoundSize = (callbackSz != null && callbackSz[1] != null) ? callbackSz[1] : cc.vertical.size;

			var wHint:int= -1, hHint:int = -1; // Added for v3.7
			if (comp.width > 0&& comp.height > 0) {
				hHint = comp.width;
				wHint = comp.height;
			}

      for (i = LayoutUtil.MIN; i <= LayoutUtil.MAX; i++) {
        horSizes[i] = getSize2(hBS, i, true, hHint);
        verSizes[i] = getSize2(vBS, i, false, wHint > 0 ? wHint : horSizes[i]);
      }

			Grid.correctMinMax(horSizes);
      Grid.correctMinMax(verSizes);
		}

		if (eHideMode > 1) {
      gaps = new Vector.<Vector.<int>>(4);
      for (i = 0; i < gaps.length; i++) {
        gaps[i] = new Vector.<int>(3);
      }
    }
	}

  private function getSize2(uvs:BoundSize, sizeType:int, isHor:Boolean, sizeHint:int):int {
    if (uvs == null || uvs.getSize(sizeType) == null) {
      switch (sizeType) {
        case LayoutUtil.MIN:
          return isHor ? comp.getMinimumWidth(sizeHint) : comp.getMinimumHeight(sizeHint);
        case LayoutUtil.PREF:
          return isHor ? comp.getPreferredWidth(sizeHint) : comp.getPreferredHeight(sizeHint);
        default:
          return isHor ? comp.getMaximumWidth(sizeHint) : comp.getMaximumHeight(sizeHint);
      }
    }

    var par:ContainerWrapper = comp.parent;
    return uvs.getSize(sizeType).getPixels(isHor ? par.width : par.height, par, comp);
  }

	internal function calcGaps(before:ComponentWrapper, befCC:CC, after:ComponentWrapper, aftCC:CC, tag:String, flowX:Boolean, isLTR:Boolean):void {
    var par:ContainerWrapper = comp.parent;
    var parW:int = par.width;
    var parH:int = par.height;

		var befGap:BoundSize = before != null ? (flowX ? befCC.horizontal : befCC.vertical).gapAfter : null;
    var aftGap:BoundSize = after != null ? (flowX ? aftCC.horizontal : aftCC.vertical).gapBefore : null;

    mergeGapSizes(cc.vertical.getComponentGaps(par, comp, befGap, (flowX ? null : before), tag, parH, 0, isLTR), false, true);
		mergeGapSizes(cc.horizontal.getComponentGaps(par, comp, befGap, (flowX ? before : null), tag, parW, 1, isLTR), true, true);
		mergeGapSizes(cc.vertical.getComponentGaps(par, comp, aftGap, (flowX ? null : after), tag, parH, 2, isLTR), false, false);
		mergeGapSizes(cc.horizontal.getComponentGaps(par, comp, aftGap, (flowX ? after : null), tag, parW, 3, isLTR), true, false);
	}

  internal function setDimBounds(start:int, size:int, isHor:Boolean):void {
    if (isHor) {
      x = start;
      w = size;
      if (w < 0) {
            var g:int;
            g++;
          }
    }
    else {
      y = start;
      h = size;
    }
  }

  internal function isPushGap(isHor:Boolean, isBefore:Boolean):Boolean {
    if (isHor && ((isBefore ? 1 : 2) & forcedPushGaps) != 0) {
      return true;
    }    // Forced

    var dc:DimConstraint = cc.getDimConstraint(isHor);
    var s:BoundSize = isBefore ? dc.gapBefore : dc.gapAfter;
    return s != null && s.gapPush;
  }

	/**
	 * @return If the preferred size have changed because of the new bounds.
	 */
  internal function transferBounds(checkPrefChange:Boolean):Boolean {
    comp.setBounds(x, y, w, h);

    if (checkPrefChange && w != horSizes[LayoutUtil.PREF]) {
      if (cc.vertical.size.preferred == null) {
        if (comp.getPreferredHeight(-1) != verSizes[LayoutUtil.PREF]) {
          return true;
        }
      }
    }
    return false;
	}

	internal function setSizes(sizes:Vector.<int>, isHor:Boolean):void {
    if (sizes == null) {
      return;
    }

    var s:Vector.<int> = isHor ? horSizes : verSizes;
    s[LayoutUtil.MIN] = sizes[LayoutUtil.MIN];
    s[LayoutUtil.PREF] = sizes[LayoutUtil.PREF];
    s[LayoutUtil.MAX] = sizes[LayoutUtil.MAX];
  }

  internal function setGaps(minPrefMax:Vector.<int>, ix:int):void {
    if (gaps == null) {
      gaps = new Vector.<Vector.<int>>(4, true);
    }

    gaps[ix] = minPrefMax;
  }

	internal function mergeGapSizes(sizes:Vector.<int>, isHor:Boolean, isTL:Boolean):void {
    if (gaps == null) {
      gaps = new Vector.<Vector.<int>>(4, true);
    }

    if (sizes == null) {
      return;
    }

    var gapIX:int = getGapIx(isHor, isTL);
    var oldGaps:Vector.<int> = gaps[gapIX];
    if (oldGaps == null) {
      oldGaps = new <int>[0, 0, LayoutUtil.INF];
      gaps[gapIX] = oldGaps;
    }

		oldGaps[LayoutUtil.MIN] = Math.max(sizes[LayoutUtil.MIN], oldGaps[LayoutUtil.MIN]);
		oldGaps[LayoutUtil.PREF] = Math.max(sizes[LayoutUtil.PREF], oldGaps[LayoutUtil.PREF]);
		oldGaps[LayoutUtil.MAX] = Math.min(sizes[LayoutUtil.MAX], oldGaps[LayoutUtil.MAX]);
	}

	private static function getGapIx(isHor:Boolean, isTL:Boolean):int {
		return isHor ? (isTL ? 1: 3) : (isTL ? 0: 2);
	}

	internal function getSizeInclGaps(sizeType:int, isHor:Boolean):int {
		return filter(sizeType, getGapBefore(sizeType, isHor) + getSize(sizeType, isHor) + getGapAfter(sizeType, isHor));
	}

	internal function getSize(sizeType:int, isHor:Boolean):int {
		return filter(sizeType, isHor ? horSizes[sizeType] : verSizes[sizeType]);
	}

	internal function getGapBefore(sizeType:int, isHor:Boolean):int {
		var gaps:Vector.<int> = getGaps(isHor, true);
		return gaps != null ? filter(sizeType, gaps[sizeType]) : 0;
	}

	internal function getGapAfter(sizeType:int, isHor:Boolean):int {
		var gaps:Vector.<int> = getGaps(isHor, false);
		return gaps != null ? filter(sizeType, gaps[sizeType]) : 0;
	}

  internal function getGaps(isHor:Boolean, isTL:Boolean):Vector.<int> {
    return gaps[getGapIx(isHor, isTL)];
  }

  private static function filter(sizeType:int, size:int):int {
    if (size == LayoutUtil.NOT_SET) {
      return sizeType != LayoutUtil.MAX ? 0 : LayoutUtil.INF;
    }
    return Grid.constrainSize(size);
  }

  internal function isBaselineAlign(defValue:Boolean):Boolean {
    var g:Number = cc.vertical.grow;
    if (g == g && g != 0) {
      return false;
    }

    var al:UnitValue = cc.vertical.align;
    return (al != null ? al == UnitValue.BASELINE_IDENTITY : defValue) && comp.hasBaseline;
  }

  internal function getBaseline(sizeType:int):int {
		return comp.getBaseline(getSize(sizeType, true), getSize(sizeType, false));
	}
}
}
