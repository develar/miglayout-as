package net.miginfocom.layout {
/** A constraint that holds the column <b>or</b> row constraints for the grid. It also holds the gaps between the rows and columns.
 * <p>
 * This class is a holder and builder for a number of {@link net.miginfocom.layout.DimConstraint}s.
 * <p>
 * For a more thorough explanation of what these constraints do, and how to build the constraints, see the White Paper or Cheat Sheet at www.migcomponents.com.
 * <p>
 * Note that there are two way to build this constraint. Through String (e.g. <code>"[100]3[200,fill]"</code> or through API (E.g.
 * <code>new AxisConstraint().size("100").gap("3").size("200").fill()</code>.
 */
public final class AC {
  private var cList:Vector.<DimConstraint> = new Vector.<DimConstraint>(8, true);

  private var curIx:int;

  /** Constructor. Creates an instance that can be configured manually. Will be initialized with a default
   * {@link net.miginfocom.layout.DimConstraint}.
   */
  public function AC() {
    cList[0] = new DimConstraint();
  }

	/** Property. The different {@link net.miginfocom.layout.DimConstraint}s that this object consists of.
	 * These <code><DimConstraints/code> contains all information in this class.
	 * <p>
	 * Yes, we are embarrassingly aware that the method is misspelled.
	 * @return The different {@link net.miginfocom.layout.DimConstraint}s that this object consists of. A new list and
	 * never <code>null</code>.
   */
  public function getConstaints():Vector.<DimConstraint> {
    return cList.slice();
  }

	/** Sets the different {@link net.miginfocom.layout.DimConstraint}s that this object should consists of.
	 * <p>
	 * Yes, we are embarrassingly aware that the method is misspelled.
	 * @param value The different {@link net.miginfocom.layout.DimConstraint}s that this object consists of. The list
	 * will be copied for storage. <code>null</code> or and emty array will reset the constraints to one <code>DimConstraint</code>
	 * with default values.
	 */
	public function setConstaints(value:Vector.<DimConstraint>):void {
    cList.fixed = false;
    if (value == null || value.length < 1) {
      cList.length = 1;
      cList[0] = new DimConstraint();
    }
    else {
      var n:int = value.length;
      cList.length = n;
      while (n-- > 0) {
        cList[n] = value[n];
      }
    }
    cList.fixed = true;
	}

	/** Returns the number of rows/columns that this constraints currently have.
	 * @return The number of rows/columns that this constraints currently have. At least 1.
	 */
	public function getCount():int {
		return cList.length
	}

	

	/** Specifies that the indicated rows/columns should not be grid-like. The while row/colum will have its components layed out
	 * in one single cell. It is the same as to say that the cells in this column/row will all be merged (a.k.a spanned).
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param indexes The index(es) (0-based) of the columns/rows that should be affected by this constraint.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function noGrid( ... indexes):AC {
		for (var i:int= indexes.length - 1; i >= 0; i--) {
			var ix:int= indexes[i];
			makeSize(ix);
			cList.get(ix).setNoGrid(true);
		}
		return this;
	}

	/** Sets the current row/column to <code>i</code>. If the current number of rows/columns is less than <code>i</code> a call
	 * to {@link #count(int)} will set the size accordingly.
	 * <p>
	 * The next call to any of the constraint methods (e.g. {@link net.miginfocom.layout.AC#noGrid}) will be carried
	 * out on this new row/column.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param i The new current row/column.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function index(i:int):AC {
		makeSize(i);
		curIx = i;
		return this;
	}

	/** Specifies that the current row/column's component should grow by default. It does not affect the size of the row/column.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function fill():AC {
		return fill(curIx);
	}

	/** Specifies that the indicated rows'/columns' component should grow by default. It does not affect the size of the row/column.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param indexes The index(es) (0-based) of the columns/rows that should be affected by this constraint.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function fill( ... indexes):AC {
		for (var i:int= indexes.length - 1; i >= 0; i--) {
			var ix:int= indexes[i];
			makeSize(ix);
			cList.get(ix).setFill(true);
		}
		return this;
	}

//	/** Specifies that the current row/column should be put in the end group <code>s</code> and will thus share the same ending
//	 * coordinate within the group.
//	 * <p>
//	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
//	 * @param s A name to associate on the group that should be the same for other rows/columns in the same group.
//	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
//	 */
//	public final AxisConstraint endGroup(String s)
//	{
//		return endGroup(s, curIx);
//	}
//
//	/** Specifies that the indicated rows/columns should be put in the end group <code>s</code> and will thus share the same ending
//	 * coordinate within the group.
//	 * <p>
//	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
//	 * @param s A name to associate on the group that should be the same for other rows/columns in the same group.
//	 * @param indexes The index(es) (0-based) of the columns/rows that should be affected by this constraint.
//	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
//	 */
//	public final AxisConstraint endGroup(String s, int... indexes)
//	{
//		for (int i = indexes.length - 1; i >= 0; i--) {
//			int ix = indexes[i];
//			makeSize(ix);
//			cList.get(ix).setEndGroup(s);
//		}
//		return this;
//	}

	/** Specifies that the current row/column should be put in the size group <code>s</code> and will thus share the same size
	 * constraints as the other components in the group.
	 * <p>
	 * Same as <code>sizeGroup("")</code>
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 * @since 3.7.2
	 */
	public function sizeGroup():AC {
		return sizeGroup("", curIx);
	}

	/** Specifies that the current row/column should be put in the size group <code>s</code> and will thus share the same size
	 * constraints as the other components in the group.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param s A name to associate on the group that should be the same for other rows/columns in the same group.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function sizeGroup(s:String):AC {
		return sizeGroup(s, curIx);
	}

	/** Specifies that the indicated rows/columns should be put in the size group <code>s</code> and will thus share the same size
	 * constraints as the other components in the group.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param s A name to associate on the group that should be the same for other rows/columns in the same group.
	 * @param indexes The index(es) (0-based) of the columns/rows that should be affected by this constraint.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function sizeGroup(s:String, ... indexes):AC {
		for (var i:int= indexes.length - 1; i >= 0; i--) {
			var ix:int= indexes[i];
			makeSize(ix);
			cList.get(ix).setSizeGroup(s);
		}
		return this;
	}

	/** Specifies the current row/column's min and/or preferred and/or max size. E.g. <code>"10px"</code> or <code>"50:100:200"</code>.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param s The minimum and/or preferred and/or maximum size of this row. The string will be interpreted
	 * as a <b>BoundSize</b>. For more info on how <b>BoundSize</b> is formatted see the documentation.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function size(s:String):AC {
		return size(s, curIx);
	}

	/** Specifies the indicated rows'/columns' min and/or preferred and/or max size. E.g. <code>"10px"</code> or <code>"50:100:200"</code>.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param size The minimum and/or preferred and/or maximum size of this row. The string will be interpreted
	 * as a <b>BoundSize</b>. For more info on how <b>BoundSize</b> is formatted see the documentation.
	 * @param indexes The index(es) (0-based) of the columns/rows that should be affected by this constraint.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function size(size:String, ... indexes):AC {
		var bs:BoundSize= ConstraintParser.parseBoundSize(size, false, true);
		for (var i:int= indexes.length - 1; i >= 0; i--) {
			var ix:int= indexes[i];
			makeSize(ix);
			cList.get(ix).setSize(bs);
		}
		return this;
	}

	/** Specifies the gap size to be the default one <b>AND</b> moves to the next column/row. The method is called <code>.gap()</code>
	 * rather the more natural <code>.next()</code> to indicate that it is very much related to the other <code>.gap(..)</code> methods.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function gap():AC {
		curIx++;
		return this;
	}

	/** Specifies the gap size to <code>size</code> <b>AND</b> moves to the next column/row.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param size minimum and/or preferred and/or maximum size of the gap between this and the next row/column.
	 * The string will be interpreted as a <b>BoundSize</b>. For more info on how <b>BoundSize</b> is formatted see the documentation.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function gap(size:String):AC {
		return gap(size, curIx++);
	}

	/** Specifies the indicated rows'/columns' gap size to <code>size</code>.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param size minimum and/or preferred and/or maximum size of the gap between this and the next row/column.
	 * The string will be interpreted as a <b>BoundSize</b>. For more info on how <b>BoundSize</b> is formatted see the documentation.
	 * @param indexes The index(es) (0-based) of the columns/rows that should be affected by this constraint.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function gap(size:String, ... indexes):AC {
		var bsa:BoundSize= size != null ? ConstraintParser.parseBoundSize(size, true, true) : null;

		for (var i:int= indexes.length - 1; i >= 0; i--) {
			var ix:int= indexes[i];
			makeSize(ix);
			if (bsa != null)
				cList.get(ix).setGapAfter(bsa);
		}
		return this;
	}

	/** Specifies the current row/column's columns default alignment <b>for its components</b>. It does not affect the positioning
	 * or size of the columns/row itself. For columns it is the horizonal alignment (e.g. "left") and for rows it is the vertical
	 * alignment (e.g. "top").
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param side The default side to align the components. E.g. "top" or "left", or "leading" or "trailing" or "bottom" or "right".
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function align(side:String):AC {
		return align(side, curIx);
	}

	/** Specifies the indicated rows'/columns' columns default alignment <b>for its components</b>. It does not affect the positioning
	 * or size of the columns/row itself. For columns it is the horizonal alignment (e.g. "left") and for rows it is the vertical
	 * alignment (e.g. "top").
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param side The default side to align the components. E.g. "top" or "left", or "before" or "after" or "bottom" or "right".
	 * @param indexes The index(es) (0-based) of the columns/rows that should be affected by this constraint.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function align(side:String, ... indexes):AC {
		var al:UnitValue= ConstraintParser.parseAlignKeywords(side, true);
		if (al == null)
			al = ConstraintParser.parseAlignKeywords(side, false);

		for (var i:int= indexes.length - 1; i >= 0; i--) {
			var ix:int= indexes[i];
			makeSize(ix);
			cList.get(ix).setAlign(al);
		}
		return this;
	}

	/** Specifies the current row/column's grow priority.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param p The new grow priority.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function growPrio(p:int):AC {
		return growPrio(p, curIx);
	}

	/** Specifies the indicated rows'/columns' grow priority.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param p The new grow priority.
	 * @param indexes The index(es) (0-based) of the columns/rows that should be affected by this constraint.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function growPrio(p:int, ... indexes):AC {
		for (var i:int= indexes.length - 1; i >= 0; i--) {
			var ix:int= indexes[i];
			makeSize(ix);
			cList.get(ix).setGrowPriority(p);
		}
		return this;
	}

	/** Specifies the current row/column's grow weight within columns/rows with the <code>grow priority</code> 100f.
	 * <p>
	 * Same as <code>grow(100f)</code>
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 * @since 3.7.2
	 */
	public function grow():AC {
		return grow(1, curIx);
	}

	/** Specifies the current row/column's grow weight within columns/rows with the same <code>grow priority</code>.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param w The new grow weight.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function grow(w:Number):AC {
		return grow(w, curIx);
	}

	/** Specifies the indicated rows'/columns' grow weight within columns/rows with the same <code>grow priority</code>.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param w The new grow weight.
	 * @param indexes The index(es) (0-based) of the columns/rows that should be affected by this constraint.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function grow(w:Number, ... indexes):AC {
		var gw:Float= new Float(w);
		for (var i:int= indexes.length - 1; i >= 0; i--) {
			var ix:int= indexes[i];
			makeSize(ix);
			cList.get(ix).setGrow(gw);
		}
		return this;
	}

	/** Specifies the current row/column's shrink priority.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param p The new shrink priority.
	 	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function shrinkPrio(p:int):AC {
		return shrinkPrio(p, curIx);
	}

	/** Specifies the indicated rows'/columns' shrink priority.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
	 * @param p The new shrink priority.
	 * @param indexes The index(es) (0-based) of the columns/rows that should be affected by this constraint.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 */
	public function shrinkPrio(p:int, ... indexes):AC {
		for (var i:int= indexes.length - 1; i >= 0; i--) {
			var ix:int= indexes[i];
			makeSize(ix);
			cList.get(ix).setShrinkPriority(p);
		}
		return this;
	}

	/** Specifies that the current row/column's shrink weight withing the columns/rows with the <code>shrink priority</code> 100f.
	 * <p>
	 * Same as <code>shrink(100f)</code>.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the White Paper or Cheat Sheet at www.migcomponents.com.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 * @since 3.7.2
	 */
	public function shrink():AC {
		return shrink(100, curIx);
	}

	/** Specifies that the current row/column's shrink weight withing the columns/rows with the same <code>shrink priority</code>.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the White Paper or Cheat Sheet at www.migcomponents.com.
	 * @param w The shrink weight.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 * @since 3.7.2
	 */
	public function shrink(w:Number):AC {
		return shrink(w, curIx);
	}

	/** Specifies the indicated rows'/columns' shrink weight withing the columns/rows with the same <code>shrink priority</code>.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the White Paper or Cheat Sheet at www.migcomponents.com.
	 * @param w The shrink weight.
	 * @param indexes The index(es) (0-based) of the columns/rows that should be affected by this constraint.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 * @since 3.7.2
	 */
	public function shrink(w:Number, ... indexes):AC {
		var sw:Float= new Float(w);
		for (var i:int= indexes.length - 1; i >= 0; i--) {
			var ix:int= indexes[i];
			makeSize(ix);
			cList.get(ix).setShrink(sw);
		}
		return this;
	}

	/** Specifies that the current row/column's shrink weight withing the columns/rows with the same <code>shrink priority</code>.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the White Paper or Cheat Sheet at www.migcomponents.com.
	 * @param w The shrink weight.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 * @deprecated in 3.7.2. Use {@link #shrink(float)} instead.
	 */
	public function shrinkWeight(w:Number):AC {
		return shrink(w);
	}

	/** Specifies the indicated rows'/columns' shrink weight withing the columns/rows with the same <code>shrink priority</code>.
	 * <p>
	 * For a more thorough explanation of what this constraint does see the White Paper or Cheat Sheet at www.migcomponents.com.
	 * @param w The shrink weight.
	 * @param indexes The index(es) (0-based) of the columns/rows that should be affected by this constraint.
	 * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
	 * @deprecated in 3.7.2. Use {@link #shrink(float, int...)} instead.
	 */
	public function shrinkWeight(w:Number, ... indexes):AC {
		return shrink(w, indexes);
	}

	internal function makeSize(sz:int):void {
		if (cList.length <= sz) {
			cList.ensureCapacity(sz);
			for (var i:int= cList.size(); i <= sz; i++)
				cList.add(new DimConstraint());
		}
	}
}
}