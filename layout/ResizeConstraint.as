package cocoa.layout {
/**
 * A parsed constraint that specifies how an entity (normally column/row or component) can shrink or grow compared to other entities.
 */
final class ResizeConstraint {
  static const WEIGHT_100:Number = 100;

  /**
   * How flexilble the entity should be, relative to other entities, when it comes to growing. <code>null</code> or
   * zero mean it will never grow. An entity that has twise the growWeight compared to another entity will get twice
   * as much of available space.
   * <p>
   * "grow" are only compared within the same "growPrio".
   */
  var grow:Number;

  /**
   * The relative priority used for determining which entities gets the extra space first.
   */
  var growPrio:int = 100;

  var shrink:Number = WEIGHT_100;

  var shrinkPrio:int = 100;

  public function ResizeConstraint(shrinkPrio:int, shrinkWeight:Number, growPrio:int, growWeight:Number) {
    this.shrinkPrio = shrinkPrio;
    this.shrink = shrinkWeight;
    this.growPrio = growPrio;
    this.grow = growWeight;
  }

  // ************************************************
  // Persistence Delegate and Serializable combined.
  // ************************************************

//	private Object readResolve() throws ObjectStreamException
//	{
//		return LayoutUtil.getSerializedObject(this);
//	}
//
//	public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException
//	{
//		LayoutUtil.setSerializedObject(this, LayoutUtil.readAsXML(in));
//	}
//
//	public void writeExternal(ObjectOutput out) throws IOException
//	{
//		if (getClass() == ResizeConstraint.class)
//			LayoutUtil.writeAsXML(out, this);
//	}
}
}