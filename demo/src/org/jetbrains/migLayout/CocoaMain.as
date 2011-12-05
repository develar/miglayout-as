package org.jetbrains.migLayout {
import cocoa.Container;
import cocoa.Label;
import cocoa.MigLayout;
import cocoa.View;
import cocoa.plaf.aqua.AquaLookAndFeel;

import flash.display.StageAlign;
import flash.display.StageScaleMode;

public class CocoaMain extends Container {
  public function CocoaMain() {
    var layout:MigLayout = new MigLayout("", "[][grow][][grow]", "[][]");
    super(createComponents(), layout);
    initRoot(new AquaLookAndFeel());
    validate();
  }

  private function createComponents():Vector.<View> {
    stage.scaleMode = StageScaleMode.NO_SCALE;
    stage.align = StageAlign.TOP_LEFT;

    var components:Vector.<View> = new Vector.<View>();
    var l1:Label = new Label();
    l1.title = "First Name";
    components[0] = l1;

    return components;
  }
}
}
