package org.jetbrains.migLayout {
import com.bit101.components.InputText;
import com.bit101.components.Label;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import org.jetbrains.migLayout.flash.FlashContainerWrapper;
import org.jetbrains.migLayout.flash.MigLayout;

public class FlashMain extends Sprite {
  public function FlashMain() {
    construct();
  }

  private function construct():void {
    stage.scaleMode = StageScaleMode.NO_SCALE;
    stage.align = StageAlign.TOP_LEFT;

    var g:Graphics = graphics;
    //g.beginFill(0x00ff00);
    g.drawRect(0, 0, 400, 400);
    g.endFill();

    var layout:MigLayout = new MigLayout("", "[][grow][][grow]", "[][]");
    layout.debug = true;
    var containerWrapper:FlashContainerWrapper = new FlashContainerWrapper(this, layout);

    //var lblFirstName:Label = new Label();
    var lblFirstName:TestShape = new TestShape(40, 20);
    containerWrapper.add(lblFirstName, "cell 0 0");
    //lblFirstName.text = "First Name";

    //var textField:InputText = new InputText();
    var textField:TestShape = new TestShape(100, 20);
    containerWrapper.add(textField, "cell 1 0,growx");

    //var lblNewLabel_1:Label = new Label();
    var lblNewLabel_1:TestShape = new TestShape(40, 20);
    containerWrapper.add(lblNewLabel_1, "cell 2 0");
    //lblNewLabel_1.text = "Surname";

    //var textField_1:InputText = new InputText();
    var textField_1:TestShape = new TestShape(100, 20);
    containerWrapper.add(textField_1, "cell 3 0,growx");

    //var lblNewLabel:Label = new Label();
    var lblNewLabel:TestShape = new TestShape(40, 20);
    //lblNewLabel.text = "Address";
    containerWrapper.add(lblNewLabel, "cell 0 1");

    //var textField_2:InputText = new InputText();
    var textField_2:TestShape = new TestShape(100, 20);
    containerWrapper.add(textField_2, "cell 1 1 3 1,growx");

    containerWrapper.layoutContainer();
  }
}
}

import flash.display.Graphics;
import flash.display.Shape;

final class TestShape extends Shape {
  public function TestShape(w:Number, h:Number) {
    var g:Graphics = graphics;
    g.beginFill(w == 100 ? 0xff00ff : 0x000000);
    g.drawRect(0, 0, w, h);
    g.endFill();
  }
}
