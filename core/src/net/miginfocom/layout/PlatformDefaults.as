package net.miginfocom.layout {
import flash.system.Capabilities;
import flash.utils.Dictionary;

/**
 * Currently handles Windows, Mac OS X, and GNOME spacing.
 */
public final class PlatformDefaults {
  private static var DEF_H_UNIT:int = UnitValue.LPX;
  private static var DEF_V_UNIT:int = UnitValue.LPY;

  private static var GAP_PROVIDER:InCellGapProvider = null;

  private static var MOD_COUNT:int = 0;

  private static const LPX4:UnitValue = new UnitValue(4, UnitValue.LPX);
  private static const LPX6:UnitValue = new UnitValue(6, UnitValue.LPX);
  private static const LPX7:UnitValue = new UnitValue(7, UnitValue.LPX);
  //	private static final UnitValue LPX8 = UnitValue.create(8, UnitValue.LPX);
  private static const LPX9:UnitValue = new UnitValue(9, UnitValue.LPX);
  private static const LPX10:UnitValue = new UnitValue(10, UnitValue.LPX);
  private static const LPX11:UnitValue = new UnitValue(11, UnitValue.LPX);
  private static const LPX12:UnitValue = new UnitValue(12, UnitValue.LPX);
  private static const LPX14:UnitValue = new UnitValue(14, UnitValue.LPX);
  private static const LPX16:UnitValue = new UnitValue(16, UnitValue.LPX);
  private static const LPX18:UnitValue = new UnitValue(18, UnitValue.LPX);
  private static const LPX20:UnitValue = new UnitValue(20, UnitValue.LPX);

  private static const LPY4:UnitValue = new UnitValue(4, UnitValue.LPY);
  private static const LPY6:UnitValue = new UnitValue(6, UnitValue.LPY);
  private static const LPY7:UnitValue = new UnitValue(7, UnitValue.LPY);
  //	private static final UnitValue LPY8 = UnitValue.create(8, UnitValue.LPY);
  private static const LPY9:UnitValue = new UnitValue(9, UnitValue.LPY);
  private static const LPY10:UnitValue = new UnitValue(10, UnitValue.LPY);
  private static const LPY11:UnitValue = new UnitValue(11, UnitValue.LPY);
  private static const LPY12:UnitValue = new UnitValue(12, UnitValue.LPY);
  private static const LPY14:UnitValue = new UnitValue(14, UnitValue.LPY);
  private static const LPY16:UnitValue = new UnitValue(16, UnitValue.LPY);
  private static const LPY18:UnitValue = new UnitValue(18, UnitValue.LPY);
  private static const LPY20:UnitValue = new UnitValue(20, UnitValue.LPY);

  public static const WINDOWS_XP:int = 0;
  public static const MAC_OSX:int = 1;
  public static const GNOME:int = 2;
//	private static final int KDE = 3;

  private static var CUR_PLAF:int = MAC_OSX;

  // Used for holding values.
  private static const PANEL_INS:Vector.<UnitValue> = new Vector.<UnitValue>(4, true);
  private static const DIALOG_INS:Vector.<UnitValue> = new Vector.<UnitValue>(4, true);

  private static var BUTTON_FORMAT:String = null;

  private static const HOR_DEFS:Dictionary/*<String, UnitValue>*/ = new Dictionary();
  private static const VER_DEFS:Dictionary/*<String, UnitValue>*/ = new Dictionary();
  private static var DEF_VGAP:BoundSize;
  private static var DEF_HGAP:BoundSize;
  internal static var RELATED_X:BoundSize;
  internal static var RELATED_Y:BoundSize;
  internal static var UNRELATED_X:BoundSize;
  internal static var UNRELATED_Y:BoundSize;
  private static var BUTT_WIDTH:UnitValue;

  private static var horScale:Number;
  private static var verScale:Number;

  /**
   * I value indicating that the size of the font for the container of the component
   * will be used as a base for calculating the logical pixel size. This is much as how
   * Windows calculated DLU (dialog units).
   * @ see net.miginfocom.layout.UnitValue#LPX
   * @ see net.miginfocom.layout.UnitValue#LPY
   * @ see #setLogicalPixelBase(int)
   */
  public static const BASE_FONT_SIZE:int = 100;

  /** I value indicating that the screen DPI will be used as a base for calculating the
   * logical pixel size.
   * <p>
   * This is the default value.
   * @ see net.miginfocom.layout.UnitValue#LPX
   * @ see net.miginfocom.layout.UnitValue#LPY
   * @ see #setLogicalPixelBase(int)
   * @ see #setVerticalScaleFactor(Float)
   * @ see #setHorizontalScaleFactor(Float)
   */
  public static const BASE_SCALE_FACTOR:int = 101;

  /** I value indicating that the size of a logical pixel should always be a real pixel
   * and thus no compensation will be made.
   * @ see net.miginfocom.layout.UnitValue#LPX
   * @ see net.miginfocom.layout.UnitValue#LPY
   * @ see #setLogicalPixelBase(int)
   */
  public static const BASE_REAL_PIXEL:int = 102;

  private static var LP_BASE:int = BASE_SCALE_FACTOR;

  private static var BASE_DPI_FORCED:int = -1;
  private static var BASE_DPI:int = 96;

  private static var dra:Boolean = true;

  {
    setPlatform(getCurrentPlatform());
    MOD_COUNT = 0;
  }

  /**
   * Returns the platform is running on currently.
   * @return The platform is running on currently. E.g. {@link # MAC_OSX}, {@link # WINDOWS_XP}, or {@link # GNOME}.
   */
  public static function getCurrentPlatform():int {
    const os:String = Capabilities.os;
    if (os.indexOf("Mac OS")) {
      return MAC_OSX;
    } else if (os.indexOf("Linux")) {
      return GNOME;
    }
    else {
      return WINDOWS_XP;
    }
  }

  /** Set the defaults to the default for the platform
   * @param plaf The platform. <code>PlatformDefaults.WINDOWS_XP</code>,
   * <code>PlatformDefaults.MAC_OSX</code>, or
   * <code>PlatformDefaults.GNOME</code>.
   */
  public static function setPlatform(plaf:int):void {
    switch (plaf) {
      case WINDOWS_XP:
        setRelatedGap(LPX4, LPY4);
        setUnrelatedGap(LPX7, LPY9);
        setParagraphGap(LPX14, LPY14);
        setIndentGap(LPX9, LPY9);
        setGridCellGap(LPX4, LPY4);

        minimumButtonWidth = new UnitValue(75, UnitValue.LPX);
        buttonOrder = "L_E+U+YNBXOCAH_R";
        setDialogInsets(LPY11, LPX11, LPY11, LPX11);
        setPanelInsets(LPY7, LPX7, LPY7, LPX7);
        break;

      case MAC_OSX:
        setRelatedGap(LPX4, LPY4);
        setUnrelatedGap(LPX7, LPY9);
        setParagraphGap(LPX14, LPY14);
        setIndentGap(LPX10, LPY10);
        setGridCellGap(LPX4, LPY4);

        minimumButtonWidth = new UnitValue(68, UnitValue.LPX);
        buttonOrder = "L_HE+U+NYBXCOA_R";
        setDialogInsets(LPY14, LPX20, LPY20, LPX20);
        setPanelInsets(LPY16, LPX16, LPY16, LPX16);
        break;

      case GNOME:
        setRelatedGap(LPX6, LPY6);                    // GNOME HIG 8.2.3
        setUnrelatedGap(LPX12, LPY12);                // GNOME HIG 8.2.3
        setParagraphGap(LPX18, LPY18);                // GNOME HIG 8.2.3
        setIndentGap(LPX12, LPY12);                   // GNOME HIG 8.2.3
        setGridCellGap(LPX6, LPY6);                   // GNOME HIG 8.2.3

        // GtkButtonBox, child-min-width property default value
        minimumButtonWidth = new UnitValue(85, UnitValue.LPX);
        buttonOrder = "L_HE+UNYACBXIO_R";           // GNOME HIG 3.4.2, 3.7.1
        setDialogInsets(LPY12, LPX12, LPY12, LPX12);  // GNOME HIG 3.4.3
        setPanelInsets(LPY6, LPX6, LPY6, LPX6);       // ???
        break;

      default:
        throw new ArgumentError("Unknown platform: " + plaf);
    }
    CUR_PLAF = plaf;
    BASE_DPI = BASE_DPI_FORCED != -1 ? BASE_DPI_FORCED : 96 /* method getPlatformDPI is deleted, always 96 */;
  }

//private static int getPlatformDPI(int plaf)
//	{
//		switch (plaf) {
//			case WINDOWS_XP:
//			case GNOME:
//				return 96;
//			case MAC_OSX:
//				try {
//					return System.getProperty("java.version").compareTo("1.6") < 0 ? 72 : 96; // Default DPI was 72 prior to JSE 1.6
//				} catch (Throwable t) {
//					return 72;
//				}
//			default:
//				throw new IllegalArgumentException("Unknown platform: " + plaf);
//		}
//	}

  /**
   * Returns the current platform
   * @return <code>PlatformDefaults.WINDOWS</code> or <code>PlatformDefaults.MAC_OSX</code>
   */
  public static function getPlatform():int {
    return CUR_PLAF;
  }

  public static function get defaultDPI():int {
    return BASE_DPI;
  }

  /** Sets the default platform DPI. Normally this is set in the {@link # setPlatform(int)} for the different platforms
   * but it can be tweaked here. For instance SWT on Mac does this.
   * <p>
   * Note that this is not the actual current DPI, but the base DPI for the toolkit.
   * @param dpi The base DPI. If null the default DPI is reset to the platform base DPI.
   */
  public static function set defaultDPI(dpi:int):void {
    BASE_DPI = dpi != -1 ? dpi : 96;
    BASE_DPI_FORCED = dpi;
  }

  /** The forced scale factor that all screen relative units (e.g. millimeters, inches and logical pixels) will be multiplied
   * with. If <code>null</code> this will default to a scale that will scale the current screen to the default screen resolution
   * (72 DPI for Mac and 92 DPI for Windows).
   * @return The forced scale or <code>null</code> for default scaling.
   * @see # getHorizontalScaleFactor()
   * @see ComponentWrapper# getHorizontalScreenDPI()
   */
  public static function get horizontalScaleFactor():Number {
    return horScale;
  }

  /** The forced scale factor that all screen relative units (e.g. millimeters, inches and logical pixels) will be multiplied
   * with. If <code>null</code> this will default to a scale that will scale the current screen to the default screen resolution
   * (72 DPI for Mac and 92 DPI for Windows).
   * @param f The forced scale or <code>null</code> for default scaling.
   * @see # getHorizontalScaleFactor()
   * @see ComponentWrapper# getHorizontalScreenDPI()
   */
  public static function set horizontalScaleFactor(f:Number):void {
    if (!LayoutUtil.equals(horScale, f)) {
      horScale = f;
      MOD_COUNT++;
    }
  }

  /** The forced scale factor that all screen relative units (e.g. millimeters, inches and logical pixels) will be multiplied
   * with. If <code>null</code> this will default to a scale that will scale the current screen to the default screen resolution
   * (72 DPI for Mac and 92 DPI for Windows).
   * @return The forced scale or <code>null</code> for default scaling.
   * @see # getHorizontalScaleFactor()
   * @see ComponentWrapper# getVerticalScreenDPI()
   */
  public static function get verticalScaleFactor():Number {
    return verScale;
  }

  /** The forced scale factor that all screen relative units (e.g. millimeters, inches and logical pixels) will be multiplied
   * with. If <code>null</code> this will default to a scale that will scale the current screen to the default screen resolution
   * (72 DPI for Mac and 92 DPI for Windows).
   * @param f The forced scale or <code>null</code> for default scaling.
   * @see # getHorizontalScaleFactor()
   * @see ComponentWrapper# getVerticalScreenDPI()
   */
  public static function set verticalScaleFactor(value:Number):void {
    if (!LayoutUtil.equals(verScale, value)) {
      verScale = value;
      MOD_COUNT++;
    }
  }

  /** What base value should be used to calculate logical pixel sizes.
   * @return The current base. Default is {@link # BASE_SCALE_FACTOR}
   * @see # BASE_FONT_SIZE
   * @see # BASE_SCREEN_DPI_FACTOR
   * @see # BASE_REAL_PIXEL
   */
  public static function get logicalPixelBase():int {
    return LP_BASE;
  }

  /** What base value should be used to calculate logical pixel sizes.
   * @param value The new base. Default is {@link # BASE_SCALE_FACTOR}
   * @see # BASE_FONT_SIZE
   * @see # BASE_SCREEN_DPI_FACTOR
   * @see # BASE_REAL_PIXEL
   */
  public static function set logicalPixelBase(value:int):void {
    if (LP_BASE != value) {
      if (value < BASE_FONT_SIZE || value > BASE_SCALE_FACTOR) {
        throw new ArgumentError("Unrecognized base: " + value);
      }

      LP_BASE = value;
      MOD_COUNT++;
    }
  }

  /**
   * Sets gap value for components that are "related".
   * @param x The value that will be transformed to pixels. If <code>null</code> the current value will not change.
   * @param y The value that will be transformed to pixels. If <code>null</code> the current value will not change.
   */
  public static function setRelatedGap(x:UnitValue, y:UnitValue):void {
    setUnitValue(new <String>["r", "rel", "related"], x, y);

    RELATED_X = BoundSize.create(x, x, null, "rel:rel");
    RELATED_Y = BoundSize.create(y, y, null, "rel:rel");
  }

  /**
   * Sets gap value for components that are "unrelated".
   * @param x The value that will be transformed to pixels. If <code>null</code> the current value will not change.
   * @param y The value that will be transformed to pixels. If <code>null</code> the current value will not change.
   */
  public static function setUnrelatedGap(x:UnitValue, y:UnitValue):void {
    setUnitValue(new <String>["u", "unrel", "unrelated"], x, y);

    UNRELATED_X = BoundSize.create(x, x, null, "unrel:unrel");
    UNRELATED_Y = BoundSize.create(y, y, null, "unrel:unrel");
  }

  /**
   * Sets paragraph gap value for components.
   * @param x The value that will be transformed to pixels. If <code>null</code> the current value will not change.
   * @param y The value that will be transformed to pixels. If <code>null</code> the current value will not change.
   */
  public static function setParagraphGap(x:UnitValue, y:UnitValue):void {
    setUnitValue(new <String>["p", "para", "paragraph"], x, y);
  }

  /**
   * Sets gap value for components that are "intended".
   * @param x The value that will be transformed to pixels. If <code>null</code> the current value will not change.
   * @param y The value that will be transformed to pixels. If <code>null</code> the current value will not change.
   */
  public static function setIndentGap(x:UnitValue, y:UnitValue):void {
    setUnitValue(new <String>["i", "ind", "indent"], x, y);
  }

  /**
   * Sets gap between two cells in the grid. Note that this is not a gap between component IN a cell, that has to be set
   * on the component constraints. The value will be the min and preferred size of the gap.
   * @param x The value that will be transformed to pixels. If <code>null</code> the current value will not change.
   * @param y The value that will be transformed to pixels. If <code>null</code> the current value will not change.
   */
  public static function setGridCellGap(x:UnitValue, y:UnitValue):void {
    if (x != null) {
      DEF_HGAP = BoundSize.create(x, x, null, null);
    }

    if (y != null) {
      DEF_VGAP = BoundSize.create(y, y, null, null);
    }

    MOD_COUNT++;
  }

  /** Sets the recommended minimum button width.
   * @param width The recommended minimum button width.
   */
  public static function set minimumButtonWidth(width:UnitValue):void {
    BUTT_WIDTH = width;
    MOD_COUNT++;
  }

  /**
   * Returns the recommended minimum button width depending on the current set platform.
   * @return The recommended minimum button width depending on the current set platform.
   */
  public static function get minimumButtonWidth():UnitValue {
    return BUTT_WIDTH;
  }

  /** Returns the unit value associated with the unit. (E.i. "related" or "indent"). Must be lower case.
   * @param unit The unit string.
   * @return The unit value associated with the unit. <code>null</code> for unrecognized units.
   */
  public static function getUnitValueX(unit:String):UnitValue {
    return HOR_DEFS[unit];
  }

  /** Returns the unit value associated with the unit. (E.i. "related" or "indent"). Must be lower case.
   * @param unit The unit string.
   * @return The unit value associated with the unit. <code>null</code> for unrecognized units.
   */
  public static function getUnitValueY(unit:String):UnitValue {
    return VER_DEFS[unit];
  }

  /**
   * Sets the unit value associated with a unit string. This may be used to store values for new unit strings
   * or modify old. Note that if a built in unit (such as "related") is modified all versions of it must be
   * set (I.e. "r", "rel" and "related"). The build in values will be reset to the default ones if the platform
   * is re-set.
   * @param unitStrings The unit strings. E.g. "mu", "myunit". Will be converted to lower case and trimmed. Not <code>null</code>.
   * @param x The value for the horizontal dimension. If <code>null</code> the value is not changed.
   * @param y The value for the vertical dimension. Might be same object as for <code>x</code>. If <code>null</code> the value is not changed.
   */
  public static function setUnitValue(unitStrings:Vector.<String>, x:UnitValue, y:UnitValue):void {
    for (var i:int = 0, n:int = unitStrings.length; i < n; i++) {
      const s:String = Strings.trim(unitStrings[i].toLowerCase());
      if (x != null) {
        HOR_DEFS[s] = x;
      }
      if (y != null) {
        VER_DEFS[s] = y;
      }
    }
    MOD_COUNT++;
  }

  /** Understands ("r", "rel", "related") OR ("u", "unrel", "unrelated") OR ("i", "ind", "indent") OR ("p", "para", "paragraph").
   */
  internal static function convertToPixels(value:Number, unit:String, isHor:Boolean, ref:Number, parent:ContainerWrapper, comp:ComponentWrapper):int {
    var uv:UnitValue = (isHor ? HOR_DEFS : VER_DEFS)[unit];
    return uv != null ? Math.round(value * uv.getPixels(ref, parent, comp)) : UnitConverter.UNABLE;
  }

  /** Returns the order for the typical buttons in a standard button bar. It is one letter per button type.
   * @return The button order.
   * @see # setButtonOrder(String)
   */
  public static function get buttonOrder():String {
    return BUTTON_FORMAT;
  }

  /** Sets the order for the typical buttons in a standard button bar. It is one letter per button type.
   * <p>
   * Letter in upper case will get the minimum button width that the {@link # getMinimumButtonWidth()} specifies
   * and letters in lower case will get the width the current look&feel specifies.
   * <p>
   * Gaps will never be added to before the first component or after the last component. However, '+' (push) will be
   * applied before and after as well, but with a minimum size of 0 if first/last so there will not be a gap
   * before or after.
   * <p>
   * If gaps are explicitly set on buttons they will never be reduced, but they may be increased.
   * <p>
   * These are the characters that can be used:
   * <ul>
   * <li><code>'L'</code> - Buttons with this style tag will staticall end up on the left end of the bar.
   * <li><code>'R'</code> - Buttons with this style tag will staticall end up on the right end of the bar.
   * <li><code>'H'</code> - A tag for the "help" button that normally is supposed to be on the right.
   * <li><code>'E'</code> - A tag for the "help2" button that normally is supposed to be on the left.
   * <li><code>'Y'</code> - A tag for the "yes" button.
   * <li><code>'N'</code> - A tag for the "no" button.
   * <li><code>'X'</code> - A tag for the "next >" or "forward >" button.
   * <li><code>'B'</code> - A tag for the "< back>" or "< previous" button.
   * <li><code>'I'</code> - A tag for the "finish".
   * <li><code>'A'</code> - A tag for the "apply" button.
   * <li><code>'C'</code> - A tag for the "cancel" or "close" button.
   * <li><code>'O'</code> - A tag for the "ok" or "done" button.
   * <li><code>'U'</code> - All Uncategorized, Other, or "Unknown" buttons. Tag will be "other".
   * <li><code>'+'</code> - A glue push gap that will take as much space as it can and at least an "unrelated" gap. (Platform dependant)
   * <li><code>'_'</code> - (underscore) An "unrelated" gap. (Platform dependent)
   * </ul>
   * <p>
   * Even though the style tags are normally applied to buttons this works with all components.
   * <p>
   * The normal style for MAC OS X is <code>"L_HE+U+FBI_NYCOA_R"</code>,
   * for Windows is <code>"L_E+U+FBI_YNOCAH_R"</code>, and for GNOME is
   * <code>"L_HE+UNYACBXIO_R"</code>.
   *
   * @param value The new button order for the current platform.
   */
  public static function set buttonOrder(value:String):void {
    BUTTON_FORMAT = value;
    MOD_COUNT++;
  }

  /** Returns the tag (used in the {@l ink CC}) for a char. The char is same as used in {@link # getButtonOrder()}.
   * @param c The char. Must be lower case!
   * @return The tag that corresponds to the char or <code>null</code> if the char is unrecognized.
   */
  internal static function getTagForChar(c:int):String {
    switch (c) {
      case 111:
        return "ok";
      case 99:
        return "cancel";
      case 104:
        return "help";
      case 101:
        return "help2";
      case 121:
        return "yes";
      case 110:
        return "no";
      case 97:
        return "apply";
      case 120:
        return "next";  // a.k.a forward
      case 98:
        return "back";  // a.k.a. previous
      case 105:
        return "finish";
      case 108:
        return "left";
      case 114:
        return "right";
      case 117:
        return "other";
      default:
        return null;
    }
  }

  /**
   * Returns the platform recommended inter-cell gap in the horizontal (x) dimension..
   * @return The platform recommended inter-cell gap in the horizontal (x) dimension..
   */
  public static function get gridGapX():BoundSize {
    return DEF_HGAP;
  }

  /** Returns the platform recommended inter-cell gap in the vertical (x) dimension..
   * @return The platform recommended inter-cell gap in the vertical (x) dimension..
   */
  public static function get gridGapY():BoundSize {
    return DEF_VGAP;
  }

  /**
   * Returns the default dialog inset depending of the current platform.
   * @param side top == 0, left == 1, bottom = 2, right = 3.
   * @return The inset. Never <code>null</code>.
   */
  public static function getDialogInsets(side:int):UnitValue {
    return DIALOG_INS[side];
  }

  /** Sets the default insets for a dialog. Values that are null will not be changed.
   * @param top The top inset. May be <code>null</code>.
   * @param left The left inset. May be <code>null</code>.
   * @param bottom The bottom inset. May be <code>null</code>.
   * @param right The right inset. May be <code>null</code>.
   */
  public static function setDialogInsets(top:UnitValue, left:UnitValue, bottom:UnitValue, right:UnitValue):void {
    if (top != null) {
      DIALOG_INS[0] = top;
    }
    if (left != null) {
      DIALOG_INS[1] = left;
    }
    if (bottom != null) {
      DIALOG_INS[2] = bottom;
    }
    if (right != null) {
      DIALOG_INS[3] = right;
    }

    MOD_COUNT++;
  }

  /**
   * Returns the default panel inset depending of the current platform.
   * @param side top == 0, left == 1, bottom = 2, right = 3.
   * @return The inset. Never <code>null</code>.
   */
  public static function getPanelInsets(side:int):UnitValue {
    return PANEL_INS[side];
  }

  /** Sets the default insets for a dialog. Values that are null will not be changed.
   * @param top The top inset. May be <code>null</code>.
   * @param left The left inset. May be <code>null</code>.
   * @param bottom The bottom inset. May be <code>null</code>.
   * @param right The right inset. May be <code>null</code>.
   */
  public static function setPanelInsets(top:UnitValue, left:UnitValue, bottom:UnitValue, right:UnitValue):void {
    if (top != null) {
      PANEL_INS[0] = top;
    }
    if (left != null) {
      PANEL_INS[1] = left;
    }
    if (bottom != null) {
      PANEL_INS[2] = bottom;
    }
    if (right != null) {
      PANEL_INS[3] = right;
    }

    MOD_COUNT++;
  }

  /**
   * Returns the percentage used for alignment for labels (0 is left, 50 is center and 100 is right).
   * @return The percentage used for alignment for labels
   */
  public static function get labelAlignPercentage():Number {
    return CUR_PLAF == MAC_OSX ? 1 : 0;
  }

  /** Returns the default gap between two components that <b>are in the same cell</b>.
   * @param comp The component that the gap is for. Never <code>null</code>.
   * @param adjacentComp The adjacent component if any. May be <code>null</code>.
   * @param adjacentSide What side the <code>adjacentComp</code> is on. {@l ink MigConstants#TOP} or
   * {@link MigConstants#LEFT} or {@l ink MigConstants#BOTTOM} or {@link MigConstants#RIGHT}.
   * @param tag The tag string that the component might be tagged with in the component constraints. May be <code>null</code>.
   * @param isLTR If it is left-to-right.
   * @return The default gap between two components or <code>null</code> if there should be no gap.
   */
  internal static function getDefaultComponentGap(comp:ComponentWrapper, adjacentComp:ComponentWrapper, adjacentSide:int, tag:String, isLTR:Boolean):BoundSize {
    if (GAP_PROVIDER != null) {
      return GAP_PROVIDER.getDefaultGap(comp, adjacentComp, adjacentSide, tag, isLTR);
    }
    if (adjacentComp == null) {
      return null;
    }
    return (adjacentSide == MigConstants.LEFT || adjacentSide == MigConstants.RIGHT) ? RELATED_X : RELATED_Y;
  }

  /**
   * Returns the current gap provider or <code>null</code> if none is set and "related" should always be used.
   * @return The current gap provider or <code>null</code> if none is set and "related" should always be used.
   */
  public static function get gapProvider():InCellGapProvider {
    return GAP_PROVIDER;
  }

  /**
   * Sets the current gap provider or <code>null</code> if none is set and "related" should always be used.
   * @param value The current gap provider or <code>null</code> if none is set and "related" should always be used.
   */
  public static function set gapProvider(value:InCellGapProvider):void {
    GAP_PROVIDER = value;
  }

  /**
   * Returns how many times the defaults has been changed. This can be used as a light weight check to
   * see if layout caches needs to be refreshed.
   * @return How many times the defaults has been changed.
   */
  public static function get modCount():int {
    return MOD_COUNT;
  }

  /**
   * Tells all layout manager instances to revalidate and recalculated everything.
   */
  public function invalidate():void {
    MOD_COUNT++;
  }

  /** Returns the current default unit. The default unit is the unit used if no unit is set. E.g. "width 10".
   * @return The current default unit.
   * @see UnitValue #PIXEL
   * @see UnitValue #LPX
   */
  public static function get defaultHorizontalUnit():int {
    return DEF_H_UNIT;
  }

  /** Sets the default unit. The default unit is the unit used if no unit is set. E.g. "width 10".
   * @param unit The new default unit.
   * @see UnitValue #PIXEL
   * @see UnitValue #LPX
   */
  public static function set defaultHorizontalUnit(unit:int):void {
    if (unit < UnitValue.PIXEL || unit > UnitValue.LABEL_ALIGN) {
      throw new ArgumentError("Illegal Unit: " + unit);
    }

    if (DEF_H_UNIT != unit) {
      DEF_H_UNIT = unit;
      MOD_COUNT++;
    }
  }

  /** Returns the current default unit. The default unit is the unit used if no unit is set. E.g. "width 10".
   * @return The current default unit.
   * @see UnitValue #PIXEL
   * @see UnitValue #LPY
   */
  public static function get defaultVerticalUnit():int {
    return DEF_V_UNIT;
  }

  /** Sets the default unit. The default unit is the unit used if no unit is set. E.g. "width 10".
   * @param unit The new default unit.
   * @see UnitValue #PIXEL
   * @see UnitValue #LPY
   */
  public static function set defaultVerticalUnit(unit:int):void {
    if (unit < UnitValue.PIXEL || unit > UnitValue.LABEL_ALIGN) {
      throw new ArgumentError("Illegal Unit: " + unit);
    }

    if (DEF_V_UNIT != unit) {
      DEF_V_UNIT = unit;
      MOD_COUNT++;
    }
  }

  /**
   * The default alignment for rows. Pre v3.5 this was <code>false</code> but now it is
   * <code>true</code>.
   * @return The current value. Default is <code>true</code>.
   * @since 3.5
   */
  public static function get defaultRowAlignmentBaseline():Boolean {
    return dra;
  }

  /**
   * The default alignment for rows. Pre v3.5 this was <code>false</code> but now it is
   * <code>true</code>.
   * @param value The new value. Default is <code>true</code> from v3.5.
   * @since 3.5
   */
  public static function set defaultRowAlignmentBaseline(value:Boolean):void {
    dra = value;
  }
}
}