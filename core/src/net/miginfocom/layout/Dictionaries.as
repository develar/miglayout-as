package net.miginfocom.layout {
import flash.utils.Dictionary;

internal final class Dictionaries {
  internal static function getFirst(dictionary:Dictionary):Object {
    //noinspection LoopStatementThatDoesntLoopJS
    for (var object:Object in dictionary) {
      return object;
    }

    return null;
  }
}
}
