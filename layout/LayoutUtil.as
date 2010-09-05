package cocoa.layout
{
import flash.utils.Dictionary;

/**
 * A utility class that has only static helper methods.
 */
internal final class LayoutUtil
{
	/**
   * A substitute value for a really large value. Integer.MAX_VALUE is not used since that means a lot of defensive code
	 * for potential overflow must exist in many places. This value is large enough for being unreasonable yet it is hard to
	 * overflow.
	 */
	static const INF:int = (int.MAX_VALUE >> 10) - 100; // To reduce likelihood of overflow errors when calculating.

	/**
   * Tag int for a value that in considered "not set". Used as "null" element in int arrays.
	 */
	static const NOT_SET:int = int.MIN_VALUE + 12346; // Magic value...

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
	public static function get version():String
	{
		return "3.7.3.1";
	}

	/**
   * If global debug should be on or off. If &gt; 0 then debug is turned on for all MigLayout instances.
	 * @return The current debug milliseconds.
	 * @see LC#setDebugMillis(int)
	 */
	public static function get globalDebugMillis():int
	{
		return _globalDebugMillis;
	}

	/** If global debug should be on or off. If &gt; 0 then debug is turned on for all MigLayout
	 * instances.
	 * <p>
	 * Note! This is a passive value and will be read by panels when the needed, which is normally
	 * when they repaint/layout.
	 * @param millis The new debug milliseconds. 0 turns of global debug and leaves debug up to every
	 * individual panel.
	 * @see LC#setDebugMillis(int)
	 */
	public static function set globalDebugMillis(millis:int):void
	{
		_globalDebugMillis = millis;
	}

	/** Sets if design time is turned on for a Container in {@link ContainerWrapper}.
	 * @param cw The container to set design time for. <code>null</code> is legal and can be used as
	 * a key to turn on/off design time "in general". Note though that design time "in general" is
	 * always on as long as there is at least one ContainerWrapper with design time.
	 * <p>
	 * <strong>If this method has not ever been called it will default to what
	 * <code>Beans.isDesignTime()</code> returns.</strong> This means that if you call
	 * this method you indicate that you will take responsibility for the design time value.
	 * @param b <code>true</code> means design time on.
	 */
//	public static void setDesignTime(ContainerWrapper cw, boolean b)
//	{
//		if (DT_MAP == null)
//			DT_MAP = new WeakHashMap<Object, Boolean>();
//
//		DT_MAP.put((cw != null ? cw.getComponent() : null), new Boolean(b));
//	}

	/**
   * Returns if design time is turned on for a Container in {@link ContainerWrapper}.
	 * @param cw The container to set design time for. <code>null</code> is legal will return <code>true</code>
	 * if there is at least one <code>ContainerWrapper</code> (or <code>null</code>) that have design time
	 * turned on.
	 * @return If design time is set for <code>cw</code>.
	 */
	public static function isDesignTime(cw:ContainerWrapper):Boolean
	{
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
	public static function get designTimeEmptySize():int
	{
		return eSz;
	}

	/**
   * The size of an empty row or columns in a grid during design time.
	 * @param pixels The number of pixels. Default is 0 (it was 15 prior to v3.7.2, but since that meant different behaviour
	 * under design time by default it was changed to be 0, same as non-design time). IDE vendors can still set it to 15 to
	 * get the old behaviour.
	 */
	public static function set designTimeEmptySize(pixels:int):void
	{
		eSz = pixels;
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
	static function putCCString(con:Object, s:String):void
	{
		if (s != null && con != null && isDesignTime(null)) {
			if (CR_MAP == null) {
        CR_MAP = new Dictionary(true);
      }

			CR_MAP[con] = s;
		}
	}

	/**
   * Sets/add the persistence delegates to be used for a class.
	 * @param c The class to set the registered deligate for.
	 * @param del The new delegate or <code>null</code> to erase to old one.
	 */
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
	static function getCCString(con:Object):String
	{
		return CR_MAP != null ? CR_MAP[con] : null;
	}

	static function throwCC():void
	{
		throw new Error("setStoreConstraintData(true) must be set for strings to be saved.");
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
	 * @param startSizeType The initial size to use. E.g. {@l ink net.miginfocom.layout.LayoutUtil#MIN}.
	 * @param bounds To use for relative sizes.
	 * @return The sizes. Array length will match <code>sizes</code>.
	 */
	static function calculateSerial(sizes:Vector.<Vector.<int>>, resConstr:Vector.<ResizeConstraint>, defPushWeights:Vector.<Number>, startSizeType:int, bounds:int):Vector.<int>
	{
		var lengths:Vector.<Number> = new Vector.<Number>(sizes.length);	// heights/widths that are set
		var usedLength:Number = 0;

    var i:int; // fucked actionscript
    const sizesLength:int = sizes.length;

		// Give all preferred size to start with
		for (i = 0; i < sizesLength; i++) {
			if (sizes[i] != null) {
				var len:Number = sizes[i][startSizeType] != NOT_SET ? sizes[i][startSizeType] : 0;
				const newSizeBounded:Number = getBrokenBoundary(len, sizes[i][MIN], sizes[i][MAX]);
				if (newSizeBounded != NOT_SET) {
          len = newSizeBounded;
        }

				usedLength += len;
				lengths[i] = len;
			}
		}

    var resC:ResizeConstraint; // fucked actionscript

		const useLengthI:int = Math.round(usedLength);
		if (useLengthI != bounds && resConstr != null) {
			const isGrow:Boolean = useLengthI < bounds;

			// Create a Set with the available priorities
			var prioIntegers:Vector.<int> = new Vector.<int>(sizes.length, true);
      var prioListIndex:int = 0;
			for (i = 0; i < sizesLength; i++) {
				resC = ResizeConstraint(getIndexSafe(resConstr, i));
				if (resC != null) {
          prioIntegers[prioListIndex++] = isGrow ? resC.growPrio : resC.shrinkPrio;
        }
			}
      prioIntegers.fixed = false;
      prioIntegers.length = prioListIndex;
      prioIntegers.fixed = true;
      prioIntegers.sort(intCompareFunction);

			for (var force:int = 0; force <= ((isGrow && defPushWeights != null) ? 1 : 0); force++) { // Run twice if defGrow and the need for growing.
				for (var pr:int = prioIntegers.length - 1; pr >= 0; pr--) {
				  var curPrio:int = prioIntegers[pr];

					var totWeight:Number = 0;
					var resizeWeight:Vector.<Number> = new Vector.<Number>(sizes.length, true);
					for (i = 0; i < sizesLength; i++) {
						if (sizes[i] == null) { // if no min/pref/max size at all do not grow or shrink.
							continue;
            }

						resC = ResizeConstraint(getIndexSafe(resConstr, i));
						if (resC != null) {
							if (curPrio == (/*prio*/ isGrow ? resC.growPrio : resC.shrinkPrio)) {
								if (isGrow) {
									resizeWeight[i] = (force == 0 || resC.grow != null) ? resC.grow : (defPushWeights[i < defPushWeights.length ? i : defPushWeights.length - 1]);
								} else {
									resizeWeight[i] = resC.shrink;
								}
								if (resizeWeight[i] != null) {
                  totWeight += resizeWeight[i];
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
								if (weight != null) {
									var sizeDelta:Number = toChange * weight / totWeight;
									var newSize:Number = lengths[i] + sizeDelta;

									if (sizes[i] != null) {
										if (/*newSizeBounded*/getBrokenBoundary(newSize, sizes[i][MIN], sizes[i][MAX]) != NOT_SET) {
											resizeWeight[i] = null;
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

	static function getIndexSafe(arr:Object/*Vector.<Object>*/, ix:int):Object
	{
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

  static function sum(terms:Vector.<int>, start:int = 0, len:int = 0):int {
    var s:int = 0;
    if (len == 0) {
      len = terms.length;
    }
    for (var i:int = start, iSz:int = start + len; i < iSz; i++) {
      s += terms[i];
    }
    return s;
  }

  public static function getSizeSafe(sizes:Vector.<int>, sizeType:int):int {
    if (sizes == null || sizes[sizeType] == NOT_SET) {
      return sizeType == MAX ? LayoutUtil.INF : 0;
    }
    return sizes[sizeType];
  }

	static function derive(bs:BoundSize, min:UnitValue, pref:UnitValue, max:UnitValue):BoundSize
	{
		if (bs == null || bs.isUnset()) {
      return BoundSize.create(min, pref, max, null);
    }

		return BoundSize.create3(min != null ? min : bs.getMin(), pref != null ? pref : bs.getPreferred(), max != null ? max : bs.getMax(), bs.gapPush, null);
	}

	/**
   * Returns if left-to-right orientation is used. If not set explicitly in the layout constraints the Locale
	 * of the <code>parent</code> is used.
	 * @param lc The constraint if there is one. Can be <code>null</code>.
	 * @param container The parent that may be used to get the left-to-right if ffc does not specify this.
	 * @return If left-to-right orientation is currently used.
	 */
	public static function isLeftToRight(lc:LC, container:ContainerWrapper):Boolean
	{
		if (lc != null && lc.getLeftToRight() != null)
			return lc.getLeftToRight().booleanValue();

		return container == null || container.isLeftToRight();
	}

	/**
   * Round a number of float sizes into int sizes so that the total length match up
	 * @param sizes The sizes to round
	 * @return An array of equal length as <code>sizes</code>.
	 */
	static function roundSizes(sizes:Vector.<Number>):Vector.<int> {
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
//	static function equals(o1:Object, o2:Object):Boolean
//	{
//		return o1 == o2 || (o1 != null && o2 != null && o1.equals(o2));
//	}

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
	 * @param getDefault If <code>true</code> the default insets will get retrieved if <code>lc</code> has none set.
	 * @return The inset for the side. Never <code>null</code>.
	 */
	static final UnitValue getInsets(LC lc, int side, boolean getDefault)
	{
		UnitValue[] i = lc.getInsets();
		return (i != null && i[side] != null) ? i[side] : (getDefault ? PlatformDefaults.getPanelInsets(side) : UnitValue.ZERO);
	}

	/** Writes the objet and CLOSES the stream. Uses the persistence delegate registered in this class.
	 * @param os The stream to write to. Will be closed.
	 * @param o The object to be serialized.
	 * @param listener The listener to recieve the exeptions if there are any. If <code>null</code> not used.
	 */
	static void writeXMLObject(OutputStream os, Object o, ExceptionListener listener)
	{
		ClassLoader oldClassLoader = Thread.currentThread().getContextClassLoader();
		Thread.currentThread().setContextClassLoader(LayoutUtil.class.getClassLoader());

		XMLEncoder encoder = new XMLEncoder(os);

		if (listener != null)
			encoder.setExceptionListener(listener);

		encoder.writeObject(o);
        encoder.close();    // Must be closed to write.

		Thread.currentThread().setContextClassLoader(oldClassLoader);
	}

	private static ByteArrayOutputStream writeOutputStream = null;
	/** Writes an object to XML.
	 * @param out The boject out to write to. Will not be closed.
	 * @param o The object to write.
	 */
	public static synchronized void writeAsXML(ObjectOutput out, Object o) throws IOException
	{
		if (writeOutputStream == null)
			writeOutputStream = new ByteArrayOutputStream(16384);

		writeOutputStream.reset();

		writeXMLObject(writeOutputStream, o, new ExceptionListener() {
			public void exceptionThrown(Exception e) {
				e.printStackTrace();
			}});

		byte[] buf = writeOutputStream.toByteArray();

		out.writeInt(buf.length);
		out.write(buf);
	}

	private static byte[] readBuf = null;
	/** Reads an object from <code>in</code> using the
	 * @param in The object input to read from.
	 * @return The object. Never <code>null</code>.
	 * @throws IOException If there was a problem saving as XML
	 */
	public static synchronized Object readAsXML(ObjectInput in) throws IOException
	{
		if (readBuf == null)
			readBuf = new byte[16384];

		Thread cThread = Thread.currentThread();
		ClassLoader oldCL = null;

		try {
			oldCL = cThread.getContextClassLoader();
			cThread.setContextClassLoader(LayoutUtil.class.getClassLoader());
		} catch(SecurityException e) {
		}

		Object o = null;
		try {
			int length = in.readInt();
			if (length > readBuf.length)
				readBuf = new byte[length];

			in.readFully(readBuf, 0, length);

			o = new XMLDecoder(new ByteArrayInputStream(readBuf, 0, length)).readObject();

		} catch(EOFException e) {
		}

		if (oldCL != null)
			cThread.setContextClassLoader(oldCL);

		return o;
	}

	private static final IdentityHashMap<Object, Object> SER_MAP = new IdentityHashMap<Object, Object>(2);

	/** Sets the serialized object and associates it with <code>caller</code>.
	 * @param caller The object created <code>o</code>
	 * @param o The just serialized object.
	 */
	public static void setSerializedObject(Object caller, Object o)
	{
		synchronized(SER_MAP) {
			SER_MAP.put(caller, o);
		}
	}

	/** Returns the serialized object that are associated with <code>caller</code>. It also removes it from the list.
	 * @param caller The original creator of the object.
	 * @return The object.
	 */
	public static Object getSerializedObject(Object caller)
	{
		synchronized(SER_MAP) {
			return SER_MAP.remove(caller);
		}
	}
}
}