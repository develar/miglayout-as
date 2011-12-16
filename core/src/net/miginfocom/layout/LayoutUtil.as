package net.miginfocom.layout {
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

/**
 * A utility class that has only static helper methods.
 */
public final class LayoutUtil {
  /**
   * A substitute value for a really large value. Integer.MAX_VALUE is not used since that means a lot of defensive code
   * for potential overflow must exist in many places. This value is large enough for being unreasonable yet it is hard to
   * overflow.
   */
  public static const INF:int = 2097051; //  (int.MAX_VALUE >> 10) - 100; // To reduce likelihood of overflow errors when calculating.

  /**
   * Tag int for a value that in considered "not set". Used as "null" element in int arrays.
   */
  public static const NOT_SET:int = int.MIN_VALUE + 12346; // Magic value...

  // Index for the different sizes
  public static const MIN:int = 0;
  public static const PREF:int = 1;
  public static const MAX:int = 2;

  private static var CR_MAP:Dictionary/*<Object, String>*/ = null;
//	private static WeakHashMap<Object, Boolean> DT_MAP = null;      // The Containers that have design time. Value not used.
  private static var eSz:int = 0;
  private static var _globalDebugMillis:int = 0;

  /**
   * Returns the current version of MiG Layout.
   * @return The current version of MiG Layout. E.g. "3.6.3" or "4.0"
   */
  public static function get version():String {
    return "4.3";
  }

  /**
   * If global debug should be on or off. If &gt; 0 then debug is turned on for all MigLayout instances.
   * @return The current debug milliseconds.
   * @see LC#debugMillis(int)
   */
  public static function get globalDebugMillis():int {
    return _globalDebugMillis;
  }

  /** If global debug should be on or off. If &gt; 0 then debug is turned on for all MigLayout
   * instances.
   * <p>
   * Note! This is a passive value and will be read by panels when the needed, which is normally
   * when they repaint/layout.
   * @param value The new debug milliseconds. 0 turns of global debug and leaves debug up to every
   * individual panel.
   * @see LC#debugMillis(int)
   */
  public static function set globalDebugMillis(value:int):void {
    _globalDebugMillis = value;
  }

  ///** Sets if design time is turned on for a Container in {@link ContainerWrapper}.
  // * @param cw The container to set design time for. <code>null</code> is legal and can be used as
  // * a key to turn on/off design time "in general". Note though that design time "in general" is
  // * always on as long as there is at least one ContainerWrapper with design time.
  // * <p>
  // * <strong>If this method has not ever been called it will default to what
  // * <code>Beans.isDesignTime()</code> returns.</strong> This means that if you call
  // * this method you indicate that you will take responsibility for the design time value.
  // * @param b <code>true</code> means design time on.
  // */
//	public static void setDesignTime(ContainerWrapper cw, boolean b)
//	{
//		if (DT_MAP == null)
//			DT_MAP = new WeakHashMap<Object, Boolean>();
//
//		DT_MAP.put((cw != null ? cw.getComponent() : null), new Boolean(b));
//	}

  //noinspection JSUnusedLocalSymbols
  /**
   * Returns if design time is turned on for a Container in {@link ContainerWrapper}.
   * @param cw The container to set design time for. <code>null</code> is legal will return <code>true</code>
   * if there is at least one <code>ContainerWrapper</code> (or <code>null</code>) that have design time
   * turned on.
   * @return If design time is set for <code>cw</code>.
   */
  public static function isDesignTime(cw:ContainerWrapper):Boolean {
    return false;
//		if (DT_MAP == null)
//			return Beans.isDesignTime();
//
//		if (cw != null && DT_MAP.containsKey(cw.getComponent()) == false)
//			cw = null;
//
//		Boolean b = DT_MAP.get(cw != null ? cw.getComponent() : null);
//		return b != null && b.booleanValue();
  }

  /**
   * The size of an empty row or columns in a grid during design time.
   * @return The number of pixels. Default is 15.
   */
  public static function get designTimeEmptySize():int {
    return eSz;
  }

  /**
   * The size of an empty row or columns in a grid during design time.
   * @param value The number of pixels. Default is 0 (it was 15 prior to v3.7.2, but since that meant different behaviour
   * under design time by default it was changed to be 0, same as non-design time). IDE vendors can still set it to 15 to
   * get the old behaviour.
   */
  public static function set designTimeEmptySize(value:int):void {
    eSz = value;
  }

  /**
   * Associates <code>con</code> with the creation string <code>s</code>. The <code>con</code> object should
   * probably have an equals method that compares identities or <code>con</code> objects that .equals() will only
   * be able to have <b>one</b> creation string.
   * <p>
   * If {@link LayoutUtil#isDesignTime(ContainerWrapper)} returns <code>false</code> the method does nothing.
   * @param con The object. if <code>null</code> the method does nothing.
   * @param s The creation string. if <code>null</code> the method does nothing.
   */
  internal static function putCCString(con:Object, s:String):void {
    if (s != null && con != null && isDesignTime(null)) {
      if (CR_MAP == null) {
        CR_MAP = new Dictionary(true);
      }

      CR_MAP[con] = s;
    }
  }

  ///**
  // * Sets/add the persistence delegates to be used for a class.
  // * @param c The class to set the registered deligate for.
  // * @param del The new delegate or <code>null</code> to erase to old one.
  // */
//	static function setDelegate(c:Class, PersistenceDelegate del):void
//	{
//		try {
//			Introspector.getBeanInfo(c, Introspector.IGNORE_ALL_BEANINFO).getBeanDescriptor().setValue("persistenceDelegate", del);
//		} catch (Exception e1) {
//		}
//	}

  /**
   * Returns strings set with {@link # putCCString(Object, String)} or <code>null</code> if nothing is associated or
   * {@link LayoutUtil# isDesignTime(ContainerWrapper)} returns <code>false</code>.
   * @param con The constrain object.
   * @return The creation string or <code>null</code> if nothing is registered with the <code>con</code> object.
   */
  internal static function getCCString(con:Object):String {
    return CR_MAP != null ? CR_MAP[con] : null;
  }

  internal static function throwCC():void {
    throw new IllegalOperationError("setStoreConstraintData(true) must be set for strings to be saved.");
  }

  /**
   * Takes a number on min/preferred/max sizes and resize constraints and returns the calculated sizes which sum should add up to <code>bounds</code>. Whether the sum
   * will actually equal <code>bounds</code> is dependent om the pref/max sizes and resize constraints.
   * @param sizes [ix],[MIN][PREF][MAX]. Grid.CompWrap.NOT_SET will be treated as N/A or 0. A "[MIN][PREF][MAX]" array with null elements will be interpreted as very flexible (no bounds)
   * but if the array itself is null it will not get any size.
   * @param resConstr Elements can be <code>null</code> and the whole array can be <code>null</code>. <code>null</code> means that the size will not be flexible at all.
   * Can have length less than <code>sizes</code> in which case the last element should be used for the elements missing.
   * @param defPushWeights If there is no grow weight for a resConstr the corresponding value of this array is used.
   * These forced resConstr will be grown last though and only if needed to fill to the bounds.
   * @param startSizeType The initial size to use. E.g. {@link net.miginfocom.layout.LayoutUtil#MIN}.
   * @param bounds To use for relative sizes.
   * @return The sizes. Array length will match <code>sizes</code>.
   */
  internal static function calculateSerial(sizes:Vector.<Vector.<int>>, resConstr:Vector.<ResizeConstraint>, defPushWeights:Vector.<Number>,
                                           startSizeType:int, bounds:int):Vector.<int> {
    var lengths:Vector.<Number> = new Vector.<Number>(sizes.length, true);	// heights/widths that are set
    var usedLength:Number = 0;

    var i:int;
    const sizesLength:int = sizes.length;
    var r:Number;
    var newSizeBounded:int;
    // Give all preferred size to start with
    for (i = 0; i < sizesLength; i++) {
      if (sizes[i] != null) {
        var len:Number = sizes[i][startSizeType] != NOT_SET ? sizes[i][startSizeType] : 0;
        newSizeBounded = getBrokenBoundary(len, sizes[i][MIN], sizes[i][MAX]);
        if (newSizeBounded != NOT_SET) {
          len = newSizeBounded;
        }

        usedLength += len;
        lengths[i] = len;
      }
    }

    var resC:ResizeConstraint;
    const useLengthI:int = usedLength;
    if (useLengthI != bounds && resConstr != null) {
      const isGrow:Boolean = useLengthI < bounds;

      // Create a Set with the available priorities
      var prioIntegers:Vector.<int> = new Vector.<int>(sizes.length, true);
      var prioListIndex:int = 0;
      for (i = 0; i < sizesLength; i++) {
        if ((resC = getIndexSafe2(resConstr, i)) != null) {
          prioIntegers[prioListIndex++] = isGrow ? resC.growPrio : resC.shrinkPrio;
        }
      }
      prioIntegers.fixed = false;
      prioIntegers.length = prioListIndex;
      prioIntegers.fixed = true;
      prioIntegers.sort(intCompareFunction);

      // Run twice if defGrow and the need for growing.
      for (var force:int = 0; force <= ((isGrow && defPushWeights != null) ? 1 : 0); force++) {
        for (var pr:int = prioIntegers.length - 1; pr >= 0; pr--) {
          var curPrio:int = prioIntegers[pr];

          var totWeight:Number = 0;
          var resizeWeight:Vector.<Number> = new Vector.<Number>(sizes.length, true);
          for (i = 0; i < sizesLength; i++) {
            if (sizes[i] == null) { // if no min/pref/max size at all do not grow or shrink.
              continue;
            }

            if ((resC = getIndexSafe2(resConstr, i)) != null) {
              if (curPrio == (isGrow ? resC.growPrio : resC.shrinkPrio)) {
                if (isGrow) {
                  r = resizeWeight[i] = (force == 0 || resC.grow == resC.grow) ? resC.grow : (defPushWeights[i < defPushWeights.length ? i : defPushWeights.length - 1]);
                }
                else {
                  r = resizeWeight[i] = resC.shrink;
                }
                if (r == r) {
                  totWeight += r;
                }
              }
            }
          }

          if (totWeight > 0) {
            var hit:Boolean;
            do {
              var toChange:Number = bounds - usedLength;
              hit = false;
              var changedWeight:Number = 0;
              for (i = 0; i < sizesLength && totWeight > 0.0001; i++) {
                var weight:Number = resizeWeight[i];
                if (weight == weight) {
                  var sizeDelta:Number = toChange * weight / totWeight;
                  var newSize:Number = lengths[i] + sizeDelta;
                  if (sizes[i] != null) {
                    newSizeBounded = getBrokenBoundary(newSize, sizes[i][MIN], sizes[i][MAX]);
                    if (newSizeBounded != NOT_SET) {
                      resizeWeight[i] = NaN;
                      hit = true;
                      changedWeight += weight;
                      newSize = newSizeBounded;
                      sizeDelta = newSize - lengths[i];
                    }
                  }

                  lengths[i] = newSize;
                  usedLength += sizeDelta;
                }
              }
              totWeight -= changedWeight;
            }
            while (hit);
          }
        }
      }
    }
    return roundSizes(lengths);
  }

  private static function intCompareFunction(a:int, b:int):int {
    return a - b;
  }

  internal static function getIndexSafe(arr:Vector.<CellConstraint>, ix:int):CellConstraint {
    return arr[ix < arr.length ? ix : arr.length - 1];
  }

  internal static function getIndexSafe2(arr:Vector.<ResizeConstraint>, ix:int):ResizeConstraint {
    return arr != null ? arr[ix < arr.length ? ix : arr.length - 1] : null;
  }

  /**
   * Returns the broken boundary if <code>sz</code> is outside the boundaries <code>lower</code> or <code>upper</code>. If both boundaries
   * are broken, the lower one is returned. If <code>sz</code> is &lt; 0 then <code>new Float(0f)</code> is returned so that no sizes can be
   * negative.
   * @param sz The size to check
   * @param lower The lower boundary (or <code>null</code> fo no boundary).
   * @param upper The upper boundary (or <code>null</code> fo no boundary).
   * @return The broken boundary or <code>null</code> if no boundary was broken.
   */
  private static function getBrokenBoundary(sz:Number, lower:int, upper:int):int {
    if (lower != NOT_SET) {
      if (sz < lower) {
        return lower;
      }
    }
    else if (sz < 0) {
      return 0;
    }

    if (upper != NOT_SET && sz > upper) {
      return upper;
    }

    return NOT_SET;
  }

  internal static function sum(terms:Vector.<int>, start:int, len:int):int {
    var s:int = 0;
    for (var i:int = start, iSz:int = start + len; i < iSz; i++) {
      s += terms[i];
    }
    return s;
  }

  public static function getSizeSafe(sizes:Vector.<int>, sizeType:int):int {
    if (sizes == null || sizes[sizeType] == NOT_SET) {
      return sizeType == MAX ? INF : 0;
    }
    return sizes[sizeType];
  }

  internal static function derive(bs:BoundSize, min:UnitValue, pref:UnitValue, max:UnitValue):BoundSize {
    if (bs == null || bs.isUnset) {
      return BoundSize.create(min, pref, max, null);
    }

    return BoundSize.create3(
      min != null ? min : bs.min,
      pref != null ? pref : bs.preferred,
      max != null ? max : bs.max,
      bs.gapPush,
      null);
  }

  /**
   * Returns if left-to-right orientation is used. If not set explicitly in the layout constraints the Locale
   * of the <code>parent</code> is used.
   * @param lc The constraint if there is one. Can be <code>null</code>.
   * @param container The parent that may be used to get the left-to-right if ffc does not specify this.
   * @return If left-to-right orientation is currently used.
   */
  public static function isLeftToRight(lc:LC, container:ContainerWrapper):Boolean {
    if (lc != null && lc.leftToRight != 0) {
      return lc.leftToRight == 1;
    }

    return container == null || container.leftToRight;
  }

  /**
   * Round a number of float sizes into int sizes so that the total length match up
   * @param sizes The sizes to round
   * @return An array of equal length as <code>sizes</code>.
   */
  internal static function roundSizes(sizes:Vector.<Number>):Vector.<int> {
    const sizeLength:int = sizes.length;
    var retInts:Vector.<int> = new Vector.<int>(sizeLength, true);
    var posD:Number = 0;
    for (var i:int = 0; i < sizeLength; i++) {
      const posI:int = int(posD + 0.5);
      posD += sizes[i];
      retInts[i] = int(posD + 0.5) - posI;
    }

    return retInts;
  }

  /** Safe equals. null == null, but null never equals anything else.
   * @param o1 The first object. May be <code>null</code>.
   * @param o2 The second object. May be <code>null</code>.
   * @return Returns <code>true</code> if <code>o1</code> and <code>o2</code> are equal (using .equals()) or both are <code>null</code>.
   */
  internal static function equals(o1:Number, o2:Number):Boolean {
    return (o1 != o1 && o2 != o2) || o1 == o2;
  }

//	static int getBaselineCorrect(Component comp)
//	{
//		Dimension pSize = comp.getPreferredSize();
//		int baseline = comp.getBaseline(pSize.width, pSize.height);
//		int nextBaseline = comp.getBaseline(pSize.width, pSize.height + 1);
//
//		// Amount to add to height when calculating where baseline
//		// lands for a particular height:
//		int padding = 0;
//
//		// Where the baseline is relative to the mid point
//		int baselineOffset = baseline - pSize.height / 2;
//		if (pSize.height % 2 == 0 && baseline != nextBaseline) {
//			padding = 1;
//		} else if (pSize.height % 2 == 1 && baseline == nextBaseline) {
//			baselineOffset--;
//			padding = 1;
//		}
//
//		// The following calculates where the baseline lands for
//		// the height z:
//		return (pSize.height + padding) / 2 + baselineOffset;
//	}


  /** Returns the inset for the side.
   * @param side top == 0, left == 1, bottom = 2, right = 3.
   * @param useDefault If <code>true</code> the default insets will get retrieved if <code>lc</code> has none set.
   * @return The inset for the side. Never <code>null</code>.
   */
  internal static function getInsets(lc:LC, side:int, useDefault:Boolean):UnitValue {
    var i:UnitValue;
    return lc.insets != null && (i = lc.insets[side]) != null ? i : useDefault ? PlatformDefaults.getPanelInsets(side) : UnitValue.ZERO;
  }

  public static function calculateHash(cw:ComponentWrapper):int {
    var hash:int = cw.getMaximumWidth() + (cw.getMaximumHeight() << 5);
    hash += (cw.getPreferredWidth() << 10) + (cw.getPreferredHeight() << 15);
    hash += (cw.getMinimumWidth() << 20) + (cw.getMinimumHeight() << 25);

    if (cw.visible) {
      hash += 1324511;
    }
    if (cw.linkId != null) {
      hash += Strings.hashCode(cw.linkId);
    }

    return hash;
  }
}
}