package cocoa.layout {
import avmplus.getQualifiedClassName;

public final class UnitValue {
  private static const UNIT_MAP:Object/*<String, int>*/ = {
    "px": PIXEL,
//		"lpx": LPX,
//		"lpy": LPY,
    "%": PERCENT,
//		"cm": CM,
//		"in": INCH,
    "spx": SPX,
    "spy": SPY,
    "al": ALIGN,
//		"mm": MM,
//		"pt": PT,
    "min": MIN_SIZE,
    "minimum": MIN_SIZE,
    "p": PREF_SIZE,
    "pref": PREF_SIZE,
    "max": MAX_SIZE,
    "maximum": MAX_SIZE,
    "button": BUTTON,
    "label": LABEL_ALIGN
  };

  private static const CONVERTERS:Vector.<UnitConverter> = new Vector.<UnitConverter>();

  /**
   * An operation indicating a static value.
   */
  public static const STATIC:int = 100;

  /** An operation indicating a addition of two sub units.
   */
  public static const ADD:int = 101; // Must have "sub-unit values"

  /** An operation indicating a subtraction of two sub units
   */
  public static const SUB:int = 102; // Must have "sub-unit values"

  /** An operation indicating a multiplication of two sub units.
   */
  public static const MUL:int = 103; // Must have "sub-unit values"

  /** An operation indicating a division of two sub units.
   */
  public static const DIV:int = 104; // Must have "sub-unit values"

  /** An operation indicating the minimum of two sub units
   */
  public static const MIN:int = 105; // Must have "sub-unit values"

  /** An operation indicating the maximum of two sub units
   */
  public static const MAX:int = 106; // Must have "sub-unit values"

  /** An operation indicating the middle value of two sub units
   */
  public static const MID:int = 107; // Must have "sub-unit values"


  /** A unit indicating pixels.
   */
  public static const PIXEL:int = 0;

  /** A unit indicating logical horizontal pixels.
   */
//	public static const LPX:int = 1;

  /** A unit indicating logical vertical pixels.
   */
//	public static const LPY:int = 2;

  /** A unit indicating millimeters.
   */
//	public static const MM:int = 3;

  /** A unit indicating centimeters.
   */
//	public static const CM:int = 4;

  /** A unit indicating inches.
   */
//	public static const INCH:int = 5;

  /** A unit indicating percent.
   */
  public static const PERCENT:int = 6;

  /** A unit indicating points.
   */
//	public static const PT:int = 7;

  /** A unit indicating screen percentage width.
   */
  public static const SPX:int = 8;

  /** A unit indicating screen percentage height.
   */
  public static const SPY:int = 9;

  /** A unit indicating alignment.
   */
  public static const ALIGN:int = 12;

  /** A unit indicating minimum size.
   */
  public static const MIN_SIZE:int = 13;

  /** A unit indicating preferred size.
   */
  public static const PREF_SIZE:int = 14;

  /** A unit indicating maximum size.
   */
  public static const MAX_SIZE:int = 15;

  /** A unit indicating botton size.
   */
  public static const BUTTON:int = 16;

  /** A unit indicating linking to x.
   */
  public static const LINK_X:int = 18;   // First link

  /** A unit indicating linking to y.
   */
  public static const LINK_Y:int = 19;

  /** A unit indicating linking to width.
   */
  public static const LINK_W:int = 20;

  /** A unit indicating linking to height.
   */
  public static const LINK_H:int = 21;

  /** A unit indicating linking to x2.
   */
  public static const LINK_X2:int = 22;

  /** A unit indicating linking to y2.
   */
  public static const LINK_Y2:int = 23;

  /** A unit indicating linking to x position on screen.
   */
  public static const LINK_XPOS:int = 24;

  /** A unit indicating linking to y position on screen.
   */
  public static const LINK_YPOS:int = 25;    // Last link

  /** A unit indicating a lookup.
   */
  public static const LOOKUP:int = 26;

  /** A unit indicating label alignment.
   */
  public static const LABEL_ALIGN:int = 27;

  private static const IDENTITY:int = -1;

  static const ZERO:UnitValue = create2(0, PIXEL, true, "0px");
  static const TOP:UnitValue = create2(0, PERCENT, false, "top");
  static const LEADING:UnitValue = create2(0, PERCENT, true, "leading");
  static const LEFT:UnitValue = create2(0, PERCENT, true, "left");
  static const CENTER:UnitValue = create2(50, PERCENT, true, "center");
  static const TRAILING:UnitValue = create2(100, PERCENT, true, "trailing");
  static const RIGHT:UnitValue = create2(100, PERCENT, true, "right");
  static const BOTTOM:UnitValue = create2(100, PERCENT, false, "bottom");
  static const LABEL:UnitValue = create2(0, LABEL_ALIGN, false, "label");

  static const INF:UnitValue = create2(LayoutUtil.INF, PIXEL, true, "inf");

  static const BASELINE_IDENTITY:UnitValue = create2(0, IDENTITY, false, "baseline");

  private var value:Number;
  private var unit:int;
  private var oper:int = STATIC;
  private var unitStr:String;
  private var linkId:String;
  private var isHor:Boolean = true;
  private var subUnits:Vector.<UnitValue>;

  // Pixel
//	public function UnitValue(value:Number) // If hor/ver does not matter.
//	{
//		this (value, null, PIXEL, true, STATIC, null, null, value + "px");
//	}

//	public UnitValue(float value, int unit, String createString)  // If hor/ver does not matter.
//	{
//		this(value, null, unit, true, STATIC, null, null, createString);
//	}
//
//	UnitValue(float value, String unitStr, boolean isHor, int oper, String createString)
//	{
//		this(value, unitStr, -1, isHor, oper, null, null, createString);
//	}
//
//	UnitValue(boolean isHor, int oper, UnitValue sub1, UnitValue sub2, String createString)
//	{
//		this(0, "", -1, isHor, oper, sub1, sub2, createString);
//		if (sub1 == null || sub2 == null)
//			throw new IllegalArgumentException("Sub units is null!");
//	}

  internal static function create(value:Number, unit:int):UnitValue { // If hor/ver does not matter.
    var unitValue:UnitValue = new UnitValue();
    unitValue.value = value;
    unitValue.unit = unit;
//    LayoutUtil.putCCString(unitValue, value + "px");
    return unitValue;
  }

  //noinspection JSUnusedLocalSymbols
  private static function create2(value:Number, unit:int, isHor:Boolean, createString:String):UnitValue { // If hor/ver does not matter.
    var unitValue:UnitValue = new UnitValue();
    unitValue.value = value;
    unitValue.unit = unit;
    unitValue.isHor = isHor;
//    LayoutUtil.putCCString(unitValue, value + "px");
    return unitValue;
  }

//	function UnitValue(value:Number, unitStr:String = null, unit:int = PIXEL, isHor:Boolean = true, oper:int = STATIC, sub1:UnitValue = null, sub2:UnitValue = null, createString:String = null)
//	{
//		if (oper < STATIC || oper > MID) {
//      throw new ArgumentError("Unknown Operation: " + oper);
//    }
//
//		if (oper >= ADD && oper <= MID && (sub1 == null || sub2 == null)) {
//      throw new ArgumentError(oper + " Operation may not have null sub-UnitValues.");
//    }
//
//		this.value = value;
//		this.oper = oper;
//		this.isHor = isHor;
//		this.unitStr = unitStr;
//		this.unit = unitStr != null ? parseUnitString() : unit;
//		this.subUnits = sub1 != null && sub2 != null ? new UnitValue[] {sub1, sub2} : null;
//
//		LayoutUtil.putCCString(this, createString == null ? (value + "px") : createString); // "this" escapes!! Safe though.
//	}

  /**
   * Returns the size in pixels rounded.
   * @param refValue The reference value. Normally the size of the parent. For unit {@link # ALIGN} the current size of the component should be sent in.
   * @param parent The parent. May be <code>null</code> for testing the validity of the value, but should normally not and are not
   * required to return any usable value if <code>null</code>.
   * @param comp The component, if any, that the value is for. Might be <code>null</code> if the value is not
   * connected to any component.
   * @return The size in pixels.
   */
  public final function getPixels(refValue:Number, parent:ContainerWrapper, comp:ComponentWrapper):int {
    return Math.round(getPixelsExact(refValue, parent, comp));
  }

  private static const SCALE:Vector.<Number> = new <Number>[25.4, 2.54, 1, 0, 72];

  /**
   * Returns the size in pixels.
   * @param refValue The reference value. Normally the size of the parent. For unit {@link # ALIGN} the current size of the component should be sent in.
   * @param parent The parent. May be <code>null</code> for testing the validity of the value, but should normally not and are not
   * required to return any usable value if <code>null</code>.
   * @param comp The component, if any, that the value is for. Might be <code>null</code> if the value is not
   * connected to any component.
   * @return The size in pixels.
   */
  public final function getPixelsExact(refValue:Number, parent:ContainerWrapper, comp:ComponentWrapper):Number {
    if (parent == null) {
      return 1;
    }

    if (oper == STATIC) {
      switch (unit) {
        case PIXEL:
          return value;

//				case LPX:
//				case LPY:
//					return parent.getPixelUnitFactor(unit == LPX) * value;

//				case MM:
//				case CM:
//				case INCH:
//				case PT:
//					float f = SCALE[unit - MM];
//					Float s = isHor ? PlatformDefaults.getHorizontalScaleFactor() : PlatformDefaults.getVerticalScaleFactor();
//					if (s != null)
//						f *= s.floatValue();
//					return (isHor ? parent.getHorizontalScreenDPI() : parent.getVerticalScreenDPI()) * value / f;

        case PERCENT:
          return value * refValue * 0.01;

        case SPX:
          return parent.getScreenWidth() * value * 0.01;
        case SPY:
          return parent.getScreenHeight() * value * 0.01;

        // todo suport align
//				case ALIGN:
//					var st:int = LinkHandler.getValue(parent.getLayout(), "visual", isHor ? LinkHandler.X : LinkHandler.Y);
//					var sz:int = LinkHandler.getValue(parent.getLayout(), "visual", isHor ? LinkHandler.WIDTH : LinkHandler.HEIGHT);
//					if (st == null || sz == null)
//						return 0;
//					return value * (Math.max(0, sz.intValue()) - refValue) + st.intValue();

        case MIN_SIZE:
          if (comp == null)
            return 0;
          return isHor ? comp.getMinimumWidth(comp.getHeight()) : comp.getMinimumHeight(comp.getWidth());

        case PREF_SIZE:
          if (comp == null)
            return 0;
          return isHor ? comp.getPreferredWidth(comp.getHeight()) : comp.getPreferredHeight(comp.getWidth());

        case MAX_SIZE:
          if (comp == null)
            return 0;
          return isHor ? comp.getMaximumWidth(comp.getHeight()) : comp.getMaximumHeight(comp.getWidth());

        case BUTTON:
          return PlatformDefaults.getMinimumButtonWidth().getPixels(refValue, parent, comp);

//				case LINK_X:
//				case LINK_Y:
//				case LINK_W:
//				case LINK_H:
//				case LINK_X2:
//				case LINK_Y2:
//				case LINK_XPOS:
//				case LINK_YPOS:
//					Integer v = LinkHandler.getValue(parent.getLayout(), getLinkTargetId(), unit - (unit >= LINK_XPOS ? LINK_XPOS : LINK_X));
//					if (v == null)
//						return 0;
//
//					if (unit == LINK_XPOS)
//						return parent.getScreenLocationX() + v.intValue();
//					if (unit == LINK_YPOS)
//						return parent.getScreenLocationY() + v.intValue();
//
//					return v.intValue();

        case LOOKUP:
          return lookup(refValue, parent, comp);

        case LABEL_ALIGN:
          return PlatformDefaults.labelAlignPercentage * refValue;

        case IDENTITY:
      }
      throw new ArgumentError("Unknown/illegal unit: " + unit + ", unitStr: " + unitStr);
    }

    if (subUnits != null && subUnits.length == 2) {
      var r1:Number = subUnits[0].getPixelsExact(refValue, parent, comp);
      var r2:Number = subUnits[1].getPixelsExact(refValue, parent, comp);
      switch (oper) {
        case ADD:
          return r1 + r2;
        case SUB:
          return r1 - r2;
        case MUL:
          return r1 * r2;
        case DIV:
          return r1 / r2;
        case MIN:
          return r1 < r2 ? r1 : r2;
        case MAX:
          return r1 > r2 ? r1 : r2;
        case MID:
          return (r1 + r2) * 0.5;
      }
    }

    throw new ArgumentError("Internal: Unknown Oper: " + oper);
  }

  private function lookup(refValue:Number, parent:ContainerWrapper, comp:ComponentWrapper):Number {
    var res:Number = UnitConverter.UNABLE;
    for (var i:int = CONVERTERS.length - 1; i >= 0; i--) {
      res = CONVERTERS[i].convertToPixels(value, unitStr, isHor, refValue, parent, comp);
      if (res != UnitConverter.UNABLE)
        return res;
    }
    return PlatformDefaults.convertToPixels(value, unitStr, isHor, refValue, parent, comp);
  }

  private function parseUnitString():int {
    const len:int = unitStr.length;
    if (len == 0) {
      return isHor ? PlatformDefaults.defaultHorizontalUnit : PlatformDefaults.defaultVerticalUnit;
    }

    var uu:Object = UNIT_MAP[unitStr];
    if (uu != null) {
      return int(uu);
    }

//		if (unitStr.equals("lp"))
//			return isHor ? LPX : LPY;

    if (unitStr == "sp") {
      return isHor ? SPX : SPY;
    }

    // To test so we can fail fast
    if (lookup(0, null, null) != UnitConverter.UNABLE) {
      return LOOKUP;
    }

    // Only link left. E.g. "otherID.width"
    const pIx:int = unitStr.indexOf('.');
    if (pIx != -1) {
      linkId = unitStr.substring(0, pIx);
      switch (unitStr.substring(pIx + 1)) {
        case "x": return LINK_X;
        case "y": return LINK_Y;

        case "w":
        case "width":
          return LINK_W;

        case "h":
        case "height":
          return LINK_H;

        case "x2": return LINK_X2;
        case "y2": return LINK_Y2;
        case "xpos": return LINK_XPOS;
        case "ypos": return LINK_YPOS;
      }
    }

    throw new ArgumentError("Unknown keyword: " + unitStr);
  }

  final function isLinked():Boolean {
    return linkId != null;
  }

  final function isLinkedDeep():Boolean {
    if (subUnits == null) {
      return linkId != null;
    }

    for (var i:int = 0; i < subUnits.length; i++) {
      if (subUnits[i].isLinkedDeep()) {
        return true;
      }
    }

    return false;
  }

  final function getLinkTargetId():String {
    return linkId;
  }

  final function getSubUnitValue(i:int):UnitValue {
    return subUnits[i];
  }

  final function getSubUnitCount():int {
    return subUnits != null ? subUnits.length : 0;
  }

  public final function getSubUnits():Vector.<UnitValue> {
    return subUnits;
  }

  public final function getUnit():int {
    return unit;
  }

  public final function getUnitString():String {
    return unitStr;
  }

  public final function getOperation():int {
    return oper;
  }

  public final function getValue():Number {
    return value;
  }

  public final function isHorizontal():Boolean {
    return isHor;
  }

  public final function toString():String {
    return getQualifiedClassName(this) + ". Value=" + value + ", unit=" + unit + ", unitString: " + unitStr + ", oper=" + oper + ", isHor: " + isHor;
  }

  /**
   * Returns the creation string for this object. Note that {@link LayoutUtil# setDesignTime(ContainerWrapper, boolean)} must be
   * set to <code>true</code> for the creation strings to be stored.
   * @return The constraint string or <code>null</code> if none is registered.
   */
  public function getConstraintString():String {
    return LayoutUtil.getCCString(this);
  }
}
}