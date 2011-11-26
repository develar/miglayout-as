package net.miginfocom.layout {
public class ACBuilder {
  internal var ac:AC = new AC();

  /** Sets the total number of rows/columns to <code>size</code>. If the number of rows/columns is already more
   * than <code>size</code> nothing will happen.
   * @param size The total number of rows/columns
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
   */
  public function count(size:int):AC {
    makeSize(size);
    return this;
  }

  /** Specifies that the current row/column should not be grid-like. The while row/colum will have its components layed out
   * in one single cell. It is the same as to say that the cells in this column/row will all be merged (a.k.a spanned).
   * <p>
   * For a more thorough explanation of what this constraint does see the white paper or cheat Sheet at www.migcomponents.com.
   * @return <code>this</code> so it is possible to chain calls. E.g. <code>new AxisConstraint().noGrid().gap().fill()</code>.
   */
  public function noGrid():AC {
    return noGrid(curIx);
  }


}
}
