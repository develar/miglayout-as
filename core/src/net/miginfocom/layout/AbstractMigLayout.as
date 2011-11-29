package net.miginfocom.layout {
import flash.utils.Dictionary;

[Abstract]
public class AbstractMigLayout {
  protected var lc:LC;
  protected var colSpecs:AC, rowSpecs:AC;
  protected var grid:Grid;
  protected var lastModCount:int = PlatformDefaults.modCount;

  //private transient final Map<ComponentWrapper, CC> ccMap = new HashMap<ComponentWrapper, CC>(8);
  protected const ccMap:Dictionary = new Dictionary();
  //private final Map<Component, Object> scrConstrMap = new IdentityHashMap<Component, Object>(8);
  protected const scrConstrMap:Dictionary = new Dictionary();

  protected var dirty:Boolean = true;

  public function AbstractMigLayout(layoutConstraints:String, colConstraints:String, rowConstraints:String) {

  }
}
}
