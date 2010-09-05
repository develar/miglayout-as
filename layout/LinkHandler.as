package cocoa.layout
{
import flash.utils.Dictionary;

public final class LinkHandler
{
//	public static const X:int = 0;
//	public static const Y:int = 1;
//	public static const WIDTH:int = 2;
//	public static const HEIGHT:int = 3;
//	public static const X2:int = 4;
//	public static const Y2:int = 5;
//
//	private static const LAYOUTS:Vector.<Dictionary> /*err*/ = new Vector.<Dictionary>(4);
////	private static const ArrayList<HashMap<String, int[]>> VALUES = new ArrayList<HashMap<String, int[]>>(4);
////	private static const ArrayList<HashMap<String, int[]>> VALUES_TEMP = new ArrayList<HashMap<String, int[]>>(4);
//
//	public synchronized static Integer getValue(Object layout, String key, int type)
//	{
//		Integer ret = null;
//		boolean cont = true;
//
//		for (int i = LAYOUTS.size() - 1; i >= 0; i--) {
//			Object l = LAYOUTS.get(i).get();
//			if (ret == null && l == layout) {
//				int[] rect = VALUES_TEMP.get(i).get(key);
//				if (cont && rect != null && rect[type] != LayoutUtil.NOT_SET) {
//					ret = new Integer(rect[type]);
//				} else {
//					rect = VALUES.get(i).get(key);
//					ret = (rect != null && rect[type] != LayoutUtil.NOT_SET) ? new Integer(rect[type]) : null;
//				}
//				cont = false;
//			}
//
//			if (l == null) {
//				LAYOUTS.remove(i);
//				VALUES.remove(i);
//				VALUES_TEMP.remove(i);
//			}
//		}
//		return ret;
//	}
//
//	/** Sets a key that can be linked to from any component.
//	 * @param layout The MigLayout instance
//	 * @param key The key to link to. This is the same as the ID in a component constraint.
//	 * @param x x
//	 * @param y y
//	 * @param width Width
//	 * @param height Height
//	 * @return If the value was changed
//	 */
//	public synchronized static boolean setBounds(Object layout, String key, int x, int y, int width, int height)
//	{
//		return setBounds(layout, key, x, y, width, height, false, false);
//	}
//
//	synchronized static boolean setBounds(Object layout, String key, int x, int y, int width, int height, boolean temporary, boolean incCur)
//	{
//		for (int i = LAYOUTS.size() - 1; i >= 0; i--) {
//			Object l = LAYOUTS.get(i).get();
//			if (l == layout) {
//				HashMap<String, int[]> map = (temporary ? VALUES_TEMP : VALUES).get(i);
//				int[] old = map.get(key);
//
//				if (old == null || old[X] != x || old[Y] != y || old[WIDTH] != width || old[HEIGHT] != height) {
//					if (old == null || incCur == false) {
//						map.put(key, new int[] {x, y, width, height, x + width, y + height});
//						return true;
//					} else {
//						boolean changed = false;
//
//						if (x != LayoutUtil.NOT_SET) {
//							if (old[X] == LayoutUtil.NOT_SET || x < old[X]) {
//								old[X] = x;
//								old[WIDTH] = old[X2] - x;
//								changed = true;
//							}
//
//							if (width != LayoutUtil.NOT_SET) {
//								int x2 = x + width;
//								if (old[X2] == LayoutUtil.NOT_SET || x2 > old[X2]) {
//									old[X2] = x2;
//									old[WIDTH] = x2 - old[X];
//									changed = true;
//								}
//							}
//						}
//
//						if (y != LayoutUtil.NOT_SET) {
//							if (old[Y] == LayoutUtil.NOT_SET || y < old[Y]) {
//								old[Y] = y;
//								old[HEIGHT] = old[Y2] - y;
//								changed = true;
//							}
//
//							if (height != LayoutUtil.NOT_SET) {
//								int y2 = y + height;
//								if (old[Y2] == LayoutUtil.NOT_SET || y2 > old[Y2]) {
//									old[Y2] = y2;
//									old[HEIGHT] = y2 - old[Y];
//									changed = true;
//								}
//							}
//						}
//						return changed;
//					}
//				}
//				return false;
//			}
//		}
//
//		LAYOUTS.add(new WeakReference<Object>(layout));
//		int[] bounds = new int[] {x, y, width, height, x + width, y + height};
//
//		HashMap<String, int[]> values = new HashMap<String, int[]>(4);
//		if (temporary)
//			values.put(key, bounds);
//		VALUES_TEMP.add(values);
//
//		values = new HashMap<String, int[]>(4);
//		if (temporary == false)
//			values.put(key, bounds);
//		VALUES.add(values);
//
//		return true;
//	}
//
//	public synchronized static boolean clearBounds(Object layout, String key)
//	{
//		for (int i = LAYOUTS.size() - 1; i >= 0; i--) {
//			Object l = LAYOUTS.get(i).get();
//			if (l == layout)
//				return VALUES.get(i).remove(key) != null;
//		}
//		return false;
//	}
//
//	static function clearTemporaryBounds(layout:Object):void
//	{
//		for (var i:int = LAYOUTS.size() - 1; i >= 0; i--) {
//			Object l = LAYOUTS.get(i).get();
//			if (l == layout) {
//				VALUES_TEMP.get(i).clear();
//				return;
//			}
//		}
//	}
}
}