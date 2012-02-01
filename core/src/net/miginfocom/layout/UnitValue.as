package net.miginfocom.layout {
import flash.utils.getQualifiedClassName;

public final class UnitValue {
  private static const UNIT_MAP:Object/*<String, int>*/ = {
    "px": PIXEL,
		"lpx": LPX,
		"lpy": LPY,
    "%": PERCENT,
		"cm": CM,
		"in": INCH,
    "spx": SPX,
    "spy": SPY,
    "al": ALIGN,
		"mm": MM,
		"pt": PT,
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
	public static const LPX:int = 1;

  /** A unit indicating logical vertical pixels.
   */
	public static const LPY:int = 2;

  /** A unit indicating millimeters.
   */
	public static const MM:int = 3;

  /** A unit indicating centimeters.
   */
	public static const CM:int = 4;

  /** A unit indicating inches.
   */
	public static const INCH:int = 5;

  /** A unit indicating percent.
   */
  public static const PERCENT:int = 6;

  /** A unit indicating points.
   */
	public static const PT:int = 7;

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

  public static const ZERO:UnitValue = new UnitValue(0, PIXEL, "0px");
  public static const TOP:UnitValue = new UnitValue(0, PERCENT, "top", false);
  public static const LEADING:UnitValue = new UnitValue(0, PERCENT, "leading");
  public static const LEFT:UnitValue = new UnitValue(0, PERCENT, "left");
  public static const CENTER:UnitValue = new UnitValue(50, PERCENT, "center");
  public static const TRAILING:UnitValue = new UnitValue(100, PERCENT, "trailing");
  public static const RIGHT:UnitValue = new UnitValue(100, PERCENT, "right");
  public static const BOTTOM:UnitValue = new UnitValue(100, PERCENT, "bottom", false);
  public static const LABEL:UnitValue = new UnitValue(0, LABEL_ALIGN, "label", false);

  internal static const INF:UnitValue = new UnitValue(LayoutUtil.INF, PIXEL, "inf");

  public static const BASELINE_IDENTITY:UnitValue = new UnitValue(0, IDENTITY, "baseline", false);

  private var value:Number;
  private var oper:int = STATIC;
  private var unitStr:String;
  private var linkId:String;
  private var isHor:Boolean;
  private var _subUnits:Vector.<UnitValue>;

  public function UnitValue(value:Number, unit:int = -1000, unitStr:String = null, isHor:Boolean = true) {
    this.value = value;
    this.isHor = isHor;
    this.unitStr = unitStr;

    if (unit != -1000) {
      _unit = unit;
    }
    else if (unitStr != null) {
      _unit = parseUnitString();
    }
    else if (unit == -1000) {
      _unit = PIXEL;
    }
    else {
      throw new ArgumentError("unit or unitStr must be specified");
    }
  }

  //noinspection JSUnusedLocalSymbols
  internal static function create3(isHorizontal:Boolean, operator:int, sub1:UnitValue, sub2:UnitValue, createString:String):UnitValue {
    if (sub1 == null || sub2 == null) {
      throw new ArgumentError("Sub units cannot be null");
    }

    if (operator < STATIC || operator > MID) {
      throw new ArgumentError("Unknown Operation: " + operator);
    }

    var unitValue:UnitValue = new UnitValue(0, isHorizontal ? PlatformDefaults.defaultHorizontalUnit : PlatformDefaults.defaultVerticalUnit, null, isHorizontal);
    unitValue.oper = operator;
    unitValue._subUnits = new <UnitValue>[sub1, sub2];

    // LayoutUtil.putCCString(unitValue, value + "px");
    return unitValue;
  }

  //noinspection JSUnusedLocalSymbols
  internal static function create4(value:Number, unitStr:String, isHor:Boolean, oper:int, createString:String):UnitValue {
    if (oper < STATIC || oper > MID) {
      throw new ArgumentError("Unknown Operation: " + oper);
    }

    if (oper >= ADD && oper <= MID) {
      throw new ArgumentError(oper + " Operation may not have null sub-UnitValues.");
    }

    var unitValue:UnitValue = new UnitValue(value, -1000, unitStr, isHor);
    unitValue.oper = oper;
    // LayoutUtil.putCCString(unitValue, value + "px");
    return unitValue;
  }

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
      switch (_unit) {
        case PIXEL:
          return value;

				case LPX:
				case LPY:
					return parent.getPixelUnitFactor(_unit == LPX) * value;

				case MM:
				case CM:
				case INCH:
				case PT:
					var f:Number = SCALE[unit - MM];
					var s:Number = isHor ? PlatformDefaults.horizontalScaleFactor : PlatformDefaults.verticalScaleFactor;
          if (s == s) {
            f *= s;
          }
					return (isHor ? parent.horizontalScreenDPI : parent.verticalScreenDPI) * value / f;

        case PERCENT:
          return value * refValue * 0.01;

        case SPX:
          return parent.screenWidth * value * 0.01;
        case SPY:
          return parent.screenHeight * value * 0.01;

        case ALIGN:
          var st:Number = LinkHandler.getValue(parent.getLayout(), "visual", isHor ? LinkHandler.X : LinkHandler.Y);
          var sz:Number = LinkHandler.getValue(parent.getLayout(), "visual", isHor ? LinkHandler.WIDTH : LinkHandler.HEIGHT);
          return st != st || sz != sz ? 0 : value * (Math.max(0, sz) - refValue) + st;

        case MIN_SIZE:
          if (comp == null) {
            return 0;
          }
          return isHor ? comp.getMinimumWidth(comp.actualHeight) : comp.getMinimumHeight(comp.actualWidth);

        case PREF_SIZE:
          if (comp == null) {
            return 0;
          }
          return isHor ? comp.getPreferredWidth(comp.actualHeight) : comp.getPreferredHeight(comp.actualWidth);

        case MAX_SIZE:
          if (comp == null) {
            return 0;
          }
          return isHor ? comp.getMaximumWidth(comp.actualHeight) : comp.getMaximumHeight(comp.actualWidth);

        case BUTTON:
          return PlatformDefaults.minimumButtonWidth.getPixels(refValue, parent, comp);

				case LINK_X:
				case LINK_Y:
				case LINK_W:
				case LINK_H:
				case LINK_X2:
				case LINK_Y2:
				case LINK_XPOS:
				case LINK_YPOS:
					var v:Number = LinkHandler.getValue(parent.getLayout(), linkId, _unit - (_unit >= LINK_XPOS ? LINK_XPOS : LINK_X));
          if (v != v) {
            return 0;
          }

          if (_unit == LINK_XPOS) {
            return parent.screenLocationX + v;
          }
          if (_unit == LINK_YPOS) {
            return parent.screenLocationY + v;
          }

          return v;

        case LOOKUP:
          return lookup(refValue, parent, comp);

        case LABEL_ALIGN:
          return PlatformDefaults.labelAlignPercentage * refValue;

        case IDENTITY:
      }
      throw new ArgumentError("Unknown/illegal unit: " + _unit + ", unitStr: " + unitStr);
    }

    if (_subUnits != null && _subUnits.length == 2) {
      var r1:Number = _subUnits[0].getPixelsExact(refValue, parent, comp);
      var r2:Number = _subUnits[1].getPixelsExact(refValue, parent, comp);
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
      if (res != UnitConverter.UNABLE) {
        return res;
      }
    }
    return PlatformDefaults.convertToPixels(value, unitStr, isHor, refValue, parent, comp);
  }

  private function parseUnitString():int {
    const len:int = unitStr.length;
    if (len == 0) {
      return isHor ? PlatformDefaults.defaultHorizontalUnit : PlatformDefaults.defaultVerticalUnit;
    }

    var uu:* = UNIT_MAP[unitStr];
    if (uu != undefined) {
      return int(uu);
    }

    if (unitStr == "lp") {
      return isHor ? LPX : LPY;
    }

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

  internal final function get isLinked():Boolean {
    return linkId != null;
  }

  internal final function get isLinkedDeep():Boolean {
    if (_subUnits == null) {
      return linkId != null;
    }

    for (var i:int = 0; i < _subUnits.length; i++) {
      if (_subUnits[i].isLinkedDeep) {
        return true;
      }
    }

    return false;
  }

  internal final function get linkTargetId():String {
    return linkId;
  }

  internal final function getSubUnitValue(i:int):UnitValue {
    return _subUnits[i];
  }

  internal final function get subUnitCount():int {
    return _subUnits != null ? _subUnits.length : 0;
  }

  public final function get subUnits():Vector.<UnitValue> {
    return _subUnits;
  }

  private var _unit:int;
  public final function get unit():int {
    return _unit;
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
    return getQualifiedClassName(this) + ". Value=" + value + ", unit=" + _unit + ", unitString: " + unitStr + ", oper=" + oper + ", isHor: " + isHor;
  }

  /**
   * Returns the creation string for this object. Note that {@link LayoutUtil# setDesignTime(ContainerWrapper, boolean)} must be
   * set to <code>true</code> for the creation strings to be stored.
   * @return The constraint string or <code>null</code> if none is registered.
   */
  public final function getConstraintString():String {
    return LayoutUtil.getCCString(this);
  }

  public static function addGlobalUnitConverter(conv:UnitConverter):void {
    if (conv == null) {
      throw new ArgumentError("conv must be not null");
    }
    CONVERTERS[CONVERTERS.length] = conv;
  }

  /** Removed the converter.
   * @param conv The converter.
   * @return If there was a converter found and thus removed.
   */
  public static function removeGlobalUnitConverter(conv:UnitConverter):Boolean {
    var index:int = CONVERTERS.indexOf(conv);
    if (index > -1) {
      CONVERTERS.splice(index, 1);
      return true;
    }
    else {
      return false;
    }
  }

  /** Returns the global converters currently registered. The platform converter will not be in this list.
   * @return The converters. Never <code>null</code>.
   */
  public static function get globalUnitConverters():Vector.<UnitConverter> {
    return CONVERTERS.slice();
  }

  ///** Returns the current default unit. The default unit is the unit used if no unit is set. E.g. "width 10".
  // * @return The current default unit.
  // * @see #PIXEL
  // * @see #LPX
  // * @deprecated Use {@link PlatformDefaults#getDefaultHorizontalUnit()} and {@link PlatformDefaults#getDefaultVerticalUnit()} instead.
  // */
  //public static function get defaultUnit() {
  //  return PlatformDefaults.getDefaultHorizontalUnit();
  //}

  ///** Sets the default unit. The default unit is the unit used if no unit is set. E.g. "width 10".
  //	 * @param unit The new default unit.
  //	 * @see #PIXEL
  //	 * @see #LPX
  //	 * @deprecated Use {@link PlatformDefaults#setDefaultHorizontalUnit(int)} and {@link PlatformDefaults#setDefaultVerticalUnit(int)} instead.
  //	 */
  //	public static void setDefaultUnit(int unit)
  //	{
  //		PlatformDefaults.setDefaultHorizontalUnit(unit);
  //		PlatformDefaults.setDefaultVerticalUnit(unit);
  //	}

  //static {
  //        if(LayoutUtil.HAS_BEANS){
  //            LayoutUtil.setDelegate(UnitValue.class, new PersistenceDelegate() {
  //                protected Expression instantiate(Object oldInstance, Encoder out)
  //                {
  //                    UnitValue uv = (UnitValue) oldInstance;
  //                    String cs = uv.getConstraintString();
  //                    if (cs == null)
  //                        throw new IllegalStateException("Design time must be on to use XML persistence. See LayoutUtil.");
  //
  //                    return new Expression(oldInstance, ConstraintParser.class, "parseUnitValueOrAlign", new Object[] {
  //                            uv.getConstraintString(), (uv.isHorizontal() ? Boolean.TRUE : Boolean.FALSE), null
  //                    });
  //                }
  //            });
  //        }
  //	}

  // ************************************************
  	// Persistence Delegate and Serializable combined.
  	// ************************************************

  	//private static final long serialVersionUID = 1L;
    //
  	//private Object readResolve() throws ObjectStreamException
  	//{
  	//	return LayoutUtil.getSerializedObject(this);
  	//}
    //
  	//private void writeObject(ObjectOutputStream out) throws IOException
  	//{
  	//	if (getClass() == UnitValue.class)
  	//		LayoutUtil.writeAsXML(out, this);
  	//}
    //
  	//private void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException
  	//{
  	//	LayoutUtil.setSerializedObject(this, LayoutUtil.readAsXML(in));
  	//}
}
}