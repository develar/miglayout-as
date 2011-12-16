package net.miginfocom.layout {
public final class ComponentConstraint extends DimConstraint {
  /** End group that this entity should be in for the dimension that this object is describing.
   * If this constraint is in an end group that is specified here. <code>null</code> means no end group
   * and all other values are legal. Components in the same end group
   * will have the same end coordinate.
   */
  public var endGroup:String;
}
}
