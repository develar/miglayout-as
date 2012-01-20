package net.miginfocom.layout {
/** A size that contains minimum, preferred and maximum size of type {@link UnitValue}.
 * <p>
 * This class is a simple value container and it is immutable.
 * <p>
 * If a size is missing (i.e., <code>null</code>) that boundary should be considered "not in use".
 * <p>
 * You can create a BoundSize from a String with the use of {@link ConstraintParser#parseBoundSize(String, boolean, boolean)}
 */
public final class BoundSize {
  public static const NULL_SIZE:BoundSize = createSame(null);
  public static const ZERO_PIXEL:BoundSize = createSame(UnitValue.ZERO, "0px");

  private var _min:UnitValue;
  private var _pref:UnitValue;
  private var _max:UnitValue;
  private var _gapPush:Boolean;

  public function BoundSize(min:UnitValue, pref:UnitValue, max:UnitValue) {
    _min = min;
    _pref = pref;
    _max = max;
  }

  //noinspection JSUnusedLocalSymbols
  /** Constructor that use the same value for min/preferred/max size.
   * @param minMaxPref The value to use for min/preferred/max size.
   * @param createString The string used to create the BoundsSize.
   */
//	public BoundSize(UnitValue minMaxPref, String createString)
//	{
//		this(minMaxPref, minMaxPref, minMaxPref, createString);
//	}

  public static function createSame(minMaxPref:UnitValue, createString:String = null):BoundSize {
    return new BoundSize(minMaxPref, minMaxPref, minMaxPref);
  }

  //noinspection JSUnusedLocalSymbols
  /** Constructor. <b>This method is here for serilization only and should normally not be used. Use
   * {@link ConstraintParser# parseBoundSize(String, boolean, boolean)} instead.
   * @param min The minimum size. May be <code>null</code>.
   * @param preferred  The preferred size. May be <code>null</code>.
   * @param max  The maximum size. May be <code>null</code>.
   * @param createString The string used to create the BoundsSize.
   */
//	public BoundSize(UnitValue min, UnitValue preferred, UnitValue max, String createString)    // Bound to old delegate!!!!!
//	{
//		this(min, preferred, max, false, createString);
//	}
  //noinspection JSUnusedLocalSymbols
  internal static function create(min:UnitValue, preferred:UnitValue, max:UnitValue, createString:String):BoundSize {
    var boundSize:BoundSize = new BoundSize(min, preferred, max);
//    LayoutUtil.putCCString(boundSize, createString);
    return boundSize;
  }

  //noinspection JSUnusedLocalSymbols
  internal static function create3(min:UnitValue, preferred:UnitValue, max:UnitValue, gapPush:Boolean, createString:String):BoundSize {
    var boundSize:BoundSize = new BoundSize(min, preferred, max);
    boundSize._gapPush = gapPush;
    return boundSize;
  }

  ///**
  // * <b>This method is here for serilization only and should normally not be used. Use
  // * {@link ConstraintParser# parseBoundSize(String, boolean, boolean)} instead.
  // * @param min The minimum size. May be <code>null</code>.
  // * @param preferred  The preferred size. May be <code>null</code>.
  // * @param max  The maximum size. May be <code>null</code>.
  // * @param gapPush If the size should be hinted as "pushing" and thus want to occupy free space if no one else is claiming it.
  // * @param createString The string used to create the BoundsSize.
  // */
//	public BoundSize(UnitValue min, UnitValue preferred, UnitValue max, boolean gapPush, String createString)
//	{
//		this.min = min;
//		this.pref = preferred;
//		this.max = max;
//		this.gapPush = gapPush;
//
//		LayoutUtil.putCCString(this, createString);    // this escapes!!
//	}

  /**
   * Returns the minimum size as sent into the constructor.
   * @return The minimum size as sent into the constructor. May be <code>null</code>.
   */
  public function get min():UnitValue {
    return _min;
  }

  /**
   * Returns the preferred size as sent into the constructor.
   * @return The preferred size as sent into the constructor. May be <code>null</code>.
   */
  public function get preferred():UnitValue {
    return _pref;
  }

  /**
   * Returns the maximum size as sent into the constructor.
   * @return The maximum size as sent into the constructor. May be <code>null</code>.
   */
  public function get max():UnitValue {
    return _max;
  }

  /** If the size should be hinted as "pushing" and thus want to occupy free space if noone else is claiming it.
   * @return The value.
   */
  public function get gapPush():Boolean {
    return _gapPush;
  }

  /** Returns if this bound size has no min, preferred and maximum size set (they are all <code>null</code>)
   * @return If unset.
   */
  public function get isUnset():Boolean {
    // Most common case by far is this == ZERO_PIXEL...
    // develar WTF!!!??? ZERO_PIXEL is 0px otherwise you must use NULL_SIZE
    //return this == ZERO_PIXEL || (_pref == null && _min == null && _max == null && !_gapPush);
    return (_pref == null && _min == null && _max == null && !_gapPush);
  }

  /**
   * Makes sure that <code>size</code> is within min and max of this size.
   * @param size The size to constrain.
   * @param refValue The reference to use for relative sizes.
   * @param parent The parent container.
   * @return The size, constrained within min and max.
   */
  public function constrain(size:int, refValue:Number, parent:ContainerWrapper):int {
    if (max != null) {
      size = Math.min(size, max.getPixels(refValue, parent, parent));
    }
    if (min != null) {
      size = Math.max(size, min.getPixels(refValue, parent, parent));
    }
    return size;
  }

  /**
   * Returns the minimum, preferred or maximum size for this bounded size.
   *
   * @param sizeType The type. <code>LayoutUtil.MIN</code>, <code>LayoutUtil.PREF</code> or <code>LayoutUtil.MAX</code>.
   * @return
   */
  internal function getSize(sizeType:int):UnitValue {
    switch (sizeType) {
      case LayoutUtil.MIN:
        return _min;
      case LayoutUtil.PREF:
        return _pref;
      case LayoutUtil.MAX:
        return _max;
      default:
        throw new ArgumentError("Unknown size: " + sizeType);
    }
  }

  /** Convert the bound sizes to pixels.
   * <p>
   * <code>null</code> bound sizes will be 0 for min and preferred and {@l ink net.miginfocom.layout.LayoutUtil#INF} for max.
   * @param refSize The reference size.
   * @param parent The parent. Not <code>null</code>.
   * @param comp The component, if applicable, can be <code>null</code>.
   * @return An array of lenth three (min,pref,max).
   */
  internal function getPixelSizes(refSize:Number, parent:ContainerWrapper, comp:ComponentWrapper):Vector.<int> {
    return new <int>[
      _min != null ? _min.getPixels(refSize, parent, comp) : 0,
      _pref != null ? _pref.getPixels(refSize, parent, comp) : 0,
      _max != null ? _max.getPixels(refSize, parent, comp) : LayoutUtil.INF
    ];
  }

  internal function checkNotLinked():void {
    if (_min != null && _min.isLinkedDeep || _pref != null && _pref.isLinkedDeep || _max != null && _max.isLinkedDeep) {
      throw new ArgumentError("Size may not contain links");
    }
  }
}
}