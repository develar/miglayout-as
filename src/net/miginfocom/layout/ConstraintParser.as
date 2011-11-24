package net.miginfocom.layout {
/**
 * Parses string constraints.
 */
public final class ConstraintParser {
  /** Parses the layout constraints and stores the parsed values in the transient (cache) member varables.
   * @param s The String to parse. Should not be <code>null</code> and <b>must be lower case and trimmed</b>.
   * @throws RuntimeException if the constaint was not valid.
   * @return The parsed constraint. Never <code>null</code>.
   */
  public static function parseLayoutConstraint(s:String):LC {
		var lcBuilder:LCBuilder = new LCBuilder();
		var lc:LC = lcBuilder.lc;
		if (s.length == 0) {
			return lc;
    }

		var parts:Vector.<String> = toTrimmedTokens(s, 44 /*','*/);
    var i:int;
    var part:String;
		// First check for "ltr" or "rtl" since that will affect the interpretation of the other constraints.
    for (i = 0; i < parts.length; i++) {
      part = parts[i];
      if (part == null) {
        continue;
      }

			var len:int = part.length;
			if (len == 3 || len == 11) {   // Optimization
				if (part == "ltr" || part == "rtl" || part ==  "lefttoright" || part == "righttoleft") {
					lc.leftToRight = part.charCodeAt(0) == 108  /* l */;
					parts[i] = null;    // So we will not try to interpret it again
				}
        else if (part == "ttb" || part == "btt" || part == "toptobottom" || part == "bottomtotop") {
					lc.topToBottom = part.charCodeAt(0) == 116 /* t */;
					parts[i] = null;    // So we will not try to interpret it again
				}
			}
		}

    var sz:String;
    for each (part in parts) {
      if (part == null || part.length == 0) {
        continue;
      }

			try {
				var ix:int = -1;
				var c:int = part.charCodeAt(0);

				if (c == 119 || c == 104) {

					ix = startsWithLenient2(part, "wrap", -1, true);
					if (ix > -1) {
						var num:String = Strings.trim2(part, ix, part.length);
						lc.wrapAfter = num.length != 0 ? parseInt(num) : 0;
						continue;
					}

					var isHor:Boolean = c == 119;
					if (isHor && (part.charCodeAt(0) == 119 || Strings.startsWith(, "width "))) {
						sz = Strings.trim2(part, part.charCodeAt(1) == 32 ? 2 : 6, part.length);
						lc.width = parseBoundSize(sz, false, true);
						continue;
					}

					if (!isHor && (Strings.startsWith(part, "h ") || Strings.startsWith(part, "height "))) {
						var uvStr:String = Strings.trim2(part, part.charCodeAt(1) == 32 ? 2 : 7, s.length);
						lc.height = (parseBoundSize(uvStr, false, false));
						continue;
					}

					if (part.length > 5) {
						sz = Strings.trim2(part, 5, part.length);
            if (Strings.startsWith(part, "wmin ")) {
              lcBuilder.minWidth(sz);
              continue;
            }
            else if (Strings.startsWith(part, "wmax ")) {
              lcBuilder.maxWidth(sz);
              continue;
            }
            else if (Strings.startsWith(part, "hmin ")) {
              lcBuilder.minHeight(sz);
              continue;
            }
            else if (Strings.startsWith(part, "hmax ")) {
              lcBuilder.maxHeight(sz);
              continue;
            }
					}

					if (Strings.startsWith(part, "hidemode ")) {
						lc.hideMode = parseInt(part.substring(9));
						continue;
					}
				}

				if (c == 103) {
					if (Strings.startsWith(part, "gapx ")) {
						lc.gridGapX = parseBoundSize(Strings.trim2(part, 5, part.length), true, true);
						continue;
					}

					if (Strings.startsWith(part, "gapy ")) {
						lc.gridGapY = parseBoundSize(Strings.trim2(part, 5, part.length), true, false);
						continue;
					}

					if (Strings.startsWith(part, "gap ")) {
						var gaps:Vector.<String> = toTrimmedTokens(Strings.trim2(part, 4, part.length), 32);
						lc.gridGapX = (parseBoundSize(gaps[0], true, true));
						lc.gridGapY = gaps.length > 1 ? parseBoundSize(gaps[1], true, false) : lc.gridGapX;
						continue;
					}
				}

				if (c == 100) {
					ix = startsWithLenient2(part, "debug", 5, true);
					if (ix > -1) {
						var millis:String = Strings.trim2(part, ix, part.length);
						lc.debugMillis = millis.length > 0 ? parseInt(millis) : 1000;
						continue;
					}
				}

				if (c == 110) {
					if (part == "nogrid") {
						lc.noGrid = true;
						continue;
					}
          else if (part == "nocache") {
						lc.noCache = true;
						continue;
					}
          else if (part == "novisualpadding") {
						lc.visualPadding = false;
						continue;
					}
				}
        else if (c == 102) {
					if (part == "fill" || part == "fillx" || part == "filly") {
						lc.fillX = part.length == 4 || part.charCodeAt(4) == 120;
						lc.fillY = part.length == 4 || part.charCodeAt(4) == 121;
						continue;
					}

					if (part == "flowy") {
						lc.flowX = false;
						continue;
					}
          else if (part == "flowx") {
						lc.flowX = true; // This is the default but added for consistency
						continue;
					}
				}

        if (c == 105) {
          ix = startsWithLenient2(part, "insets", 3, true);
          if (ix > -1) {
            var insStr:String = Strings.trim2(part, ix, part.length);
            var ins:Vector.<UnitValue> = parseInsets(insStr, true);
            LayoutUtil.putCCString(ins, insStr);
            lc.insets = ins;
            continue;
          }
        }

				if (c == 97) {
          ix = startsWithLenient(part, new <String>["aligny", "ay"], new <int>[6, 2], true);
          if (ix > -1) {
            var align:UnitValue = parseUnitValueOrAlign(Strings.trim2(part, ix, part.length), false, null);
            if (align == UnitValue.BASELINE_IDENTITY) {
              throw new ArgumentError("'baseline' can not be used to align the whole component group.");
            }
            lc.alignY = align;
            continue;
          }

          ix = startsWithLenient(part, new <String>["alignx", "ax"], new <int>[6, 2], true);
					if (ix > -1) {
						lc.alignX = parseUnitValueOrAlign(Strings.trim2(part, ix, part.length), true, null);
						continue;
					}

					ix = startsWithLenient2(part, "align", 2, true);
					if (ix > -1) {
						var gaps :Vector.<String>= toTrimmedTokens(Strings.trim2(part, ix, part.length), 32);
						lc.alignX = parseUnitValueOrAlign(gaps[0], true, null);
						lc.alignY = gaps.length > 1 ? parseUnitValueOrAlign(gaps[1], false, null) : lc.alignX;
						continue;
					}
        }

        var packs:Vector.<String>;
        if (c == 112) {
          if (Strings.startsWith(part, "packalign ")) {
            packs = toTrimmedTokens(Strings.trim2(part, 10, part.length), 32);
            lc.packWidthAlign = packs[0].length > 0 ? parseFloat(packs[0]) : 0.5;
            if (packs.length > 1) {
              lc.packHeightAlign = parseFloat(packs[1]);
            }
            continue;
          }
          else if (Strings.startsWith(part, "pack ") || part == "pack") {
            var ps:String = Strings.trim2(part, 4, part.length);
            packs = toTrimmedTokens(ps.length > 0 ? ps : "pref pref", 32);
            lc.packWidth = parseBoundSize(packs[0], false, true);
            if (packs.length > 1) {
              lc.packHeight = parseBoundSize(packs[1], false, false);
            }

            continue;
          }
				}

        if (lc.alignX == null) {
          var alignX:UnitValue = parseAlignKeywords(part, true);
          if (alignX != null) {
            lc.alignX = alignX;
            continue;
          }
				}

				var alignY:UnitValue = parseAlignKeywords(part, false);
				if (alignY != null) {
					lc.alignY = alignY;
					continue;
				}

				throw new ArgumentError("Unknown Constraint: '" + part + "'\n");

      }
      catch (e:Error) {
        throw new ArgumentError("Illegal Constraint: '" + part + "'\n" + e.message);
      }
		}

		return lc;
	}

  /** Parses the column or rows constraints. They normally looks something like <code>"[min:pref]rel[10px][]"</code>.
   * @param s The string to parse. Not <code>null</code>.
   * @return An array of {@link DimConstraint}s that is as manu are there exist "[...]" sections in the string that is parsed.
   * @throws RuntimeException if the constaint was not valid.
   */
  public static function parseRowConstraints(s:String):AC {
    return parseAxisConstraint(s, false);
  }

  /** Parses the column or rows constraints. They normally looks something like <code>"[min:pref]rel[10px][]"</code>.
   * @param s The string to parse. Not <code>null</code>.
   * @return An array of {@link DimConstraint}s that is as manu are there exist "[...]" sections in the string that is parsed.
   * @throws RuntimeException if the constaint was not valid.
   */
  public static function parseColumnConstraints(s:String):AC {
    return parseAxisConstraint(s, true);
  }

  /** Parses the column or rows constraints. They normally looks something like <code>"[min:pref]rel[10px][]"</code>.
   * @param s The string to parse. Not <code>null</code>.
   * @param isCols If this for columns rather than rows.
   * @return An array of {@link DimConstraint}s that is as manu are there exist "[...]" sections in the string that is parsed.
   * @throws RuntimeException if the constaint was not valid.
   */
  private static function parseAxisConstraint(s:String, isCols:Boolean):AC {
    s = Strings.trim(s);
    if (s.length == 0) {
      return new AC();
    }    // Short circuit for performance.

    s = s.toLowerCase();

		var parts:Vector.<String> = getRowColAndGapsTrimmed(s);

		BoundSize[] gaps = new BoundSize[(parts.size() >> 1) + 1];
		for (int i = 0, iSz = parts.size(), gIx = 0; i < iSz; i += 2, gIx++)
			gaps[gIx] = parseBoundSize(parts.get(i), true, isCols);

		DimConstraint[] colSpecs = new DimConstraint[parts.size() >> 1];
		for (int i = 0, gIx = 0; i < colSpecs.length; i++, gIx++) {
			if (gIx >= gaps.length - 1)
				gIx = gaps.length - 2;

			colSpecs[i] = parseDimConstraint(parts.get((i << 1) + 1), gaps[gIx], gaps[gIx + 1], isCols);
		}

		AC ac = new AC();
		ac.setConstaints(colSpecs);

//		ac = (AC) serializeTest(ac);

		return ac;
	}

	/** Parses a single column or row constriant.
	 * @param s The single constrint to parse. May look something like <code>"min:pref,fill,grow"</code>. Should not be <code>null</code> and <b>must
	 * be lower case and trimmed</b>.
	 * @param gapBefore The default gap "before" the column/row constraint. Can be overridden with a <code>"gap"</code> section within <code>s</code>.
	 * @param gapAfter The default gap "after" the column/row constraint. Can be overridden with a <code>"gap"</code> section within <code>s</code>.
	 * @param isCols If the constraints are column constraints rather than row constraints.
	 * @return A single constraint. Never <code>null</code>.
	 * @throws RuntimeException if the constaint was not valid.
	 */
	private static DimConstraint parseDimConstraint(String s, BoundSize gapBefore, BoundSize gapAfter, boolean isCols)
	{
		DimConstraint dimConstraint = new DimConstraint();

		// Default values.
		dimConstraint.setGapBefore(gapBefore);
		dimConstraint.setGapAfter(gapAfter);

		String[] parts = toTrimmedTokens(s, ',');
		for (int i = 0; i < parts.length; i++) {
			String part = parts[i];
			try {
				if (part.length() == 0)
					continue;

				if (part.equals("fill")) {
					dimConstraint.setFill(true);
//					 dimConstraint.setAlign(null);   // Can not have both fill and alignment (changed for 3.5 since it can have "growy 0")
					continue;
				}

				if (part.equals("nogrid")) {
					dimConstraint.setNoGrid(true);
					continue;
				}

				int ix = -1;
				char c = part.charAt(0);

				if (c == 's') {
					ix = startsWithLenient(part, new String[] {"sizegroup", "sg"}, new int[] {5, 2}, true);
					if (ix > -1) {
						dimConstraint.setSizeGroup(part.substring(ix).trim());
						continue;
					}


					ix = startsWithLenient(part, new String[] {"shrinkprio", "shp"}, new int[] {10, 3}, true);
					if (ix > -1) {
						dimConstraint.setShrinkPriority(Integer.parseInt(part.substring(ix).trim()));
						continue;
					}

					ix = startsWithLenient(part, "shrink", 6, true);
					if (ix > -1) {
						dimConstraint.setShrink(parseFloat(part.substring(ix).trim(), ResizeConstraint.WEIGHT_100));
						continue;
					}
				}

				if (c == 'g') {
					ix = startsWithLenient(part, new String[] {"growpriority", "gp"}, new int[] {5, 2}, true);
					if (ix > -1) {
						dimConstraint.setGrowPriority(Integer.parseInt(part.substring(ix).trim()));
						continue;
					}

					ix = startsWithLenient(part, "grow", 4, true);
					if (ix > -1) {
						dimConstraint.setGrow(parseFloat(part.substring(ix).trim(), ResizeConstraint.WEIGHT_100));
						continue;
					}
				}

				if (c == 'a') {
					ix = startsWithLenient(part, "align", 2, true);
					if (ix > -1) {
//						if (dimConstraint.isFill() == false)    // Swallow, but ignore if fill is set. (changed for 3.5 since it can have "growy 0")
							dimConstraint.setAlign(parseUnitValueOrAlign(part.substring(ix).trim(), isCols, null));
						continue;
					}
				}

				UnitValue align = parseAlignKeywords(part, isCols);
				if (align != null) {
//					if (dimConstraint.isFill() == false)    // Swallow, but ignore if fill is set. (changed for 3.5 since it can have "growy 0")
						dimConstraint.setAlign(align);
					continue;
				}

				 // Only min:pref:max still left that is ok
				dimConstraint.setSize(parseBoundSize(part, false, isCols));

			} catch (Exception ex) {
				throw new IllegalArgumentException("Illegal contraint: '" + part + "'\n" + ex.getMessage());
			}
		}
		return dimConstraint;
	}

	/** Parses all component constraints and stores the parsed values in the transient (cache) member varables.
	 * @param constrMap The constraints as <code>String</code>s. Strings <b>must be lower case and trimmed</b>
	 * @return The parsed constraints. Never <code>null</code>.
	 */
	public static Map<ComponentWrapper, CC> parseComponentConstraints(Map<ComponentWrapper, String> constrMap)
	{
		HashMap<ComponentWrapper, CC> flowConstrMap = new HashMap<ComponentWrapper, CC>();

		for (Iterator<Map.Entry<ComponentWrapper, String>> it = constrMap.entrySet().iterator(); it.hasNext();) {
			Map.Entry<ComponentWrapper, String> entry = it.next();
			flowConstrMap.put(entry.getKey(), parseComponentConstraint(entry.getValue()));
		}

		return flowConstrMap;
	}

	/** Parses one component constraint and returns the parsed value.
	 * @param s The string to parse. Should not be <code>null</code> and <b>must be lower case and trimmed</b>.
	 * @throws RuntimeException if the constaint was not valid.
	 * @return The parsed constraint. Never <code>null</code>.
	 */
	public static CC parseComponentConstraint(String s)
	{
		CC cc = new CC();

		if (s.length() == 0)
			return cc;

		String[] parts = toTrimmedTokens(s, ',');

		for (int i = 0; i < parts.length; i++) {
			String part = parts[i];
			try {
				if (part.length() == 0)
					continue;

				int ix = -1;
				char c = part.charAt(0);

				if (c == 'n') {
					if (part.equals("north")) {
						cc.setDockSide(0);
						continue;
					}

					if (part.equals("newline")) {
						cc.setNewline(true);
						continue;
					}

					if (part.startsWith("newline ")) {
						String gapSz = part.substring(7).trim();
						cc.setNewlineGapSize(parseBoundSize(gapSz, true, true));
						continue;
					}
				}

				if (c == 'f' && (part.equals("flowy") || part.equals("flowx"))) {
					cc.setFlowX(part.charAt(4) == 'x' ? Boolean.TRUE : Boolean.FALSE);
					continue;
				}

				if (c == 's') {
					ix = startsWithLenient(part, "skip", 4, true);
					if (ix > -1) {
						String num = part.substring(ix).trim();
						cc.setSkip(num.length() != 0 ? Integer.parseInt(num) : 1);
						continue;
					}

					ix = startsWithLenient(part, "split", 5, true);
					if (ix > -1) {
						String split = part.substring(ix).trim();
						cc.setSplit(split.length() > 0 ? Integer.parseInt(split) : LayoutUtil.INF);
						continue;
					}

					if (part.equals("south")) {
						cc.setDockSide(2);
						continue;
					}

					ix = startsWithLenient(part, new String[] {"spany","sy"}, new int[] {5, 2}, true);
					if (ix > -1) {
						cc.setSpanY(parseSpan(part.substring(ix).trim()));
						continue;
					}

					ix = startsWithLenient(part, new String[] {"spanx","sx"}, new int[] {5, 2}, true);
					if (ix > -1) {
						cc.setSpanX(parseSpan(part.substring(ix).trim()));
						continue;
					}

					ix = startsWithLenient(part, "span", 4, true);
					if (ix > -1) {
						String[] spans = toTrimmedTokens(part.substring(ix).trim(), ' ');
						cc.setSpanX(spans[0].length() > 0 ? Integer.parseInt(spans[0]) : LayoutUtil.INF);
						cc.setSpanY(spans.length > 1 ? Integer.parseInt(spans[1]) : 1);
						continue;
					}

					ix = startsWithLenient(part, "shrinkx", 7, true);
					if (ix > -1) {
						cc.getHorizontal().setShrink(parseFloat(part.substring(ix).trim(), ResizeConstraint.WEIGHT_100));
						continue;
					}

					ix = startsWithLenient(part, "shrinky", 7, true);
					if (ix > -1) {
						cc.getVertical().setShrink(parseFloat(part.substring(ix).trim(), ResizeConstraint.WEIGHT_100));
						continue;
					}

					ix = startsWithLenient(part, "shrink", 6, false);
					if (ix > -1) {
						String[] shrinks = toTrimmedTokens(part.substring(ix).trim(), ' ');
						cc.getHorizontal().setShrink(parseFloat(part.substring(ix).trim(), ResizeConstraint.WEIGHT_100));
						if (shrinks.length > 1)
							cc.getVertical().setShrink(parseFloat(part.substring(ix).trim(), ResizeConstraint.WEIGHT_100));
						continue;
					}

					ix = startsWithLenient(part, new String[] {"shrinkprio", "shp"}, new int[] {10, 3}, true);
					if (ix > -1) {
						String sp = part.substring(ix).trim();
						if (sp.startsWith("x") || sp.startsWith("y")) { // To gandle "gpx", "gpy", "shrinkpriorityx", shrinkpriorityy"
							(sp.startsWith("x") ? cc.getHorizontal() : cc.getVertical()).setShrinkPriority(Integer.parseInt(sp.substring(2)));
						} else {
							String[] shrinks = toTrimmedTokens(sp, ' ');
							cc.getHorizontal().setShrinkPriority(Integer.parseInt(shrinks[0]));
							if (shrinks.length > 1)
								cc.getVertical().setShrinkPriority(Integer.parseInt(shrinks[1]));
						}
						continue;
					}

					ix = startsWithLenient(part, new String[] {"sizegroupx", "sizegroupy", "sgx", "sgy"}, new int[] {9, 9, 2, 2}, true);
					if (ix > -1) {
						String sg = part.substring(ix).trim();
						char lc = part.charAt(ix - 1);
						if (lc != 'y')
							cc.getHorizontal().setSizeGroup(sg);
						if (lc != 'x')
							cc.getVertical().setSizeGroup(sg);
						continue;
					}
				}

				if (c == 'g') {
					ix = startsWithLenient(part, "growx", 5, true);
					if (ix > -1) {
						cc.getHorizontal().setGrow(parseFloat(part.substring(ix).trim(), ResizeConstraint.WEIGHT_100));
						continue;
					}

					ix = startsWithLenient(part, "growy", 5, true);
					if (ix > -1) {
						cc.getVertical().setGrow(parseFloat(part.substring(ix).trim(), ResizeConstraint.WEIGHT_100));
						continue;
					}

					ix = startsWithLenient(part, "grow", 4, false);
					if (ix > -1) {
						String[] grows = toTrimmedTokens(part.substring(ix).trim(), ' ');
						cc.getHorizontal().setGrow(parseFloat(grows[0], ResizeConstraint.WEIGHT_100));
						cc.getVertical().setGrow(parseFloat(grows.length > 1 ? grows[1] : "", ResizeConstraint.WEIGHT_100));
						continue;
					}

					ix = startsWithLenient(part, new String[] {"growprio", "gp"}, new int[] {8, 2}, true);
					if (ix > -1) {
						String gp = part.substring(ix).trim();
						char c0 = gp.length() > 0 ? gp.charAt(0) : ' ';
						if (c0 == 'x' || c0 == 'y') { // To gandle "gpx", "gpy", "growpriorityx", growpriorityy"
							(c0 == 'x' ? cc.getHorizontal() : cc.getVertical()).setGrowPriority(Integer.parseInt(gp.substring(2)));
						} else {
							String[] grows = toTrimmedTokens(gp, ' ');
							cc.getHorizontal().setGrowPriority(Integer.parseInt(grows[0]));
							if (grows.length > 1)
								cc.getVertical().setGrowPriority(Integer.parseInt(grows[1]));
						}
						continue;
					}

					if (part.startsWith("gap")) {
						BoundSize[] gaps = parseGaps(part); // Changes order!!
						if (gaps[0] != null)
							cc.getVertical().setGapBefore(gaps[0]);
						if (gaps[1] != null)
							cc.getHorizontal().setGapBefore(gaps[1]);
						if (gaps[2] != null)
							cc.getVertical().setGapAfter(gaps[2]);
						if (gaps[3] != null)
							cc.getHorizontal().setGapAfter(gaps[3]);
						continue;
					}
				}

				if (c == 'a') {
					ix = startsWithLenient(part, new String[] {"aligny", "ay"}, new int[] {6, 2}, true);
					if (ix > -1) {
						cc.getVertical().setAlign(parseUnitValueOrAlign(part.substring(ix).trim(), false, null));
						continue;
					}

					ix = startsWithLenient(part, new String[] {"alignx", "ax"}, new int[] {6, 2}, true);
					if (ix > -1) {
						cc.getHorizontal().setAlign(parseUnitValueOrAlign(part.substring(ix).trim(), true, null));
						continue;
					}

					ix = startsWithLenient(part, "align", 2, true);
					if (ix > -1) {
						String[] gaps = toTrimmedTokens(part.substring(ix).trim(), ' ');
						cc.getHorizontal().setAlign(parseUnitValueOrAlign(gaps[0], true, null));
						if (gaps.length > 1)
							cc.getVertical().setAlign(parseUnitValueOrAlign(gaps[1], false, null));
						continue;
					}
				}

				if ((c == 'x' || c == 'y') && part.length() > 2) {
					char c2 = part.charAt(1);
					if (c2 == ' ' || (c2 == '2' && part.charAt(2) == ' ')) {
						if (cc.getPos() == null) {
							cc.setPos(new UnitValue[4]);
						} else if (cc.isBoundsInGrid() == false) {
							throw new IllegalArgumentException("Cannot combine 'position' with 'x/y/x2/y2' keywords.");
						}

						int edge = (c == 'x' ? 0 : 1) + (c2 == '2' ? 2 : 0);
						UnitValue[] pos = cc.getPos();
						pos[edge] = parseUnitValue(part.substring(2).trim(), null, c == 'x');
						cc.setPos(pos);
						cc.setBoundsInGrid(true);
						continue;
					}
				}

				if (c == 'c') {
					ix = startsWithLenient(part, "cell", 4, true);
					if (ix > -1) {
						String[] grs = toTrimmedTokens(part.substring(ix).trim(), ' ');
						if (grs.length < 2)
							throw new IllegalArgumentException("At least two integers must follow " + part);
						cc.setCellX(Integer.parseInt(grs[0]));
						cc.setCellY(Integer.parseInt(grs[1]));
						if (grs.length > 2)
							cc.setSpanX(Integer.parseInt(grs[2]));
						if (grs.length > 3)
							cc.setSpanY(Integer.parseInt(grs[3]));
						continue;
					}
				}

				if (c == 'p') {
					ix = startsWithLenient(part, "pos", 3, true);
					if (ix > -1) {
						if (cc.getPos() != null && cc.isBoundsInGrid())
							throw new IllegalArgumentException("Can not combine 'pos' with 'x/y/x2/y2' keywords.");

						String[] pos = toTrimmedTokens(part.substring(ix).trim(), ' ');
						UnitValue[] bounds = new UnitValue[4];
						for (int j = 0; j < pos.length; j++)
							bounds[j] = parseUnitValue(pos[j], null, j % 2 == 0);

						if (bounds[0] == null && bounds[2] == null || bounds[1] == null && bounds[3] == null)
							throw new IllegalArgumentException("Both x and x2 or y and y2 can not be null!");

						cc.setPos(bounds);
						cc.setBoundsInGrid(false);
						continue;
					}

					ix = startsWithLenient(part, "pad", 3, true);
					if (ix > -1) {
						UnitValue[] p = parseInsets(part.substring(ix).trim(), false);
						cc.setPadding(new UnitValue[] {
								p[0],
								p.length > 1 ? p[1] : null,
								p.length > 2 ? p[2] : null,
								p.length > 3 ? p[3] : null});
						continue;
					}

					ix = startsWithLenient(part, "pushx", 5, true);
					if (ix > -1) {
						cc.setPushX(parseFloat(part.substring(ix).trim(), ResizeConstraint.WEIGHT_100));
						continue;
					}

					ix = startsWithLenient(part, "pushy", 5, true);
					if (ix > -1) {
						cc.setPushY(parseFloat(part.substring(ix).trim(), ResizeConstraint.WEIGHT_100));
						continue;
					}

					ix = startsWithLenient(part, "push", 4, false);
					if (ix > -1) {
						String[] pushs = toTrimmedTokens(part.substring(ix).trim(), ' ');
						cc.setPushX(parseFloat(pushs[0], ResizeConstraint.WEIGHT_100));
						cc.setPushY(parseFloat(pushs.length > 1 ? pushs[1] : "", ResizeConstraint.WEIGHT_100));
						continue;
					}
				}

				if (c == 't') {
					ix = startsWithLenient(part, "tag", 3, true);
					if (ix > -1) {
						cc.setTag(part.substring(ix).trim());
						continue;
					}
				}

				if (c == 'w' || c == 'h') {
					if (part.equals("wrap")) {
						cc.setWrap(true);
						continue;
					}

					if (part.startsWith("wrap ")) {
						String gapSz = part.substring(5).trim();
						cc.setWrapGapSize(parseBoundSize(gapSz, true, true));
						continue;
					}

					boolean isHor = c == 'w';
					if (isHor && (part.startsWith("w ") || part.startsWith("width "))) {
						String uvStr = part.substring(part.charAt(1) == ' ' ? 2 : 6).trim();
						cc.getHorizontal().setSize(parseBoundSize(uvStr, false, true));
						continue;
					}

					if (!isHor && (part.startsWith("h ") || part.startsWith("height "))) {
						String uvStr = part.substring(part.charAt(1) == ' ' ? 2 : 7).trim();
						cc.getVertical().setSize(parseBoundSize(uvStr, false, false));
						continue;
					}

					if (part.startsWith("wmin ") || part.startsWith("wmax ") || part.startsWith("hmin ") || part.startsWith("hmax ")) {
						String uvStr = part.substring(5).trim();
						if (uvStr.length() > 0) {
							UnitValue uv = parseUnitValue(uvStr, null, isHor);
							boolean isMin = part.charAt(3) == 'n';
							DimConstraint dc = isHor ? cc.getHorizontal() : cc.getVertical();
							dc.setSize(new BoundSize(
									isMin ? uv : dc.getSize().getMin(),
									dc.getSize().getPreferred(),
									isMin ? (dc.getSize().getMax()) : uv,
							        uvStr
							));
							continue;
						}
					}

					if (part.equals("west")) {
						cc.setDockSide(1);
//						cc.getVertical().setGrow(ResizeConstraint.WEIGHT_100);
						continue;
					}

					if (part.startsWith("hidemode ")) {
						cc.setHideMode(Integer.parseInt(part.substring(9)));
						continue;
					}
				}

				if (c == 'i' && part.startsWith("id ")) {
					cc.setId(part.substring(3).trim());
					int dIx = cc.getId().indexOf('.');
					if (dIx  == 0 || dIx == cc.getId().length() - 1)
						throw new IllegalArgumentException("Dot must not be first or last!");

					continue;
				}

				if (c == 'e') {
					if (part.equals("east")) {
						cc.setDockSide(3);
//						cc.getVertical().setGrow(ResizeConstraint.WEIGHT_100);
						continue;
					}

					if (part.equals("external")) {
						cc.setExternal(true);
						continue;
					}

					ix = startsWithLenient(part, new String[] {"endgroupx", "endgroupy", "egx", "egy"}, new int[] {-1, -1, -1, -1}, true);
					if (ix > -1) {
						String sg = part.substring(ix).trim();
						char lc = part.charAt(ix - 1);
						DimConstraint dc = (lc == 'x' ? cc.getHorizontal() : cc.getVertical());
						dc.setEndGroup(sg);
						continue;
					}
				}

				if (c == 'd') {
					if (part.equals("dock north")) {
						cc.setDockSide(0);
						continue;
					}
					if (part.equals("dock west")) {
						cc.setDockSide(1);
						continue;
					}
					if (part.equals("dock south")) {
						cc.setDockSide(2);
						continue;
					}
					if (part.equals("dock east")) {
						cc.setDockSide(3);
						continue;
					}

					if (part.equals("dock center")) {
						cc.getHorizontal().setGrow(new Float(100f));
						cc.getVertical().setGrow(new Float(100f));
						cc.setPushX(new Float(100f));
						cc.setPushY(new Float(100f));
						continue;
					}
				}

				UnitValue horAlign = parseAlignKeywords(part, true);
				if (horAlign != null) {
					cc.getHorizontal().setAlign(horAlign);
					continue;
				}

				UnitValue verAlign = parseAlignKeywords(part, false);
				if (verAlign != null) {
					cc.getVertical().setAlign(verAlign);
					continue;
				}

				throw new IllegalArgumentException("Unknown keyword.");

			} catch (Exception ex) {
				throw new IllegalArgumentException("Illegal Constraint: '" + part + "'\n" + ex.getMessage());
			}
		}

//		cc = (CC) serializeTest(cc);

		return cc;
	}

  /** Parses insets which consists of 1-4 <code>UnitValue</code>s.
   * @param s The string to parse. E.g. "10 10 10 10" or "20". If less than 4 groups the last will be used for the missing.
   * @param acceptPanel If "panel" and "dialog" should be accepted. They are used to access platform defaults.
   * @return An array of length 4 with the parsed insets.
   * @throws ArgumentError if the parsing could not be done.
   */
  public static function parseInsets(s:String, acceptPanel:Boolean):Vector.<UnitValue> {
    var ins:Vector.<UnitValue>;
    var j:int;
    if (s.length == 0 || s == "dialog" || s == "panel") {
      if (!acceptPanel) {
        throw new ArgumentError("Insets now allowed: " + s + "\n");
      }

      var isPanel:Boolean = s.charCodeAt(0) == 112; // p
      ins = new Vector.<UnitValue>(4, true);
      for (j = 0; j < 4; j++) {
        ins[j] = isPanel ? PlatformDefaults.getPanelInsets(j) : PlatformDefaults.getDialogInsets(j);
      }

      return ins;
    }
    else {
      var insS:Vector.<String> = toTrimmedTokens(s, 32);
      ins = new Vector.<UnitValue>(4, true);
      for (j = 0; j < 4; j++) {
        var insSz:UnitValue = parseUnitValue(insS[j < insS.length ? j : insS.length - 1], UnitValue.ZERO, j % 2 == 1);
        ins[j] = insSz != null ? insSz : PlatformDefaults.getPanelInsets(j);
      }
      return ins;
    }
  }

	/** Parses gaps.
	 * @param s The string that contains gap information. Should start with "gap".
	 * @return The gaps as specified in <code>s</code>. Indexed: <code>[top,left,bottom,right][min,pref,max]</code> or
	 * [before,after][min,pref,max] if <code>oneDim</code> is true.
	 */
  private static function parseGaps(s:String):Vector.<BoundSize> {
    var ret:Vector.<BoundSize> = new Vector.<BoundSize>(4, true);

    var ix:int = startsWithLenient2(s, "gaptop", -1, true);
    if (ix > -1) {
      s = Strings.trim2(s, ix, s.length);
      ret[0] = parseBoundSize(s, true, false);
      return ret;
    }

		ix = startsWithLenient2(s, "gapleft", -1, true);
		if (ix > -1) {
			s = Strings.trim2(s, ix, s.length);
			ret[1] = parseBoundSize(s, true, true);
			return ret;
		}

		ix = startsWithLenient2(s, "gapbottom", -1, true);
		if (ix > -1) {
			s = Strings.trim2(s, ix, s.length);
			ret[2] = parseBoundSize(s, true, false);
			return ret;
		}

		ix = startsWithLenient2(s, "gapright", -1, true);
		if (ix > -1) {
			s = Strings.trim2(s, ix, s.length);
			ret[3] = parseBoundSize(s, true, true);
			return ret;
		}

		ix = startsWithLenient2(s, "gapbefore", -1, true);
		if (ix > -1) {
			s = Strings.trim2(s, ix, s.length);
			ret[1] = parseBoundSize(s, true, true);
			return ret;
		}

		ix = startsWithLenient2(s, "gapafter", -1, true);
		if (ix > -1) {
			s = Strings.trim2(s, ix, s.length);
			ret[3] = parseBoundSize(s, true, true);
			return ret;
		}

    var gaps:Vector.<String>;
		ix = startsWithLenient(s, new <String>["gapx", "gapy"], null, true);
		if (ix > -1) {
			var x:Boolean = s.charCodeAt(3) == 120; // x
			gaps = toTrimmedTokens(Strings.trim2(s, ix, s.length), 32);
			ret[x ? 1 : 0] = parseBoundSize(gaps[0], true, x);
      if (gaps.length > 1) {
        ret[x ? 3 : 2] = parseBoundSize(gaps[1], true, !x);
      }
      return ret;
		}

    ix = startsWithLenient2(s, "gap ", 1, true);
    if (ix > -1) {
      gaps = toTrimmedTokens(Strings.trim2(s, ix, s.length), 32);

      ret[1] = parseBoundSize(gaps[0], true, true);   // left
      if (gaps.length > 1) {
        ret[3] = parseBoundSize(gaps[1], true, false);   // right
        if (gaps.length > 2) {
          ret[0] = parseBoundSize(gaps[2], true, true);   // top
          if (gaps.length > 3) {
            ret[2] = parseBoundSize(gaps[3], true, false);
          }   // bottom
        }
      }
      return ret;
		}

		throw new ArgumentError("Unknown Gap part: '" + s + "'");
	}

  private static function parseSpan(s:String):int {
    return s.length > 0 ? parseInt(s) : LayoutUtil.INF;
  }

  private static function parseFloat2(s:String, nullVal:Number):Number {
    return s.length > 0 ? parseFloat(s) : nullVal;
  }

	/** Parses a singele "min:pref:max" value. May look something like <code>"10px:20lp:30%"</code> or <code>"pref!"</code>.
	 * @param s The string to parse. Not <code>null</code>.
	 * @param isGap If this bound size is a gap (different empty string handling).
	 * @param isHor If the size is for the horizontal dimension.
	 * @return A bound size that may be <code>null</code> if the string was "null", "n" or <code>null</code>.
	 */
  public static function parseBoundSize(s:String, isGap:Boolean, isHor:Boolean):BoundSize {
    if (s.length == 0 || s == "null" || s == "n") {
      return null;
    }

    var cs:String = s;
    var push:Boolean = false;
    if (Strings.endsWith(s, "push")) {
			push = true;
			var l:int = s.length;
      s = s.substring(0, l - (Strings.endsWith(s, ":push") ? 5 : 4));
      if (s.length == 0) {
        return BoundSize.create3(null, null, null, true, cs);
      }
    }

    var sizes:Vector.<String> = toTrimmedTokens(s, 58 /*':'*/);
    var s0:String = sizes[0];
    if (sizes.length == 1) {
      var hasEM:Boolean = s0.charCodeAt(s0.length - 1) == 33; // !
      if (hasEM) {
        s0 = s0.substring(0, s0.length - 1);
      }
      var uv:UnitValue = parseUnitValue(s0, null, isHor);
      return BoundSize.create3(isGap || hasEM ? uv : null, uv, (hasEM ? uv : null), push, cs);

    } 
    else if (sizes.length == 2) {
      return BoundSize.create3(parseUnitValue(s0, null, isHor), parseUnitValue(sizes[1], null, isHor), null, push, cs);
    } 
    else if (sizes.length == 3) {
      return BoundSize.create3(parseUnitValue(s0, null, isHor), parseUnitValue(sizes[1], null, isHor),
                               parseUnitValue(sizes[2], null, isHor), push, cs);
    }
    else {
      throw new ArgumentError("Min:Preferred:Max size section must contain 0, 1 or 2 colons. '" + cs + "'");
    }
  }

	/** Parses a single unit value that may also be an alignment as parsed by {@link #parseAlignKeywords(String, boolean)}.
	 * @param s The string to parse. Not <code>null</code>. May look something like <code>"10px"</code> or <code>"5dlu"</code>.
	 * @param isHor If the value is for the horizontal dimension.
	 * @param emptyReplacement A replacement if <code>s</code> is empty. May be <code>null</code>.
	 * @return The parsed unit value. May be <code>null</code>.
	 */
  public static function parseUnitValueOrAlign(s:String, isHor:Boolean, emptyReplacement:UnitValue):UnitValue {
    if (s.length == 0) {
      return emptyReplacement;
    }

    var align:UnitValue = parseAlignKeywords(s, isHor);
    if (align != null) {
      return align;
    }

    return parseUnitValue(s, emptyReplacement, isHor);
  }

	/** Parses a single unit value. E.g. "10px" or "5in"
	 * @param s The string to parse. Not <code>null</code>. May look something like <code>"10px"</code> or <code>"5dlu"</code>.
	 * @param isHor If the value is for the horizontal dimension.
	 * @return The parsed unit value. <code>null</code> is empty string,
	 */
  public static function parseUnitValue2(s:String, isHor:Boolean):UnitValue {
    return parseUnitValue(s, null, isHor);
  }

	/** Parses a single unit value.
	 * @param s The string to parse. May be <code>null</code>. May look something like <code>"10px"</code> or <code>"5dlu"</code>.
	 * @param emptyReplacement A replacement <code>s</code> is empty or <code>null</code>. May be <code>null</code>.
	 * @param isHor If the value is for the horizontal dimension.
	 * @return The parsed unit value. May be <code>null</code>.
	 */
  internal static function parseUnitValue(s:String, emptyReplacement:UnitValue, isHor:Boolean):UnitValue {
    if (s == null || s.length == 0) {
      return emptyReplacement;
    }

    var cs:String = s; // Save creation string.
    var c0:int = s.charCodeAt(0);

    // Remove start and end parentheses, if there.
    if (c0 == 40 && s.charCodeAt(s.length - 1) == 41) {
      s = s.substring(1, s.length - 1);
    }

    if (c0 == 110 && (s == "null" || s == "n")) {
      return null;
    }

    if (c0 == 105 && s == "inf") {
      return UnitValue.INF;
    }

    var oper:int = getOper(s);
    var inline:Boolean = oper == UnitValue.ADD || oper == UnitValue.SUB || oper == UnitValue.MUL || oper == UnitValue.DIV;

    if (oper != UnitValue.STATIC) {  // It is a multi-value

      var uvs:Vector.<String>;
      if (!inline) {   // If the format is of type "opr(xxx,yyy)" (compared to in-line "10%+15px")
        var sub:String = Strings.trim2(s, 4, s.length - 1);
        uvs = toTrimmedTokens(sub, 44 /*','*/);
        if (uvs.length == 1) {
          return parseUnitValue(sub, null, isHor);
        }
      }
      else {
        var delim:int;
        if (oper == UnitValue.ADD) {
          delim = 43; // +
        }
        else if (oper == UnitValue.SUB) {
          delim = 45; // -
        }
        else if (oper == UnitValue.MUL) {
          delim = 42; // *
        }
        else {
          // div left
          delim = 47; // /
        }
				uvs = toTrimmedTokens(s, delim);
        if (uvs.length > 2) {   // More than one +-*/.
          var last:String = uvs[uvs.length - 1];
          var first:String = s.substring(0, s.length - last.length - 1);
          uvs = new <String>[first, last];
        }
			}

      if (uvs.length != 2) {
        throw new ArgumentError("Malformed UnitValue: '" + s + "'");
      }

			var sub1:UnitValue = parseUnitValue(uvs[0], null, isHor);
			var sub2:UnitValue = parseUnitValue(uvs[1], null, isHor);

      if (sub1 == null || sub2 == null) {
        throw new ArgumentError("Malformed UnitValue. Must be two sub-values: '" + s + "'");
      }

      return UnitValue.create3(isHor, oper, sub1, sub2, cs);
    }
    else {
      try {
        var numParts:Vector.<String> = getNumTextParts(s);
        var value:Number = numParts[0].length > 0 ? parseFloat(numParts[0]) : 1;     // e.g. "related" has no number part..

        return UnitValue.create4(value, numParts[1], isHor, oper, cs);
      }
      catch (e:Error) {
        throw new ArgumentError("Malformed UnitValue: '" + s + "'");
      }
		}

    throw new ArgumentError("Burn in Hell, Adobe");
	}

	/** Parses alignment keywords and returns the approprieate <code>UnitValue</code>.
	 * @param s The string to parse. Not <code>null</code>.
	 * @param isHor If alignments for horizontal is checked. <code>false</code> means vertical.
	 * @return The unit value or <code>null</code> if not recognized (no exception).
	 */
  internal static function parseAlignKeywords(s:String, isHor:Boolean):UnitValue {
    if (startsWithLenient2(s, "center", 1, false) != -1) {
      return UnitValue.CENTER;
    }

    if (isHor) {
      if (startsWithLenient2(s, "left", 1, false) != -1) {
        return UnitValue.LEFT;
      }

      if (startsWithLenient2(s, "right", 1, false) != -1) {
        return UnitValue.RIGHT;
      }

      if (startsWithLenient2(s, "leading", 4, false) != -1) {
        return UnitValue.LEADING;
      }

      if (startsWithLenient2(s, "trailing", 5, false) != -1) {
        return UnitValue.TRAILING;
      }

      if (startsWithLenient2(s, "label", 5, false) != -1) {
        return UnitValue.LABEL;
      }
    }
    else {
      if (startsWithLenient2(s, "baseline", 4, false) != -1) {
        return UnitValue.BASELINE_IDENTITY;
      }

      if (startsWithLenient2(s, "top", 1, false) != -1) {
        return UnitValue.TOP;
      }

      if (startsWithLenient2(s, "bottom", 1, false) != -1) {
        return UnitValue.BOTTOM;
      }
    }

    return null;
  }

  /**
   * Splits a text-number combination such as "hello 10.0" into <code>{"hello", "10.0"}</code>.
   * @param s The string to split. Not <code>null</code>. Needs be be resonably formatted since the method
   * only finds the first 0-9 or . and cuts the string in half there.
   * @return Always length 2 and no <code>null</code> elements. Elements are "" if no part found.
   */
  private static function getNumTextParts(s:String):Vector.<String> {
    for (var i:int = 0, iSz:int = s.length; i < iSz; i++) {
      var c:int = s.charCodeAt(i);
      if (c == 32) {
        throw new ArgumentError("Space in UnitValue: '" + s + "'");
      }

      if ((c < 48/*'0'*/ || c > 57 /*'9'*/) && c != 46/*'.'*/ && c != 45/*'-'*/) {
        return new <String>[Strings.trim2(s, 0, i), Strings.trim2(s, i, s.length)];
      }
    }

    return new <String>[s, ""];
  }

	/**
   * Returns the operation depending on the start character.
	 * @param s The string to check. Not <code>null</code>.
	 * @return E.g. UnitValue.ADD, UnitValue.SUB or UnitValue.STATIC. Returns negative value for in-line operations.
	 */
  private static function getOper(s:String):int {
    const len:int = s.length;
    if (len < 3) {
      return UnitValue.STATIC;
    }

    if (len > 5 && s.charCodeAt(3) == 40 && s.charCodeAt(len - 1) == 41) {
      if (Strings.startsWith(s, "min(")) {
        return UnitValue.MIN;
      }

      if (Strings.startsWith(s, "max(")) {
        return UnitValue.MAX;
      }

      if (Strings.startsWith(s, "mid(")) {
        return UnitValue.MID;
      }
    }

    // Try in-line add/sub. E.g. "pref+10px".
    for (var j:int = 0; j < 2; j++) {   // First +-   then */   (precedence)
      for (var i:int = len - 1, p:int = 0; i > 0; i--) {
        var c:int = s.charCodeAt(i);
        if (c == 41) {
          p++;
        }
        else if (c == 40) {
          p--;
        }
        else if (p == 0) {
          if (j == 0) {
            switch (c) {
              case 43/*'+'*/: return UnitValue.ADD;
              case 45/*'-'*/: return UnitValue.SUB;
            }
          }
          else {
            switch (c) {
              case 42/*'*'*/: return UnitValue.MUL;
              case 47/*'/'*/: return UnitValue.DIV;
            }
          }
        }
      }
    }

    return UnitValue.STATIC;
  }

	/** Returns if a string shares at least a specified numbers starting characters with a number of matches.
	 * <p>
	 * This method just excercises {@link #startsWithLenient(String, String, int, boolean)} with every one of
	 * <code>matches</code> and <code>minChars</code>.
	 * @param s The string to check. Not <code>null</code>.
	 * @param matches A number of possible starts for <code>s</code>.
	 * @param minChars The mimimum number of characters to match for every element in <code>matches</code>. Needs
	 * to be of same length as <code>matches</code>. Can be <code>null</code>.
	 * @param acceptTrailing If after the required number of charecters are matched onrecognized characters that are not
	 * in one of the the <code>matches</code> string should be accepted. For instance if "abczz" should be matched with
	 * "abcdef" and min chars 3.
	 * @return The index of the first unmatched character if <code>minChars</code> was reached or <code>-1</code> if a match was not
	 * found.
	 */
  private static function startsWithLenient(s:String, matches:Vector.<String>, minChars:Vector.<int>, acceptTrailing:Boolean):int {
    for (var i:int = 0, n:int = matches.length; i < n; i++) {
      var minChar:int = minChars != null ? minChars[i] : -1;
      var ix:int = startsWithLenient2(s, matches[i], minChar, acceptTrailing);
      if (ix > -1) {
        return ix;
      }
    }
    return -1;
  }

	/**
   * Returns if a string shares at least a specified numbers starting characters with a match.
	 * @param s The string to check. Not <code>null</code> and must be trimmed.
	 * @param match The possible start for <code>s</code>. Not <code>null</code> and must be trimmed.
	 * @param minChars The mimimum number of characters to match to <code>s</code> for it this to be considered a match. -1 means
	 * the full length of <code>match</code>.
	 * @param acceptTrailing If after the required number of charecters are matched unrecognized characters that are not
	 * in one of the the <code>matches</code> string should be accepted. For instance if "abczz" should be matched with
	 * "abcdef" and min chars 3.
	 * @return The index of the first unmatched character if <code>minChars</code> was reached or <code>-1</code> if a match was not
	 * found.
	 */
  private static function startsWithLenient2(s:String, match:String, minChars:int, acceptTrailing:Boolean):int {
    // Fast sanity check
    if (s.charAt(0) != match.charAt(0)) {
      return -1;
    }

    if (minChars == -1) {
      minChars = match.length;
    }

    var sSz:int = s.length;
    if (sSz < minChars) {
      return -1;
    }

    var mSz:int = match.length;
    var sIx:int = 0;
    for (var mIx:int = 0; mIx < mSz; sIx++,mIx++) {
      // Disregard spaces and _
      while (sIx < sSz && (s.charCodeAt(sIx) == 32 || s.charCodeAt(sIx) == 95/*'_'*/)) {
        sIx++;
      }

      if (sIx >= sSz || s.charAt(sIx) != match.charAt(mIx)) {
        return mIx >= minChars && (acceptTrailing || sIx >= sSz) && (sIx >= sSz || s.charCodeAt(sIx - 1) == 32) ? sIx : -1;
      }
    }

    return sIx >= sSz || acceptTrailing || (s.charCodeAt(sIx) == 32 ? sIx : -1);
  }

	/** Parses a string and returns it in those parts of the string that are separated with a <code>sep</code> character.
	 * <p>
	 * separator characters within parentheses will not be counted or handled in any way, whatever the depth.
	 * <p>
	 * A space separator will be a hit to one or more spaces and thus not return empty strings.
	 * @param s The string to parse. If it starts and/or ends with a <code>sep</code> the first and/or last element returned will be "". If
	 * two <code>sep</code> are next to each other and empty element will be "between" the periods. The <code>sep</code> themselves will never be returned.
	 * @param sep The separator char.
	 * @return Those parts of the string that are separated with <code>sep</code>. Never null and at least of size 1
	 * @since 6.7.2 Changed so more than one space in a row works as one space.
	 */
  private static function toTrimmedTokens(s:String, sep:int):Vector.<String> {
    var toks:int = 0;
    const sSize:int = s.length;
    const disregardDoubles:Boolean = sep == 32;

    var i:int; // fucked actionscript
    var c:int;

    // Count the sep:s
    var p:int = 0;
    for (i = 0; i < sSize; i++) {
      c = s.charCodeAt(i);
      if (c == 40/*'('*/) {
        p++;
      }
      else if (c == 41/*')'*/) {
        p--;
      }
      else if (p == 0 && c == sep) {
        toks++;
        while (disregardDoubles && i < sSize - 1 && s.charCodeAt(i + 1) == 32/*' '*/) {
          i++;
        }
      }
      if (p < 0) {
        throw new ArgumentError("Unbalanced parentheses: '" + s + "'");
      }
    }

    if (p != 0) {
      throw new ArgumentError("Unbalanced parentheses: '" + s + "'");
    }

    if (toks == 0) {
      return new <String>[Strings.trim(s)];
    }

    var retArr:Vector.<String> = new Vector.<String>(toks + 1, true);
    var st:int = 0;
    var pNr:int = 0;
    p = 0;
    for (i = 0; i < sSize; i++) {
      c = s.charCodeAt(i);
      if (c == 40/*'('*/) {
        p++;
      }
      else if (c == 41/*')'(*/) {
        p--;
      }
      else if (p == 0 && c == sep) {
        retArr[pNr++] = Strings.trim2(s, st, i);
        st = i + 1;
        while (disregardDoubles && i < sSize - 1 && s.charCodeAt(i + 1) == 32) {
          i++;
        }
      }
    }

    retArr[pNr] = Strings.trim2(s, st, sSize);
    return retArr;
  }

  /**
   * Parses "AAA[BBB]CCC[DDD]EEE" into {"AAA", "BBB", "CCC", "DDD", "EEE", "FFF"}. Handles empty parts. Will always start and end outside
	 * a [] block so that the number of returned elemets will always be uneven and at least of length 3.
	 * <p>
	 * "|" is interrated as "][".
	 * @param s The string. Might be "" but not null. Should be trimmed.
	 * @return The string divided into elements. Never <code>null</code> and at least of length 3.
	 * @throws ArgumentError If a [] mismatch of some kind. (If not same [ as ] count or if the interleave.)
   */
  private static function getRowColAndGapsTrimmed(s:String):Vector.<String> {
    if (s.indexOf('|') != -1) {
      s = s.replace(/|/g, "][");
    }

    var retList:Vector.<String> = new Vector.<String>(Math.max(s.length >> 2 + 1, 3), false); // Aprox return length.
    var retListIndex:int = 0;
    var s0:int = 0, s1:int = 0; // '[' and ']' count.
    var st:int = 0; // Start of "next token to add".
    for (var i:int = 0, iSz:int = s.length; i < iSz; i++) {
      var c:int = s.charCodeAt(i);
      if (c == 91/*'['*/) {
        s0++;
      }
      else if (c == 93/*']'*/) {
        s1++;
      }
      else {
        continue;
      }

      if (s0 != s1 && (s0 - 1) != s1) {
        break;  // Wrong [ or ] found. Break for throw.
      }

      retList[retListIndex++] = Strings.trim2(s, st, i);
      st = i + 1;
    }
    if (s0 != s1) {
      throw new ArgumentError("'[' and ']' mismatch in row/column format string: " + s);
    }

    if (s0 == 0) {
      retList[retListIndex++] = "";
      retList[retListIndex++] = s;
      retList[retListIndex++] = "";
    }
    else if (retListIndex /* as actual length of retList */ % 2 == 0) {
      retList[retListIndex] = s.substring(st, s.length);
    }

    retList.length = retListIndex;
    retList.fixed = true;
    return retList;
  }

  /** Makes <code>null</code> "", trimms and converts to lower case.
   * @param s The string
   * @return Not null.
   */
  public static function prepare(s:String):String {
    return s != null ? Strings.trim(s).toLowerCase() : "";
  }
}
}