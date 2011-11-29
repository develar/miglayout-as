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
  internal var constraints:Vector.<DimConstraint>;

  public function AC(constraints:Vector.<DimConstraint>) {
    this.constraints = constraints;
  }

	/** Property. The different {@link net.miginfocom.layout.DimConstraint}s that this object consists of.
	 * These <code><DimConstraints/code> contains all information in this class.
	 * <p>
	 * Yes, we are embarrassingly aware that the method is misspelled.
	 * @return The different {@link net.miginfocom.layout.DimConstraint}s that this object consists of. A new list and
	 * never <code>null</code>.
   */
  //public function getConstaints():Vector.<DimConstraint> {
  //  return constraints.slice();
  //}

	/** Sets the different {@link net.miginfocom.layout.DimConstraint}s that this object should consists of.
	 * <p>
	 * Yes, we are embarrassingly aware that the method is misspelled.
	 * @param value The different {@link net.miginfocom.layout.DimConstraint}s that this object consists of. The list
	 * will be copied for storage. <code>null</code> or and emty array will reset the constraints to one <code>DimConstraint</code>
	 * with default values.
	 */
	//public function setConstaints(value:Vector.<DimConstraint>):void {
   // constraints.fixed = false;
   // if (value == null || value.length < 1) {
   //   constraints.length = 1;
   //   constraints[0] = new DimConstraint();
   // }
   // else {
   //   var n:int = value.length;
   //   constraints.length = n;
   //   while (n-- > 0) {
   //     constraints[n] = value[n];
   //   }
   // }
   // constraints.fixed = true;
	//}

	/** Returns the number of rows/columns that this constraints currently have.
	 * @return The number of rows/columns that this constraints currently have. At least 1.
	 */
  //public function getCount():int {
		//return constraints.length
  //}
}
}