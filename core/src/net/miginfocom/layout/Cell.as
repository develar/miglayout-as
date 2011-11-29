package net.miginfocom.layout {
/** A simple representation of a cell in the grid. Contains a number of component wraps, if they span more than one cell.
 */
internal final class Cell {
  internal var spanx:int, spany:int;
  internal var flowx:Boolean;
  //private ArrayList<CompWrap> compWraps = new ArrayList<CompWrap>(1);
  internal const compWraps:Vector.<CompWrap> = new Vector.<CompWrap>();

  internal var hasTagged:Boolean = false; // If one or more components have styles and need to be checked by the component sorter

  function Cell(cw:CompWrap, spanx:int = 1, spany:int = 1, flowx:Boolean = true) {
    if (cw != null) {
      compWraps[compWraps.length] = cw;
    }

    this.spanx = spanx;
    this.spany = spany;
    this.flowx = flowx;
  }
}
}
