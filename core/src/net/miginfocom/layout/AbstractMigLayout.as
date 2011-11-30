package net.miginfocom.layout {
import flash.utils.Dictionary;

[Abstract]
public class AbstractMigLayout {
  //private final Map<Component, Object> scrConstrMap = new IdentityHashMap<Component, Object>(8);
  protected const scrConstrMap:Dictionary = new Dictionary();
  private var _layoutConstraints:Object = "", _columnConstraints:Object = "", _rowConstraints:Object = "";

  protected var lc:LC;
  protected var colSpecs:AC, rowSpecs:AC;
  protected var grid:Grid;
  protected var lastModCount:int = PlatformDefaults.modCount;

  protected var dirty:Boolean = true;

  public function AbstractMigLayout(layoutConstraints:String, colConstraints:String, rowConstraints:String) {
    this.layoutConstraints = layoutConstraints;
    this.columnConstraints = colConstraints;
    this.rowConstraints = rowConstraints;
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
    dirty = true;
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
      colSpecs = AC(value);
    }

    _columnConstraints = value;
    dirty = true;
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
      rowSpecs = AC(value);
    }

    _rowConstraints = value;
    dirty = true;
  }
}
}
