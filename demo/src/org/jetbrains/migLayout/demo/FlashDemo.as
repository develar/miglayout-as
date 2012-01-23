package org.jetbrains.migLayout.demo {
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import org.jetbrains.migLayout.flash.FlashContainerWrapper;
import org.jetbrains.migLayout.flash.MigLayout;

public class FlashDemo extends Sprite {
  private var containerWrapper:FlashContainerWrapper;
  private var invalid:Boolean;

  public function FlashDemo() {
    construct();
  }

  private function construct():void {
    stage.scaleMode = StageScaleMode.NO_SCALE;
    stage.align = StageAlign.TOP_LEFT;

    var layout:MigLayout = new MigLayout("", "[][grow][][grow]", "[][]");
    containerWrapper = new FlashContainerWrapper(this, layout);

    var lblFirstName:TestShape = new TestShape(40, 20);
    containerWrapper.add(lblFirstName, "cell 0 0");

    var textField:TestShape = new TestShape(100, 20);
    containerWrapper.add(textField, "cell 1 0,growx");

    var lblNewLabel_1:TestShape = new TestShape(40, 20);
    containerWrapper.add(lblNewLabel_1, "cell 2 0");

    var textField_1:TestShape = new TestShape(100, 20);
    containerWrapper.add(textField_1, "cell 3 0,growx");

    var lblNewLabel:TestShape = new TestShape(40, 20);
    containerWrapper.add(lblNewLabel, "cell 0 1");

    var textField_2:TestShape = new TestShape(100, 20);
    containerWrapper.add(textField_2, "cell 1 1 3 1,growx");

    //var lblFirstName:Label = new Label(null, 0, 0, "First Name");
    ////var lblFirstName:TestShape = new TestShape(40, 20);
    //containerWrapper.add(lblFirstName, "cell 0 0");
    //
    //var textField:InputText = new InputText();
    ////var textField:TestShape = new TestShape(100, 20);
    //containerWrapper.add(textField, "cell 1 0,growx");
    //
    //var lblNewLabel_1:Label = new Label(null, 0, 0, "Surname");
    ////var lblNewLabel_1:TestShape = new TestShape(40, 20);
    //containerWrapper.add(lblNewLabel_1, "cell 2 0");
    //
    //var textField_1:InputText = new InputText();
    ////var textField_1:TestShape = new TestShape(100, 20);
    //containerWrapper.add(textField_1, "cell 3 0,growx");
    //
    //var lblNewLabel:Label = new Label(null, 0, 0, "Address");
    ////var lblNewLabel:TestShape = new TestShape(40, 20);
    //containerWrapper.add(lblNewLabel, "cell 0 1");
    //
    //var textField_2:InputText = new InputText();
    ////var textField_2:TestShape = new TestShape(100, 20);
    //containerWrapper.add(textField_2, "cell 1 1 3 1,growx");

    invalidate();
    stage.addEventListener(Event.RESIZE, resizeHandler);
  }

  private function invalidate():void {
    if (!invalid) {
      invalid = true;
      addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }
  }

  private function resizeHandler(event:Event):void {
    invalidate();
  }

  private function enterFrameHandler(event:Event):void {
    removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
    containerWrapper.layoutContainer();
    invalid = false;
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