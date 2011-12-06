package net.miginfocom.layout {
[Abstract]
public class AbstractMigLayout {
  protected static const INVALID:uint = 1 << 0;

  private var _layoutConstraints:Object = "", _columnConstraints:Object = "", _rowConstraints:Object = "";

  protected var lc:LC;
  protected var colSpecs:Vector.<DimConstraint>, rowSpecs:Vector.<DimConstraint>;
  protected var grid:Grid;
  protected var lastModCount:int = PlatformDefaults.modCount;

  protected var flags:uint;

  public function AbstractMigLayout(layoutConstraints:String, colConstraints:String, rowConstraints:String) {
    this.layoutConstraints = layoutConstraints;
    this.columnConstraints = colConstraints;
    this.rowConstraints = rowConstraints;
  }

  protected var _debug:Boolean;
  public function set debug(value:Boolean):void {
    _debug = true;
  }

  public function get layoutConstraints():Object {
    return _layoutConstraints;
  }

  public function set layoutConstraints(value:Object):void {
    if (value == null || value is String) {
      value = ConstraintParser.prepare(String(value));
      lc = ConstraintParser.parseLayoutConstraint(String(value));
    }
    else {
      lc = LC(value);
    }

    _layoutConstraints = value;
    flags |= INVALID;
  }

  public function get columnConstraints():Object {
    return _columnConstraints;
  }

  public function set columnConstraints(value:Object):void {
    if (value == null || value is String) {
      value = ConstraintParser.prepare(String(value));
      colSpecs = ConstraintParser.parseColumnConstraints(String(value));
    }
    else {
      colSpecs = value as Vector.<DimConstraint>;
    }

    _columnConstraints = value;
    flags |= INVALID;
  }

  public function get rowConstraints():Object {
    return _rowConstraints;
  }

  public function set rowConstraints(value:Object):void {
    if (value == null || value is String) {
      value = ConstraintParser.prepare(String(value));
      rowSpecs = ConstraintParser.parseRowConstraints(String(value));
    }
    else {
      rowSpecs = value as Vector.<DimConstraint>;
    }

    _rowConstraints = value;
    flags |= INVALID;
  }
}
}
