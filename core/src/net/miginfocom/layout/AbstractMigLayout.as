package net.miginfocom.layout {
[Abstract]
public class AbstractMigLayout {
  protected static const INVALID:uint = 1 << 0;

  protected var lc:LC;
  protected var colSpecs:Vector.<DimConstraint>, rowSpecs:Vector.<DimConstraint>;
  protected var grid:Grid;
  protected var lastModCount:int = PlatformDefaults.modCount;

  protected var flags:uint;

  public function AbstractMigLayout(layoutConstraints:String = null, colConstraints:String = null, rowConstraints:String = null) {
    this.layoutConstraints = layoutConstraints;
    this.columnConstraints = colConstraints;
    this.rowConstraints = rowConstraints;
  }

  public function setColumnConstraints(value:Vector.<DimConstraint>):void {
    colSpecs = value;
  }

  public function setRowConstraints(value:Vector.<DimConstraint>):void {
    rowSpecs = value;
  }

  public function set layoutConstraints(value:String):void {
    lc = ConstraintParser.parseLayoutConstraint(value);
    flags |= INVALID;
  }

  public function set columnConstraints(value:String):void {
    colSpecs = ConstraintParser.parseColumnConstraints(value);
    flags |= INVALID;
  }

  public function set rowConstraints(value:String):void {
    rowSpecs = ConstraintParser.parseRowConstraints(value);
    flags |= INVALID;
  }
}
}