http://www.miglayout.com/

http://code.google.com/javadevtools/wbpro/layoutmanagers/swing/miglayout.html

## License
Original license (java): BSD. ActionScript port (this project): Apache License v2.0.

## Version
4.3-SNAPSHOT, [598f8c0f9562](https://code.google.com/p/miglayout/source/detail?r=598f8c0f9562a72e37bfbfef205a2a92393fdeee)

## Implementation notes:
* All Java getters/setters as ActionScript get/set.
* All builders method moved from LC/AC to new classes LCBuilder/ACBuilder due to:
 * ActionScript doesn't support overloading methods;
 * Reduce your swf size (if you don't use "API Creation of Constraints").
* Deprecated methods are not ported.
* Class AC is removed, because it contains only vector of DimConstraint.
* horizontalScreenDPI, verticalScreenDPI, getPixelUnitFactor, screenWidth, screenHeight, screenLocationX and screenLocationY moved from ComponentWrapper to ContainerWrapper (due to actually used only containers).
* parent removed from ComponentWrapper — is not needed at all (only one case, so, hasParent added to ContainerWrapper).
* Grid allows nullable rowConstraints, columnConstraints and lc.
* Grid.layout() method — remove alignX and alignY paramaters, because LC has full information about it.
* DimConstraint refactored — CellConstraint and ComponentConstraint were extracted and DimConstraint became internal abstract class due to:
 * reduce memory usage (overhead is very small, but nevertheless);
 * remove comments like "Only applicable on components!" :)

API Creation of Constraints is ported too, but is not tested and is not recommended to use. String creation of the constraints is short to type and easy to read.

## FAQ
### Why Flex layout is not suitable?
http://www.javalobby.org/articles/miglayout/