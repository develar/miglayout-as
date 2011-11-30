package net.miginfocom.layout {
import flash.utils.Dictionary;

public final class LinkHandler {
  public static const X:int = 0;
  public static const Y:int = 1;
  public static const WIDTH:int = 2;
  public static const HEIGHT:int = 3;
  public static const X2:int = 4;
  public static const Y2:int = 5;

  private static const LAYOUTS:Vector.<Dictionary> /*Object*/ = new Vector.<Dictionary>();
  private static const VALUES:Vector.<Dictionary> /*<String, int[]>*/ = new Vector.<Dictionary>();
  private static const VALUES_TEMP:Vector.<Dictionary> = new Vector.<Dictionary>();

  public static function getValue(layout:Object, key:String, type:int):Number {
    var ret:Number = NaN;
    var cont:Boolean = true;

    for (var i:int = LAYOUTS.length - 1; i >= 0; i--) {
      var l:Object = Dictionaries.getFirst(LAYOUTS[i]);
      if (ret != ret && l == layout) {
        var rect:Vector.<int> = VALUES_TEMP[i][key];
        if (cont && rect != null && rect[type] != LayoutUtil.NOT_SET) {
          ret = rect[type];
        }
        else {
          rect = VALUES[i][key];
          ret = (rect != null && rect[type] != LayoutUtil.NOT_SET) ? rect[type] : NaN;
        }
        cont = false;
      }

      if (l == null) {
        LAYOUTS.splice(i, 1);
        VALUES.splice(i, 1);
        VALUES_TEMP.splice(i, 1);
      }
    }
    return ret;
  }

  /** Sets a key that can be linked to from any component.
 	 * @param layout The MigLayout instance
 	 * @param key The key to link to. This is the same as the ID in a component constraint.
 	 * @param x x
 	 * @param y y
 	 * @param width Width
 	 * @param height Height
 	 * @return If the value was changed
 	 */
  public static function setBounds(layout:Object, key:String, x:int, y:int, width:int, height:int):Boolean {
    return setBounds2(layout, key, x, y, width, height, false, false);
  }

  internal static function setBounds2(layout:Object, key:String, x:int, y:int, width:int, height:int, temporary:Boolean, incCur:Boolean):Boolean {
    for (var i:int = LAYOUTS.length - 1; i >= 0; i--) {
      var l:Object = Dictionaries.getFirst(LAYOUTS[i]);
      if (l == layout) {
        var map:Dictionary = (temporary ? VALUES_TEMP : VALUES)[i];
        var old:Vector.<int> = map[key];

        if (old == null || old[X] != x || old[Y] != y || old[WIDTH] != width || old[HEIGHT] != height) {
          if (old == null || !incCur) {
            map[key] = new <int>[x, y, width, height, x + width, y + height];
            return true;
          }
          else {
            var changed:Boolean = false;

            if (x != LayoutUtil.NOT_SET) {
              if (old[X] == LayoutUtil.NOT_SET || x < old[X]) {
                old[X] = x;
                old[WIDTH] = old[X2] - x;
                changed = true;
              }

              if (width != LayoutUtil.NOT_SET) {
                var x2:int = x + width;
                if (old[X2] == LayoutUtil.NOT_SET || x2 > old[X2]) {
                  old[X2] = x2;
                  old[WIDTH] = x2 - old[X];
                  changed = true;
                }
              }
            }

            if (y != LayoutUtil.NOT_SET) {
              if (old[Y] == LayoutUtil.NOT_SET || y < old[Y]) {
                old[Y] = y;
                old[HEIGHT] = old[Y2] - y;
                changed = true;
              }

              if (height != LayoutUtil.NOT_SET) {
                var y2:int = y + height;
                if (old[Y2] == LayoutUtil.NOT_SET || y2 > old[Y2]) {
                  old[Y2] = y2;
                  old[HEIGHT] = y2 - old[Y];
                  changed = true;
                }
              }
            }
            return changed;
          }
        }
        return false;
      }
    }

    var weakReference:Dictionary = new Dictionary(true);
    weakReference[layout] = null;
    LAYOUTS[LAYOUTS.length] = weakReference;
    var bounds:Vector.<int> = new <int>[x, y, width, height, x + width, y + height];

    var values:Dictionary = new Dictionary();
    if (temporary) {
      values[key] = bounds;
    }
    VALUES_TEMP[VALUES_TEMP.length] = values;

    values = new Dictionary();
    if (!temporary) {
      values[key] = bounds;
    }
    VALUES[VALUES.length] = values;

    return true;
  }

  /** This method clear any weak references right away instead of waiting for the GC. This might be advantageous
   * if lots of layout are created and disposed of quickly to keep memory consumption down.
   * @since 3.7.4
   */
  public static function clearWeakReferencesNow():void {
    LAYOUTS.length = 0;
  }

  public static function clearBounds(layout:Object, key:String):Boolean {
    for (var i:int = LAYOUTS.length - 1; i >= 0; i--) {
      var l:Object = Dictionaries.getFirst(LAYOUTS[i]);
      if (l == layout) {
        var d:Dictionary = VALUES[i];
        const r:Boolean = d[key] != undefined;
        delete d[key];
        return r;
      }
    }
    return false;
  }

  internal static function clearTemporaryBounds(layout:Object):void {
    for (var i:int = LAYOUTS.length - 1; i >= 0; i--) {
      var l:Object = Dictionaries.getFirst(LAYOUTS[i]);
      if (l == layout) {
        clearDictionary(VALUES_TEMP[i]);
        return;
      }
    }
  }

  private static function clearDictionary(value:Dictionary):Dictionary {
    var keys:Vector.<String> = new Vector.<String>(10);
    var keysIndex:int = 0;
    var key:String;
    for (key in value) {
      keys[keysIndex++] = key;
    }

    while (keysIndex-- > 0) {
      delete value[keys[keysIndex]];
    }

    return value;
  }
}
}