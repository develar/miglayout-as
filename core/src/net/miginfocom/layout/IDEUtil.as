package net.miginfocom.layout {
public final class IDEUtil {
  /** Returns the sizes of the columns and gaps for a container.
   * There will be two arrays returned [0] and [1].
   * <p>
   * The first array will be the indexes of the columns where indexes that
   * are less than 30000 or larger than 30000 is docking columns. There might be extra docking columns that aren't
   * visible but they always have size 0. Non docking indexes will probably always be 0, 1, 2, 3, etc..
   * <p>
   * The second array is the sizes of the form:<br>
   * <code>[top inset][column size 1][gap 1][column size 2][gap 2][column size n][bottom inset]</code>.
   * <p>
   * The returned sizes will be the ones calculated in the last layout cycle.
   * The returned sizes will be the ones calculated in the last layout cycle.
   */
  public static function getColumnSizes(grid:Grid):Vector.<Vector.<int>> {
    return grid.getIndicesAndSizes(false);
  }

  /** Returns the sizes of the rows and gaps for a container.
   * There will be two arrays returned [0] and [1].
   * <p>
   * The first array will be the indexes of the rows where indexes that
   * are less than 30000 or larger than 30000 is docking rows. There might be extra docking rows that aren't
   * visible but they always have size 0. Non docking indexes will probably always be 0, 1, 2, 3, etc..
   * <p>
   * The second array is the sizes of the form:<br>
   * <code>[left inset][row size 1][gap 1][row size 2][gap 2][row size n][right inset]</code>.
   * <p>
   * The returned sizes will be the ones calculated in the last layout cycle.
   * The returned sizes will be the ones calculated in the last layout cycle.
   */
  public static function getRowSizes(grid:Grid):Vector.<Vector.<int>> {
    return grid.getIndicesAndSizes(true);
  }
}
}