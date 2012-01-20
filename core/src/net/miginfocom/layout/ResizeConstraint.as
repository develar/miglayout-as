package net.miginfocom.layout {
/** A parsed constraint that specifies how an entity (normally column/row or component) can shrink or
 * grow compared to other entities.
 */
internal final class ResizeConstraint {
  internal static const WEIGHT_100:Number = 100;

  /**
   * How flexilble the entity should be, relative to other entities, when it comes to growing. <code>null</code> or
   * zero mean it will never grow. An entity that has twise the growWeight compared to another entity will get twice
   * as much of available space.
   * <p>
   * "grow" are only compared within the same "growPrio".
   */
  internal var grow:Number;

  /**
   * The relative priority used for determining which entities gets the extra space first.
   */
  internal var growPrio:int;

  internal var shrink:Number;

  internal var shrinkPrio:int;

  public function ResizeConstraint(shrinkPrio:int = 100, shrink:Number = WEIGHT_100, growPrio:int = 100, growWeight:Number = NaN) {
    this.shrinkPrio = shrinkPrio;
    this.shrink = shrink;
    this.growPrio = growPrio;
    this.grow = growWeight;
  }
}
}