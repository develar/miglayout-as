/*
 * License (BSD):
 * ==============
 *
 * Copyright (c) 2004, Mikael Grev, MiG InfoCom AB. (miglayout (at) miginfocom (dot) com)
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list
 * of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this
 * list of conditions and the following disclaimer in the documentation and/or other
 * materials provided with the distribution.
 * Neither the name of the MiG InfoCom AB nor the names of its contributors may be
 * used to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 * @version 1.0
 * @author Mikael Grev, MiG InfoCom AB
 */
package net.miginfocom.layout {
import flash.utils.Dictionary;

/** Holds components in a grid. Does most of the logic behind the layout manager.
 */
public final class Grid {
	private static const GROW_100:Vector.<Number> = new <Number>[ResizeConstraint.WEIGHT_100];

	private static const DOCK_DIM_CONSTRAINT:CellConstraint = new CellConstraint();
  DOCK_DIM_CONSTRAINT.growPriority = 0;

	/** This is the maximum grid position for "normal" components. Docking components use the space out to
	 * <code>MAX_DOCK_GRID</code> and below 0.
	 */
	private static const MAX_GRID:int = 30000;

	/** Docking components will use the grid coordinates <code>-MAX_DOCK_GRID -> 0</code> and <code>MAX_GRID -> MAX_DOCK_GRID</code>.
	 */
	private static const MAX_DOCK_GRID:int = 32767;

	/** A constraint used for gaps.
	 */
	private static const GAP_RC_CONST:ResizeConstraint = new ResizeConstraint(200, ResizeConstraint.WEIGHT_100, 50, NaN);
	private static const GAP_RC_CONST_PUSH:ResizeConstraint = new ResizeConstraint(200, ResizeConstraint.WEIGHT_100, 50, ResizeConstraint.WEIGHT_100);

	/** Used for components that doesn't have a CC set. Not that it's really really important that the CC is never changed in this Grid class.
	 */
	private static const DEF_CC:CC = new CC();
  private static var DEF_LC:LC;
	private static const DEF_DIM_C:CellConstraint = new CellConstraint();

	/** The constraints. Never <code>null</code>.
	 */
	private var lc:LC;

	/** The parent that is layout out and this grid is done for. Never <code>null</code>.
	 */
	private var container:ContainerWrapper;

	/** An x, y array implemented as a sparse array to accommodate for any grid size without wasting memory (or rather 15 bit (0-MAX_GRID * 0-MAX_GRID).
	 */
	//private LinkedHashMap<Integer, Cell> grid = new LinkedHashMap<Integer, Cell>();   // [(y << 16) + x] -> Cell. null key for absolute positioned compwraps
  // must be Array, not Vector — we need sparse array
	private const grid:Array = [];   // [(y << 16) + x] -> Cell. null key for absolute positioned compwraps

	//private HashMap<Integer, BoundSize> wrapGapMap = null;   // Row or Column index depending in the dimension that "wraps". Normally row indexes but may be column indexes if "flowy". 0 means before first row/col.
	private var wrapGapMap:Array;   // Row or Column index depending in the dimension that "wraps". Normally row indexes but may be column indexes if "flowy". 0 means before first row/col.

	/** The size of the grid. Row count and column count.
	 */
	//private TreeSet<Integer> rowIndexes = new TreeSet<Integer>(), colIndexes = new TreeSet<Integer>();
	private var rowIndexes:Array = [], colIndexes:Array = [];

	/** The row and column specifications.
	 */
	private var rowConstr:Vector.<CellConstraint>, colConstr:Vector.<CellConstraint>;

	/** The in the constructor calculated min/pref/max sizes of the rows and columns.
	 */
	private var colFlowSpecs:FlowSizeSpec, rowFlowSpecs:FlowSizeSpec;

	/** Components that are connections in one dimension (such as baseline alignment for instance) are grouped together and stored here.
	 * One for each row/column.
	 */
	//private ArrayList<LinkedDimGroup>[] colGroupLists, rowGroupLists;   //[(start)row/col number]
	private var colGroupLists:Vector.<Vector.<LinkedDimGroup>>, rowGroupLists:Vector.<Vector.<LinkedDimGroup>>;   //[(start)row/col number]

	/** The in the constructor calculated min/pref/max size of the whole grid.
	 */
	private var _width:Vector.<int>, _height:Vector.<int>;

	/** If any of the absolute coordinates for component bounds has links the name of the target is in this Set.
	 * Since it requires some memory and computations this is checked at the creation so that
	 * the link information is only created if needed later.
	 * <p>
	 * The boolean is true for groups id:s and null for normal id:s.
	 */
	//private HashMap<String, Boolean> linkTargetIDs = null;
	private var linkTargetIDs:Dictionary;

	private var dockOffY:int, dockOffX:int;

	private var pushXs:Vector.<Number>, pushYs:Vector.<Number>;

	//private ArrayList<LayoutCallback> callbackList;
	private var callbackList:Vector.<LayoutCallback>;

	/** Constructor.
	 * @param container The container that will be laid out.
	 * @param lc The form flow constraints.
	 * @param rowConstraints The rows specifications. If more cell rows are required, the last element will be used for when there is no corresponding element in this array.
	 * @param columnConstraints The columns specifications. If more cell rows are required, the last element will be used for when there is no corresponding element in this array.
	 * @param callbackList A list of callbacks or <code>null</code> if none. Will not be altered.
	 */
  public function Grid(container:ContainerWrapper, lc:LC, rowConstraints:Vector.<CellConstraint> = null, columnConstraints:Vector.<CellConstraint> = null, callbackList:Vector.<LayoutCallback> = null) {
    if (lc == null) {
      if (DEF_LC == null) {
        DEF_LC = new LC();
      }
      this.lc = DEF_LC;
    }
    else {
      this.lc = lc;
    }
    this.rowConstr = rowConstraints;
    this.colConstr = columnConstraints;
    this.container = container;
    this.callbackList = callbackList;
    construct();
  }

  private function construct():void {
		const wrapCount:int = lc.wrapAfter != 0 ? lc.wrapAfter : (lc.flowX ? colConstr == null ? 0 : colConstr.length : rowConstr == null ? 0 : rowConstr.length);

		var comps:Vector.<ComponentWrapper> = container.components;

    var hasTagged:Boolean = false;  // So we do not have to sort if it will not do any good
    var hasPushX:Boolean = false, hasPushY:Boolean = false;
    var hitEndOfRow:Boolean = false;
    var cellXY:Vector.<int> = new Vector.<int>(2, true);
		var spannedRects:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();

		var specs:Vector.<CellConstraint> = lc.flowX ? rowConstr : colConstr;

		var sizeGroupsX:int = 0, sizeGroupsY:int = 0;
		var dockInsets:Vector.<int> = null;    // top, left, bottom, right insets for docks.

		LinkHandler.clearTemporaryBounds(container.getLayout());
    var i:int;
    var cw:CompWrap;
    var cell:Cell;

    var sizeGroupMapX:Dictionary;
    var sizeGroupMapY:Dictionary;

    i = 0;
    while (i < comps.length) {
      var comp:ComponentWrapper = comps[i];
			var rootCc:CC = comp.constraints || DEF_CC;

			addLinkIDs(rootCc);

      var hideMode:int = comp.visible ? -1 : rootCc.hideMode != -1 ? rootCc.hideMode : lc.hideMode;
      if (hideMode == 3) { // To work with situations where there are components that does not have a layout manager, or not this one.
        setLinkedBounds(comp, rootCc, comp.x, comp.y, comp.actualWidth, comp.actualHeight, rootCc.external);
        i++;
        continue;   // The "external" component should not be handled further.
      }

      if (rootCc.horizontal.sizeGroup != null) {
        sizeGroupsX++;
      }
      if (rootCc.vertical.sizeGroup != null) {
        sizeGroupsY++;
      }

			// Special treatment of absolute positioned components.
      var pos:Vector.<UnitValue> = getPos(comp, rootCc);
      var cbSz:Vector.<BoundSize> = getCallbackSize(comp);
      if (pos != null || rootCc.external) {
				cw = new CompWrap(comp, rootCc, hideMode, pos, cbSz, container);
				cell = grid[null];
        if (cell == null) {
          grid[null] = new Cell(cw);
        }
        else {
          cell.compWraps[cell.compWraps.length] = cw;
        }

				if (!rootCc.boundsInGrid || rootCc.external) {
					setLinkedBounds(comp, rootCc, comp.x, comp.y, comp.actualWidth, comp.actualHeight, rootCc.external);
					i++;
					continue;
				}
			}

			if (rootCc.dockSide != -1) {
        if (dockInsets == null) {
          dockInsets = new <int>[-MAX_DOCK_GRID, -MAX_DOCK_GRID, MAX_DOCK_GRID, MAX_DOCK_GRID];
        }

        addDockingCell(dockInsets, rootCc.dockSide, new CompWrap(comp, rootCc, hideMode, pos, cbSz, container));
				i++;
				continue;
			}

      var cellFlowX:int = rootCc.flowX;
      cell = null;

      if (rootCc.newline) {
        wrap(cellXY, rootCc.newlineGapSize);
      }
      else if (hitEndOfRow) {
        wrap(cellXY, null);
      }
      hitEndOfRow = false;

			var rowNoGrid:Boolean = lc.noGrid || (specs != null && specs.length > 0 && (LayoutUtil.getIndexSafe(specs, lc.flowX ? cellXY[1] : cellXY[0])).noGrid);
			// Move to a free y, x  if no absolute grid specified
      var cx:int = rootCc.cellX;
      var cy:int = rootCc.cellY;
      if ((cx < 0 || cy < 0) && !rowNoGrid && rootCc.skip == 0) { // 3.7.2: If skip, don't find an empty cell first.
        while (!isCellFree(cellXY[1], cellXY[0], spannedRects)) {
          if (Math.abs(increase(cellXY, 1)) >= wrapCount) {
            wrap(cellXY, null);
          }
        }
      }
      else {
        if (cx >= 0 && cy >= 0) {
          if (cy >= 0) {
            cellXY[0] = cx;
            cellXY[1] = cy;
          }
          else {    // Only one coordinate is specified. Use the current row (flowx) or column (flowy) to fill in.
            cellXY[lc.flowX ? 0 : 1] = cx;
          }
        }
        cell = getCell(cellXY[1], cellXY[0]); // Might be null
      }

			// Skip a number of cells. Changed for 3.6.1 to take wrap into account and thus "skip" to the next and possibly more rows.
      for (var s:int = 0, skipCount:int = rootCc.skip; s < skipCount; s++) {
        do {
          if (Math.abs(increase(cellXY, 1)) >= wrapCount) {
            wrap(cellXY, null);
          }
        }
        while (!isCellFree(cellXY[1], cellXY[0], spannedRects));
      }

      // If cell is not created yet, create it and set it.
      if (cell == null) {
        var spanx:int = Math.min(rowNoGrid && lc.flowX ? LayoutUtil.INF : rootCc.spanX, MAX_GRID - cellXY[0]);
        var spany:int = Math.min(rowNoGrid && !lc.flowX ? LayoutUtil.INF : rootCc.spanY, MAX_GRID - cellXY[1]);
        cell = new Cell(null, spanx, spany, cellFlowX == 0 ? lc.flowX : cellFlowX == 1);
        setCell(cellXY[1], cellXY[0], cell);

        // Add a rectangle so we can know that spanned cells occupy more space.
        if (spanx > 1 || spany > 1) {
          spannedRects[spannedRects.length] = new <int>[cellXY[0], cellXY[1], spanx, spany];
        }
      }

      // Add the one, or all, components that split the grid position to the same Cell.
      var wrapHandled:Boolean = false;
      var splitLeft:int = rowNoGrid ? LayoutUtil.INF : rootCc.split - 1;
      var splitExit:Boolean = false;
      var spanRestOfRow:Boolean = (lc.flowX ? rootCc.spanX : rootCc.spanY) == LayoutUtil.INF;

      for (; splitLeft >= 0 && i < comps.length; splitLeft--) {
        var compAdd:ComponentWrapper = comps[i];
        var cc:CC = compAdd.constraints || DEF_CC;

        addLinkIDs(cc);

        var visible:Boolean = compAdd.visible;
        hideMode = visible ? -1 : cc.hideMode != -1 ? cc.hideMode : lc.hideMode;

        if (cc.external || hideMode == 3) {
					i++;
					splitLeft++;    // Added for 3.5.5 so that these components does not "take" a split slot.
					continue;       // To work with situations where there are components that does not have a layout manager, or not this one.
				}

        hasPushX ||= (visible || hideMode > 1) && cc.pushX == cc.pushX;
        hasPushY ||= (visible || hideMode > 1) && cc.pushY == cc.pushY;

        if (cc != rootCc) { // If not first in a cell
          if (cc.newline || !cc.boundsInGrid || cc.dockSide != -1) {
            break;
          }

          if (splitLeft > 0 && cc.skip > 0) {
            splitExit = true;
            break;
          }

          pos = getPos(compAdd, cc);
          cbSz = getCallbackSize(compAdd);
        }

        cw = new CompWrap(compAdd, cc, hideMode, pos, cbSz, container);
        cell.compWraps[cell.compWraps.length] = cw;
        cell.hasTagged ||= cc.tag != null;
        hasTagged ||= cell.hasTagged;

        if (cc != rootCc) {
          if (cc.horizontal.sizeGroup != null) {
            sizeGroupsX++;
          }
          if (cc.vertical.sizeGroup != null) {
            sizeGroupsY++;
          }
        }

        i++;

        if (cc.wrap || spanRestOfRow && splitLeft == 0) {
          if (cc.wrap) {
            wrap(cellXY, cc.wrapGapSize);
          }
          else {
            hitEndOfRow = true;
          }
          wrapHandled = true;
          break;
        }
      }

      if (!wrapHandled && !rowNoGrid) {
        const span:int = lc.flowX ? cell.spanx : cell.spany;
        if (Math.abs((lc.flowX ? cellXY[0] : cellXY[1])) + span >= wrapCount) {
          hitEndOfRow = true;
        }
        else {
          increase(cellXY, splitExit ? span - 1 : span);
        }
      }
    }

		// If there were size groups, calculate the largest values in the groups (for min/pref/max) and enforce them on the rest in the group.
		if (sizeGroupsX > 0 || sizeGroupsY > 0) {
			sizeGroupMapX = sizeGroupsX > 0 ? new Dictionary() : null;
			sizeGroupMapY = sizeGroupsY > 0 ? new Dictionary() : null;
			var sizeGroupCWs:Vector.<CompWrap> = new Vector.<CompWrap>(Math.max(sizeGroupsX, sizeGroupsY), true);
      var sizeGroupCWsLength:int = 0;
			for each (cell in grid) {
        for (i = 0; i < cell.compWraps.length; i++) {
          cw = cell.compWraps[i];
          sgx = cw.cc.horizontal.sizeGroup;
          sgy = cw.cc.vertical.sizeGroup;
          if (sgx != null || sgy != null) {
            if (sgx != null && sizeGroupMapX != null) {
              addToSizeGroup(sizeGroupMapX, sgx, cw.horSizes);
            }
            if (sgy != null && sizeGroupMapY != null) {
              addToSizeGroup(sizeGroupMapY, sgy, cw.verSizes);
            }
            sizeGroupCWs[sizeGroupCWsLength++] = cw;
          }
        }
      }

			// Set/equalize the sizeGroups to same the values.
      for (i = 0; i < sizeGroupCWsLength; i++) {
        cw = sizeGroupCWs[i];
        if (sizeGroupMapX != null) {
          cw.setSizes(sizeGroupMapX[cw.cc.horizontal.sizeGroup], true);
        }  // Target method handles null sizes
        if (sizeGroupMapY != null) {
          cw.setSizes(sizeGroupMapY[cw.cc.vertical.sizeGroup], false);
        } // Target method handles null sizes
      }
		} // Component loop

		// If there were size groups, calculate the largest values in the groups (for min/pref/max) and enforce them on the rest in the group.
		if (sizeGroupsX > 0|| sizeGroupsY > 0) {
			sizeGroupMapX = sizeGroupsX > 0 ? new Dictionary() : null;
			sizeGroupMapY = sizeGroupsY > 0 ? new Dictionary() : null;
			sizeGroupCWs = new Vector.<CompWrap>(Math.max(sizeGroupsX, sizeGroupsY));
      sizeGroupCWsLength = 0;

      for each (cell in grid) {
        for (i = 0; i < cell.compWraps.length; i++) {
          cw = cell.compWraps[i];
          var sgx:String = cw.cc.horizontal.sizeGroup;
          var sgy:String = cw.cc.vertical.sizeGroup;

          if (sgx != null || sgy != null) {
            if (sgx != null && sizeGroupMapX != null) {
              addToSizeGroup(sizeGroupMapX, sgx, cw.horSizes);
            }
            if (sgy != null && sizeGroupMapY != null) {
              addToSizeGroup(sizeGroupMapY, sgy, cw.verSizes);
            }
            sizeGroupCWs[sizeGroupCWsLength++] = cw;
          }
        }
			}

      // Set/equalize the sizeGroups to same the values.
      for (i = 0; i < sizeGroupCWsLength; i++) {
        cw = sizeGroupCWs[i];
        if (sizeGroupMapX != null) {
          cw.setSizes(sizeGroupMapX[cw.cc.horizontal.sizeGroup], true);
        }  // Target method handles null sizes
        if (sizeGroupMapY != null) {
          cw.setSizes(sizeGroupMapY[cw.cc.vertical.sizeGroup], false);
        } // Target method handles null sizes
      }
		}

    if (hasTagged) {
      sortCellsByPlatform(grid.values(), container);
    }

		// Calculate gaps now that the cells are filled and we know all adjacent components.
		var ltr:Boolean = LayoutUtil.isLeftToRight(lc, container);
    for each (cell in grid) {
      var cws:Vector.<CompWrap> = cell.compWraps;
      const lastI:int = cws.length - 1;
			for (i = 0; i <= lastI; i++) {
				cw = cws[i];
				var cwBef:ComponentWrapper = i > 0 ? cws[i - 1].comp : null;
        var cwAft:ComponentWrapper = i < lastI ? cws[i + 1].comp : null;

        var tag:String = (cw.comp.constraints || DEF_CC).tag;
				var ccBef:CC = cwBef != null ? cwBef.constraints || DEF_CC : null;
        var ccAft:CC = cwAft != null ? cwAft.constraints || DEF_CC : null;
        cw.calcGaps(cwBef, ccBef, cwAft, ccAft, tag, cell.flowx, ltr, container);
			}
		}

		dockOffX = getDockInsets(colIndexes);
		dockOffY = getDockInsets(rowIndexes);

    var iSz:int;
    // Add synthetic indexes for empty rows and columns so they can get a size
    for (i = 0, iSz = rowConstr == null ? 1 : rowConstr.length; i < iSz; i++) {
      rowIndexes[i] = true;
    }
    for (i = 0, iSz = colConstr == null ? 1 : colConstr.length; i < iSz; i++) {
      colIndexes[i] = true;
    }

		colGroupLists = divideIntoLinkedGroups(false);
		rowGroupLists = divideIntoLinkedGroups(true);

		pushXs = hasPushX || lc.fillX ? getDefaultPushWeights(false) : null;
		pushYs = hasPushY || lc.fillY ? getDefaultPushWeights(true) : null;

    if (LayoutUtil.isDesignTime(container)) {
      saveGrid(container, grid);
    }
	}

	private function addLinkIDs(cc:CC):void {
		var linkIDs:Vector.<String> = cc.getLinkTargets();
    for each (var linkID:String in linkIDs) {
      if (linkTargetIDs == null) {
        linkTargetIDs = new Dictionary();
      }
      linkTargetIDs[linkID] = null;
    }
  }

	/** If the container (parent) that this grid is laying out has changed its bounds, call this method to
	 * clear any cached values.
	 */
	public function invalidateContainerSize():void {
		colFlowSpecs = null;
	}

	/** Does the actual layout. Uses many values calculated in the constructor.
	 * @param x The bounds to layout against. [x, y, width, height].
	 * @param y The bounds to layout against. [x, y, width, height].
	 * @param w The bounds to layout against. [x, y, width, height].
	 * @param h The bounds to layout against. [x, y, width, height].
	 * @param debug If debug information should be saved in {link #debugRects}.
	 * @param checkPrefChange If a check should be done to see if the setting of any new bounds changes the preferred size
	 * of a component.
	 * @return If the layout has probably changed the preferred size and there is need for a new layout (normally only SWT).
	 */
	public function layout(x:int, y:int, w:int, h:int, debug:Boolean, checkPrefChange:Boolean):Boolean {
		checkSizeCalcs();

		resetLinkValues(true, true);

		layoutInOneDim(w, lc.alignX, false, pushXs);
		layoutInOneDim(h, lc.alignY, true, pushYs);

		//HashMap<String, Integer> endGrpXMap = null, endGrpYMap = null;
		var endGrpXMap:Dictionary = null, endGrpYMap:Dictionary = null;
		const compCount:int = container.componentCount;
		// Transfer the calculated bound from the ComponentWrappers to the actual Components.
		var layoutAgain:Boolean = false;
    var cw:CompWrap;
    var i:int;
    var iSz:int;
    var cell:Cell;
    var compWraps:Vector.<CompWrap>;
		if (compCount > 0) {
			for (var j:int = 0; j < (linkTargetIDs != null ? 2 : 1); j++) {   // First do the calculations (maybe more than once) then set the bounds when done
				var doAgain:Boolean;
				var count:int = 0;
				do {
					doAgain = false;
					for each (cell in grid) {
						compWraps = cell.compWraps;
						for (i = 0, iSz = compWraps.length; i < iSz; i++) {
							cw = compWraps[i];
							if (j == 0) {
								doAgain ||= doAbsoluteCorrections(cw, w, h);
                if (!doAgain) { // If we are going to do this again, do not bother this time around
                  if (cw.cc.horizontal.endGroup != null) {
                    endGrpXMap = addToEndGroup(endGrpXMap, cw.cc.horizontal.endGroup, cw.x + cw.w);
                  }
                  if (cw.cc.vertical.endGroup != null) {
                    endGrpYMap = addToEndGroup(endGrpYMap, cw.cc.vertical.endGroup, cw.y + cw.h);
                  }
                }

								// @since 3.7.2 Needed or absolute "pos" pointing to "visual" or "container" didn't work if
                // their bounds changed during the layout cycle. At least not in SWT.
                if (linkTargetIDs != null && ("visual" in linkTargetIDs || "container" in linkTargetIDs)) {
                  layoutAgain = true;
                }
              }

              if (linkTargetIDs == null || j == 1) {
                if (cw.cc.horizontal.endGroup != null) {
                  cw.w = endGrpXMap[cw.cc.horizontal.endGroup] - cw.x;
                }
                if (cw.cc.vertical.endGroup != null) {
                  cw.h = endGrpYMap[cw.cc.vertical.endGroup] - cw.y;
                }

                cw.x += x;
                cw.y += y;
                layoutAgain ||= cw.transferBounds(checkPrefChange && !layoutAgain);

                if (callbackList != null) {
                  for each (var callback:LayoutCallback in callbackList) {
                    callback.correctBounds(cw.comp);
                  }
                }
							}
						}
					}
          clearGroupLinkBounds();
          if (++count > ((compCount << 3) + 10)) {
            trace("Unstable cyclic dependency in absolute linked values!");
            break;
          }
        }
        while (doAgain);
      }
    }

		// Add debug shapes for the "cells". Use the CompWraps as base for inding the cells.
		if (debug) {
      var first:Boolean = true;
			for each (cell in grid) {
				compWraps = cell.compWraps;
				for (i = 0, iSz = compWraps.length; i < iSz; i++) {
					cw = compWraps[i];
          var hGrp:LinkedDimGroup = getGroupContaining(colGroupLists, cw);
          var vGrp:LinkedDimGroup = getGroupContaining(rowGroupLists, cw);
          if (hGrp != null && vGrp != null) {
            container.paintDebugCell(hGrp.lStart + x - (hGrp.fromEnd ? hGrp.lSize : 0), vGrp.lStart + y - (vGrp.fromEnd ? vGrp.lSize : 0), hGrp.lSize, vGrp.lSize, first);
            first = false;
          }
        }
			}
		}

		return layoutAgain;
	}

  public function getContainer():ContainerWrapper {
    return container;
  }

  public function get width():Vector.<int> {
    checkSizeCalcs();
    return _width;
  }

  public function get height():Vector.<int> {
    checkSizeCalcs();
    return _height;
  }

  private function checkSizeCalcs():void {
    if (colFlowSpecs == null) {
      colFlowSpecs = calcRowsOrColsSizes(true);
      rowFlowSpecs = calcRowsOrColsSizes(false);

      _width = getMinPrefMaxSumSize(true);
      _height = getMinPrefMaxSumSize(false);

      if (linkTargetIDs == null) {
        resetLinkValues(false, true);
      }
      else {
        // This call makes some components flicker on SWT. They get their bounds changed twice since
        // the change might affect the absolute size adjustment below. There's no way around this that
        // I know of.
        // develar: commented, don't know if we need it
        //layout(new Vector.<int>(4, true), null, null, false, false);
        resetLinkValues(false, false);
      }

      adjustSizeForAbsolute(true);
      adjustSizeForAbsolute(false);
    }
  }

  private function getPos(cw:ComponentWrapper, cc:CC):Vector.<UnitValue> {
    var cbPos:Vector.<UnitValue> = null;
    var i:int;
    if (callbackList != null) {
      for (i = 0; i < callbackList.length && cbPos == null; i++) {
        cbPos = callbackList[i].getPosition(cw);
      } // NOT a copy!
    }

    // If one is null, return the other (which many also be null)
    var ccPos:Vector.<UnitValue> = cc.pos;
    if (cbPos == null || ccPos == null) {
      return cbPos != null ? cbPos : ccPos == null ? null : ccPos.slice(); // A copy must be
    }

    var cbUv:UnitValue;
    // Merge
    for (i = 0; i < 4; i++) {
      if ((cbUv = cbPos[i]) != null) {
        ccPos[i] = cbUv;
      }
    }

    return ccPos;
  }

  private function getCallbackSize(cw:ComponentWrapper):Vector.<BoundSize> {
    if (callbackList != null) {
      var bs:Vector.<BoundSize>;
      for each (var callback:LayoutCallback in callbackList) {
        // NOT a copy!
        if ((bs = callback.getSize(cw)) != null) {
          return bs;
        }
      }
    }
    return null;
  }

  private static function getDockInsets(set2:Array/*TreeSet<Integer>*/):int {
    var c:int = 0;
    for (var i:Object in set2) {
      if (i < -MAX_GRID) {
        c++;
      }
      else {
        break;  // Since they are sorted we can break
      }
    }
    return c;
  }

	/**
	 * @param cw Never <code>null</code>.
	 * @param cc Never <code>null</code>.
	 * @param external The bounds should be stored even if they are not in {@link #linkTargetIDs}.
	 * @return If a change has been made.
	 */
	private function setLinkedBounds(cw:ComponentWrapper, cc:CC, x:int, y:int, w:int, h:int, external:Boolean):Boolean {
    var id:String = cc.id != null ? cc.id : cw.linkId;
    if (id == null) {
      return false;
    }

    var gid:String = null;
    var grIx:int = id.indexOf('.');
    if (grIx != -1) {
      gid = id.substring(0, grIx);
      id = id.substring(grIx + 1);
    }

    var lay:Object = container.getLayout();
    var changed:Boolean = false;
    if (external || (linkTargetIDs != null && id in linkTargetIDs)) {
      changed = LinkHandler.setBounds2(lay, id, x, y, w, h, !external, false);
    }

    if (gid != null && (external || (linkTargetIDs != null && gid in linkTargetIDs))) {
      if (linkTargetIDs == null) {
        linkTargetIDs = new Dictionary();
      }

      linkTargetIDs[gid] = true;
      changed ||= LinkHandler.setBounds2(lay, gid, x, y, w, h, !external, true);
    }

    return changed;
  }

	/** Go to next cell.
	 * @param p The point to increase
	 * @param cnt How many cells to advance.
	 * @return The new value in the "incresing" dimension.
	 */
  private function increase(p:Vector.<int>, cnt:int):int {
    return lc.flowX ? (p[0] += cnt) : (p[1] += cnt);
  }

  /** Wraps to the next row or column depending on if horizontal flow or vertical flow is used.
   * @param cellXY The point to wrap and thus set either x or y to 0 and increase the other one.
   * @param gapSize The gaps size specified in a "wrap XXX" or "newline XXX" or <code>null</code> if none.
   */
  private function wrap(cellXY:Vector.<int>, gapSize:BoundSize):void {
    var flowx:Boolean = lc.flowX;
    cellXY[0] = flowx ? 0 : cellXY[0] + 1;
    cellXY[1] = flowx ? cellXY[1] + 1 : 0;

    if (gapSize != null) {
      if (wrapGapMap == null) {
        wrapGapMap = [];
      }

      wrapGapMap[cellXY[flowx ? 1 : 0]] = gapSize;
    }

    // add the row/column so that the gap in the last row/col will not be removed.
    if (flowx) {
      rowIndexes[cellXY[1]] = true;
    }
    else {
      colIndexes[cellXY[0]] = true;
    }
  }

	/** Sort components (normally buttons in a button bar) so they appear in the correct order.
	 * @param cells The cells to sort.
	 * @param parent The parent.
	 */
	private static function sortCellsByPlatform(cells:Vector.<Cell>, parent:ContainerWrapper):void {
		var order:String = PlatformDefaults.buttonOrder;
    var orderLo:String = order.toLowerCase();

    var unrelSize:int = PlatformDefaults.convertToPixels(1, "u", true, 0, parent, null);
    if (unrelSize == UnitConverter.UNABLE) {
      throw new ArgumentError("'unrelated' not recognized by PlatformDefaults!");
    }

		var gapUnrel:Vector.<int> = new <int>[unrelSize, unrelSize, LayoutUtil.NOT_SET];
		var flGap:Vector.<int> = new <int>[0, 0, LayoutUtil.NOT_SET];

    var cw:CompWrap;
    var j:int;
    for each (var cell:Cell in cells) {
      if (!cell.hasTagged) {
        continue;
      }

			var prevCW:CompWrap = null;
      var nextUnrel:Boolean = false;
      var nextPush:Boolean = false;
			var sortedList:Vector.<CompWrap> = new Vector.<CompWrap>(cell.compWraps.length);
      var sortedListLength:int = 0;
			for (var i:int = 0, iSz:int = orderLo.length; i < iSz; i++) {
				var c:int = orderLo.charCodeAt(i);
        if (c == 43 || c == 95) {
          nextUnrel = true;
          if (c == 43) {
            nextPush = true;
          }
        }
        else {
					var tag:String= PlatformDefaults.getTagForChar(c);
					if (tag != null) {
            var jSz:int = cell.compWraps.length;
						for (j = 0; j < jSz; j++) {
							cw = cell.compWraps[j];
							if (tag == cw.cc.tag) {
								if (order.charCodeAt(i) >= 91 && order.charCodeAt(i) <= 90) {
                  var min:int = PlatformDefaults.minimumButtonWidth.getPixels(0, parent, cw.comp);
                  if (min > cw.horSizes[LayoutUtil.MIN]) {
                    cw.horSizes[LayoutUtil.MIN] = min;
                  }

                  correctMinMax(cw.horSizes);
								}

								sortedList[sortedListLength++] = cw;

								if (nextUnrel) {
									(prevCW != null ? prevCW : cw).mergeGapSizes(gapUnrel, cell.flowx, prevCW == null);
									if (nextPush) {
										cw.forcedPushGaps = 1;
										nextUnrel = false;
										nextPush = false;
									}
								}

                // "unknown" components will always get an Unrelated gap.
                if (c == 117) {
                  nextUnrel = true;
                }
                prevCW = cw;
              }
            }
					}
				}
			}

			// If we have a gap that was supposed to push but no more components was found to but the "gap before" then compensate.
      if (sortedListLength > 0) {
        cw = sortedList[sortedListLength - 1];
        if (nextUnrel) {
          cw.mergeGapSizes(gapUnrel, cell.flowx, false);
          if (nextPush) {
            cw.forcedPushGaps |= 2;
          }
        }

        // Remove first and last gap if not set explicitly.
        if (cw.cc.horizontal.gapAfter == null) {
          cw.setGaps(flGap, 3);
        }

        cw = sortedList[0];
        if (cw.cc.horizontal.gapBefore == null) {
          cw.setGaps(flGap, 1);
        }
      }

      // Exchange the unsorted CompWraps for the sorted one.
      var cellCompWraps:Vector.<CompWrap> = cell.compWraps;
      var n:int;
      if (cellCompWraps.length == sortedListLength) {
        cellCompWraps.length = 0;
        i = 0;
        n = sortedListLength;
      }
      else {
        var cellCompWrapsNewLength:int = 0;
        for each (var compWrap:CompWrap in cellCompWraps) {
          if (sortedList.indexOf(compWrap) == -1) {
            cellCompWraps[cellCompWrapsNewLength++] = compWrap;
          }
        }
        i = cellCompWrapsNewLength;
        n = cellCompWraps.length = cellCompWrapsNewLength + sortedListLength;
      }
      
      for (j = 0; i < n; i++, j++) {
        cellCompWraps[i] = sortedList[j];
      }
    }
  }

  private function getDefaultPushWeights(isRows:Boolean):Vector.<Number> {
    var groupLists:Vector.<Vector.<LinkedDimGroup>> = isRows ? rowGroupLists : colGroupLists;
    var pushWeightArr:Vector.<Number> = GROW_100;  // Only create specific if any of the components have grow.
    for (var i:int = 0, ix:int = 1; i < groupLists.length; i++, ix += 2) {
      var grps:Vector.<LinkedDimGroup> = groupLists[i];
      var rowPushWeight:Number = NaN;
      for each (var grp:LinkedDimGroup in grps) {
        for (var c:int = 0; c < grp._compWraps.length; c++) {
          var cw:CompWrap = grp._compWraps[c];
          var hideMode:int = cw.comp.visible ? -1 : cw.cc.hideMode != -1 ? cw.cc.hideMode : lc.hideMode;

          var pushWeight:Number = hideMode < 2 ? (isRows ? cw.cc.pushY : cw.cc.pushX) : NaN;
          if (rowPushWeight != rowPushWeight || (pushWeight == pushWeight && pushWeight > rowPushWeight)) {
            rowPushWeight = pushWeight;
          }
        }
      }

      if (rowPushWeight == rowPushWeight) {
        if (pushWeightArr == GROW_100) {
          pushWeightArr = new Vector.<Number>((groupLists.length << 1) + 1, true);
        }
        pushWeightArr[ix] = rowPushWeight;
      }
    }

    return pushWeightArr;
  }

  private function clearGroupLinkBounds():void {
    if (linkTargetIDs == null) {
      return;
    }

    for (var key:String in linkTargetIDs) {
      if (linkTargetIDs[key]) {
        LinkHandler.clearBounds(container.getLayout(), key);
      }
    }
  }

  private function resetLinkValues(parentSize:Boolean, compLinks:Boolean):void {
    var lay:Object = container.getLayout();
    if (compLinks) {
      LinkHandler.clearTemporaryBounds(lay);
    }

    var defIns:Boolean = !hasDocks();

    var parW:int = parentSize ? lc.width.constrain(container.actualWidth, getParentSize(container, true), container) : 0;
    var parH:int = parentSize ? lc.height.constrain(container.actualHeight, getParentSize(container, false), container) : 0;

    var insX:int = LayoutUtil.getInsets(lc, 0, defIns).getPixels(0, container, null);
    var insY:int = LayoutUtil.getInsets(lc, 1, defIns).getPixels(0, container, null);
    var visW:int = parW - insX - LayoutUtil.getInsets(lc, 2, defIns).getPixels(0, container, null);
    var visH:int = parH - insY - LayoutUtil.getInsets(lc, 3, defIns).getPixels(0, container, null);

    LinkHandler.setBounds2(lay, "visual", insX, insY, visW, visH, true, false);
		LinkHandler.setBounds2(lay, "container", 0, 0, parW, parH, true, false);
	}

	/** Returns the {@link net.miginfocom.layout.LinkedDimGroup} that has the {@link net.miginfocom.layout.CompWrap}
	 * <code>cw</code>.
	 * @param groupLists The lists to search in.
	 * @param cw The component wrap to find.
	 * @return The linked group or <code>null</code> if none had the component wrap.
	 */
  private static function getGroupContaining(groupLists:Vector.<Vector.<LinkedDimGroup>>, cw:CompWrap):LinkedDimGroup {
    //noinspection JSMismatchedCollectionQueryUpdate
    for each (var groups:Vector.<LinkedDimGroup> in groupLists) {
      for (var j:int = 0, jSz:int = groups.length; j < jSz; j++) {
        var cwList:Vector.<CompWrap> = groups[j]._compWraps;
        for (var k:int = 0, kSz:int = cwList.length; k < kSz; k++) {
          if (cwList[k] == cw) {
            return groups[j];
          }
        }
      }
    }
    return null;
  }

  private function doAbsoluteCorrections(cw:CompWrap, w:int, h:int):Boolean {
    var changed:Boolean = false;
    var stSz:Vector.<int> = getAbsoluteDimBounds(cw, w, true);
    if (stSz != null) {
      cw.setDimBounds(stSz[0], stSz[1], true);
    }

    stSz = getAbsoluteDimBounds(cw, h, false);
    if (stSz != null) {
      cw.setDimBounds(stSz[0], stSz[1], false);
    }

    // If there is a link id, store the new bounds.
    if (linkTargetIDs != null) {
      changed = setLinkedBounds(cw.comp, cw.cc, cw.x, cw.y, cw.w, cw.h, false);
    }

    return changed;
  }

  private function adjustSizeForAbsolute(isHor:Boolean):void {
    var curSizes:Vector.<int> = isHor ? _width : _height;

    var absCell:Cell = grid[null];
    if (absCell == null || absCell.compWraps.length == 0) {
      return;
    }

    var cws:Vector.<CompWrap> = absCell.compWraps;

    var maxEnd:int = 0;
    for (var j:int = 0, cwSz:int = absCell.compWraps.length; j < cwSz + 3; j++) {  // "Do Again" max absCell.compWraps.size() + 3 times.
      var doAgain:Boolean = false;
      for (var i:int = 0; i < cwSz; i++) {
        var cw:CompWrap = cws[i];
        var stSz:Vector.<int> = getAbsoluteDimBounds(cw, 0, isHor);
        var end:int = stSz[0] + stSz[1];
        if (maxEnd < end) {
          maxEnd = end;
        }

        // If there is a link id, store the new bounds.
        if (linkTargetIDs != null) {
          doAgain ||= setLinkedBounds(cw.comp, cw.cc, stSz[0], stSz[0], stSz[1], stSz[1], false);
        }
      }
      if (!doAgain) {
        break;
      }

      // We need to check this again since the coords may be smaller this round.
      maxEnd = 0;
      clearGroupLinkBounds();
    }

    maxEnd += LayoutUtil.getInsets(lc, isHor ? 3 : 2, !hasDocks()).getPixels(0, container, null);

    if (curSizes[LayoutUtil.MIN] < maxEnd) {
      curSizes[LayoutUtil.MIN] = maxEnd;
    }
    if (curSizes[LayoutUtil.PREF] < maxEnd) {
      curSizes[LayoutUtil.PREF] = maxEnd;
    }
  }

  private function getAbsoluteDimBounds(cw:CompWrap, refSize:int, isHor:Boolean):Vector.<int> {
    if (cw.cc.external) {
      if (isHor) {
        return new <int>[cw.comp.x, cw.comp.actualWidth];
      }
      else {
        return new <int>[cw.comp.y, cw.comp.actualHeight];
      }
    }

    var plafPad:Vector.<Number> = lc.visualPadding ? cw.comp.visualPadding : null;
    var pad:Vector.<UnitValue> = cw.cc.padding;

    // If no changes do not create a lot of objects
    if (cw.pos == null && plafPad == null && pad == null) {
      return null;
    }

    // Set start
    var st:int = isHor ? cw.x : cw.y;
    var sz:int = isHor ? cw.w : cw.h;

    // If absolute, use those coordinates instead.
    if (cw.pos != null) {
      var stUV:UnitValue = cw.pos != null ? cw.pos[isHor ? 0 : 1] : null;
      var endUV:UnitValue = cw.pos != null ? cw.pos[isHor ? 2 : 3] : null;

      var minSz:int = cw.getSize(LayoutUtil.MIN, isHor);
      var maxSz:int = cw.getSize(LayoutUtil.MAX, isHor);
      sz = Math.min(Math.max(cw.getSize(LayoutUtil.PREF, isHor), minSz), maxSz);

      if (stUV != null) {
        st = stUV.getPixels(stUV.unit == UnitValue.ALIGN ? sz : refSize, container, cw.comp);

        if (endUV != null)  // if (endUV == null && cw.cc.isBoundsIsGrid() == true)
        {
          sz = Math.min(Math.max((isHor ? (cw.x + cw.w) : (cw.y + cw.h)) - st, minSz), maxSz);
        }
      }

      if (endUV != null) {
        if (stUV != null) {   // if (stUV != null || cw.cc.isBoundsIsGrid()) {
          sz = Math.min(Math.max(endUV.getPixels(refSize, container, cw.comp) - st, minSz), maxSz);
        }
        else {
          st = endUV.getPixels(refSize, container, cw.comp) - sz;
        }
      }
    }

    var p:int;
    // If constraint has padding -> correct the start/size
    if (pad != null) {
      var uv:UnitValue = pad[isHor ? 1 : 0];
      p = uv != null ? uv.getPixels(refSize, container, cw.comp) : 0;
      st += p;
      uv = pad[isHor ? 3 : 2];
      sz += -p + (uv != null ? uv.getPixels(refSize, container, cw.comp) : 0);
    }

    // If the plaf converter has padding -> correct the start/size
    if (plafPad != null) {
      p = plafPad[isHor ? 1 : 0];
      st += p;
      sz += -p + (plafPad[isHor ? 3 : 2]);
    }

    return new <int>[st, sz];
  }

  private function layoutInOneDim(refSize:int, align:UnitValue, isRows:Boolean, defaultPushWeights:Vector.<Number>):void {
    var fromEnd:Boolean = !(isRows ? lc.topToBottom : LayoutUtil.isLeftToRight(lc, container));
    var primDCs:Vector.<CellConstraint> = isRows ? rowConstr : colConstr;
    var fss:FlowSizeSpec = isRows ? rowFlowSpecs : colFlowSpecs;
    var rowCols:Vector.<Vector.<LinkedDimGroup>> = isRows ? rowGroupLists : colGroupLists;

    var rowColSizes:Vector.<int> = LayoutUtil.calculateSerial(fss.sizes, fss.resConstsInclGaps, defaultPushWeights, LayoutUtil.PREF, refSize);
    var i:int;
    if (LayoutUtil.isDesignTime(container)) {
      var indexes:Array = isRows ? rowIndexes : colIndexes;
      var ixArr:Vector.<int> = new Vector.<int>(indexes.length, true);
      var ix:int = 0;
      for (var adobeBurnInHell:Object in indexes) {
        ixArr[ix++] = int(adobeBurnInHell);
      }

      putSizesAndIndexes(container.component, rowColSizes, ixArr, isRows);
    }

    var curPos:int = align != null ? align.getPixels(refSize - LayoutUtil.sum(rowColSizes, 0, rowColSizes.length), container, null) : 0;
    if (fromEnd) {
      curPos = refSize - curPos;
    }

    for (i = 0; i < rowCols.length; i++) {
      var linkedGroups:Vector.<LinkedDimGroup> = rowCols[i];
      var scIx:int = i - (isRows ? dockOffY : dockOffX);

      var bIx:int = i << 1;
      var bIx2:int = bIx + 1;

      curPos += (fromEnd ? -rowColSizes[bIx] : rowColSizes[bIx]);

      var primDC:CellConstraint = scIx >= 0 ? primDCs == null || primDCs.length == 0 ? DEF_DIM_C : primDCs[scIx >= primDCs.length ? primDCs.length - 1 : scIx] : DOCK_DIM_CONSTRAINT;
      var rowSize:int = rowColSizes[bIx2];
      for each (var group:LinkedDimGroup in linkedGroups) {
        var groupSize:int = rowSize;
        if (group.span > 1) {
          groupSize = LayoutUtil.sum(rowColSizes, bIx2, Math.min((group.span << 1) - 1, rowColSizes.length - bIx2 - 1));
        }

        group.layout(primDC, curPos, groupSize, group.span, container);
      }

      curPos += (fromEnd ? -rowSize : rowSize);
    }
  }

  private static function addToSizeGroup(sizeGroups:Dictionary, sizeGroup:String, size:Vector.<int>):Boolean {
    var sgSize:Vector.<int> = sizeGroups[sizeGroup];
    if (sgSize == null) {
      sizeGroups[sizeGroup] = new <int>[size[LayoutUtil.MIN], size[LayoutUtil.PREF], size[LayoutUtil.MAX]];
      return true;
    }
    else {
      sgSize[LayoutUtil.MIN] = Math.max(size[LayoutUtil.MIN], sgSize[LayoutUtil.MIN]);
      sgSize[LayoutUtil.PREF] = Math.max(size[LayoutUtil.PREF], sgSize[LayoutUtil.PREF]);
      sgSize[LayoutUtil.MAX] = Math.min(size[LayoutUtil.MAX], sgSize[LayoutUtil.MAX]);
      return false;
    }
  }

  private static function addToEndGroup(endGroups:Dictionary, endGroup:String, end:int):Dictionary {
    if (endGroup != null) {
      if (endGroups == null) {
        endGroups = new Dictionary();
      }

      var oldEnd:* = endGroups[endGroup];
      if (oldEnd == undefined || end > oldEnd) {
        endGroups[endGroup] = end;
      }
    }
    return endGroups;
  }

	/** Calculates Min, Preferred and Max size for the columns OR rows.
	 * @param isHor If it is the horizontal dimension to calculate.
	 * @return The sizes in a {@link net.miginfocom.layout.FlowSizeSpec}.
	 */
	private function calcRowsOrColsSizes(isHor:Boolean):FlowSizeSpec {
    var groupsLists:Vector.<Vector.<LinkedDimGroup>> = isHor ? colGroupLists : rowGroupLists;
    var defPush:Vector.<Number> = isHor ? pushXs : pushYs;
    var refSize:int = isHor ? container.actualWidth : container.actualHeight;

    var cSz:BoundSize = isHor ? lc.width : lc.height;
    if (!cSz.isUnset) {
      refSize = cSz.constrain(refSize, getParentSize(container, isHor), container);
    }

		var primDCs:Vector.<CellConstraint> = isHor ? colConstr : rowConstr;
		var primIndexes:Array = isHor ? colIndexes : rowIndexes;
		var rowColBoundSizes:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(primIndexes.length, true);
		//HashMap<String, int[]> sizeGroupMap = new HashMap<String, int[]>(2);
		var sizeGroupMap:Dictionary = new Dictionary();
    var sizeGroupMapSize:int = 0;
		var allDCs:Vector.<CellConstraint> = new Vector.<CellConstraint>(primIndexes.length, true);
    var r:int = 0;
		for (var adobeBurnInHell:Object in primIndexes) {
      var cellIx:int = int(adobeBurnInHell);
      var rowColSizes:Vector.<int> = new Vector.<int>(3, true);
      if (cellIx >= -MAX_GRID && cellIx <= MAX_GRID) {  // If not dock cell
        allDCs[r] = primDCs == null || primDCs.length == 0 ? DEF_DIM_C : primDCs[cellIx >= primDCs.length ? primDCs.length - 1 : cellIx];
      }
      else {
        allDCs[r] = DOCK_DIM_CONSTRAINT;
      }

      var groups:Vector.<LinkedDimGroup> = groupsLists[r];
      var groupSizes:Vector.<int> = new <int>[
        getTotalGroupsSizeParallel(groups, LayoutUtil.MIN, false),
        getTotalGroupsSizeParallel(groups, LayoutUtil.PREF, false),
        LayoutUtil.INF];

			correctMinMax(groupSizes);
			var dimSize:BoundSize = allDCs[r].size;
			for (var sType:int = LayoutUtil.MIN; sType <= LayoutUtil.MAX; sType++) {
        var rowColSize:int = groupSizes[sType];
        var uv:UnitValue = dimSize.getSize(sType);
				if (uv != null) {
          // If the size of the column is a link to some other size, use that instead
          var unit:int = uv.unit;
          if (unit == UnitValue.PREF_SIZE) {
            rowColSize = groupSizes[LayoutUtil.PREF];
          }
          else if (unit == UnitValue.MIN_SIZE) {
            rowColSize = groupSizes[LayoutUtil.MIN];
          }
          else if (unit == UnitValue.MAX_SIZE) {
            rowColSize = groupSizes[LayoutUtil.MAX];
          }
          else {
            rowColSize = uv.getPixels(refSize, container, null);
          }
				}
        else if (cellIx >= -MAX_GRID && cellIx <= MAX_GRID && rowColSize == 0) {
					rowColSize = LayoutUtil.isDesignTime(container) ? LayoutUtil.designTimeEmptySize : 0;    // Empty rows with no size set gets XX pixels if design time
				}

				rowColSizes[sType] = rowColSize;
			}

			correctMinMax(rowColSizes);
			if (addToSizeGroup(sizeGroupMap, allDCs[r].sizeGroup, rowColSizes)) {
        sizeGroupMapSize++;
      }

			rowColBoundSizes[r] = rowColSizes;

      r++;
		}

		// Set/equalize the size groups to same the values.
    if (sizeGroupMapSize > 0) {
      for (r = 0; r < rowColBoundSizes.length; r++) {
        if (allDCs[r].sizeGroup != null) {
          rowColBoundSizes[r] = sizeGroupMap[allDCs[r].sizeGroup];
        }
      }
    }

		// Add the gaps
    var resConstrs:Vector.<ResizeConstraint> = getRowResizeConstraints(allDCs);
    var fillInPushGaps:Vector.<Boolean> = new Vector.<Boolean>(allDCs.length + 1, true);
    var gapSizes:Vector.<Vector.<int>> = getRowGaps(allDCs, refSize, isHor, fillInPushGaps);
    var fss:FlowSizeSpec = mergeSizesGapsAndResConstrs(resConstrs, fillInPushGaps, rowColBoundSizes, gapSizes);
    // Spanning components are not handled yet. Check and adjust the multi-row min/pref they enforce.
    adjustMinPrefForSpanningComps(allDCs, defPush, fss, groupsLists);
    return fss;
	}

	private static function getParentSize(cw:ContainerWrapper, isHor:Boolean):int {
		return cw.hasParent ? (isHor ? cw.actualWidth : cw.actualHeight) : 0;
	}

  private function getMinPrefMaxSumSize(isHor:Boolean):Vector.<int> {
    var sizes:Vector.<Vector.<int>> = isHor ? colFlowSpecs.sizes : rowFlowSpecs.sizes;
    var retSizes:Vector.<int> = new Vector.<int>(3, true);
    var sz:BoundSize = isHor ? lc.width : lc.height;
    for (var i:int = 0; i < sizes.length; i++) {
      if (sizes[i] != null) {
        var size:Vector.<int> = sizes[i];
        for (var sType:int = LayoutUtil.MIN; sType <= LayoutUtil.MAX; sType++) {
          if (sz.getSize(sType) != null) {
            if (i == 0) {
              retSizes[sType] = sz.getSize(sType).getPixels(getParentSize(container, isHor), container, null);
            }
          }
          else {
            var s:int = size[sType];
            if (s != LayoutUtil.NOT_SET) {
              if (sType == LayoutUtil.PREF) {
                var bnd:int = size[LayoutUtil.MAX];
                if (bnd != LayoutUtil.NOT_SET && bnd < s) {
                  s = bnd;
                }

                bnd = size[LayoutUtil.MIN];
                // Includes s == LayoutUtil.NOT_SET since < 0.
                if (bnd > s) {
                  s = bnd;
                }
              }

              retSizes[sType] += s;   // MAX compensated below.
            }

            // So that MAX is always correct.
            if (size[LayoutUtil.MAX] == LayoutUtil.NOT_SET || retSizes[LayoutUtil.MAX] > LayoutUtil.INF) {
              retSizes[LayoutUtil.MAX] = LayoutUtil.INF;
            }
          }
        }
      }
    }

    correctMinMax(retSizes);
		return retSizes;
	}

  private static function getRowResizeConstraints(constraints:Vector.<CellConstraint>):Vector.<ResizeConstraint> {
    var resConsts:Vector.<ResizeConstraint> = new Vector.<ResizeConstraint>(constraints.length, true);
    for (var i:int = 0; i < resConsts.length; i++) {
      resConsts[i] = constraints[i].resize;
    }
    return resConsts;
  }

  private static function getComponentResizeConstraints(compWraps:Vector.<CompWrap>, isHor:Boolean):Vector.<ResizeConstraint> {
    var resConsts:Vector.<ResizeConstraint> = new Vector.<ResizeConstraint>(compWraps.length, true);
    for (var i:int = 0; i < resConsts.length; i++) {
      var fc:CC = compWraps[i].cc;
      resConsts[i] = fc.getDimConstraint(isHor).resize;

      // Always grow docking components in the correct dimension.
      var dock:int = fc.dockSide;
      if (isHor ? (dock == 0 || dock == 2) : (dock == 1 || dock == 3)) {
        var dc:ResizeConstraint = resConsts[i];
        resConsts[i] = new ResizeConstraint(dc.shrinkPrio, dc.shrink, dc.growPrio, ResizeConstraint.WEIGHT_100);
      }
    }
    return resConsts;
  }

  private static function getComponentGapPush(compWraps:Vector.<CompWrap>, isHor:Boolean):Vector.<Boolean> {
    // Make one element bigger and or the after gap with the next before gap.
    var barr:Vector.<Boolean> = new Vector.<Boolean>(compWraps.length + 1, true);
    for (var i:int = 0; i < barr.length; i++) {
      var push:Boolean = i > 0 && compWraps[i - 1].isPushGap(isHor, false);
      if (!push && i < (barr.length - 1)) {
        push = compWraps[i].isPushGap(isHor, true);
      }

      barr[i] = push;
    }
    return barr;
  }

	/** Returns the row gaps in pixel sizes. One more than there are <code>specs</code> sent in.
	 * @param specs
	 * @param refSize
	 * @param isHor
	 * @param fillInPushGaps If the gaps are pushing. <b>NOTE!</b> this argument will be filled in and thus changed!
	 * @return The row gaps in pixel sizes. One more than there are <code>specs</code> sent in.
	 */
  private function getRowGaps(specs:Vector.<CellConstraint>, refSize:int, isHor:Boolean, fillInPushGaps:Vector.<Boolean>):Vector.<Vector.<int>> {
    var defGap:BoundSize = isHor ? lc.gridGapX : lc.gridGapY;
    if (defGap == null) {
      defGap = isHor ? PlatformDefaults.gridGapX : PlatformDefaults.gridGapY;
    }
    var defGapArr:Vector.<int> = defGap.getPixelSizes(refSize, container, null);

    var defIns:Boolean = !hasDocks();

    var firstGap:UnitValue = LayoutUtil.getInsets(lc, isHor ? 1 : 0, defIns);
    var lastGap:UnitValue = LayoutUtil.getInsets(lc, isHor ? 3 : 2, defIns);

    var retValues:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(specs.length + 1, true);

    for (var i:int = 0, wgIx:int = 0; i < retValues.length; i++) {
      var specBefore:CellConstraint = i > 0 ? specs[i - 1] : null;
      var specAfter:CellConstraint = i < specs.length ? specs[i] : null;

      // No gap if between docking components.
      var edgeBefore:Boolean = (specBefore == DOCK_DIM_CONSTRAINT || specBefore == null);
      var edgeAfter:Boolean = (specAfter == DOCK_DIM_CONSTRAINT || specAfter == null);
      if (edgeBefore && edgeAfter) {
        continue;
      }

      var wrapGapSize:BoundSize = (wrapGapMap == null || isHor == lc.flowX ? null : wrapGapMap[wgIx++]);
      if (wrapGapSize == null) {
        var gapBefore:Vector.<int> = specBefore != null ? specBefore.getRowGaps(container, null, refSize, false) : null;
        var gapAfter:Vector.<int> = specAfter != null ? specAfter.getRowGaps(container, null, refSize, true) : null;

        if (edgeBefore && gapAfter == null && firstGap != null) {
          var bef:int = firstGap.getPixels(refSize, container, null);
          retValues[i] = new <int>[bef, bef, bef];

        } else if (edgeAfter && gapBefore == null && firstGap != null) {

          var aft:int = lastGap.getPixels(refSize, container, null);
          retValues[i] = new <int>[aft, aft, aft];

        }
        else {
          retValues[i] = gapAfter != gapBefore ? mergeSizes(gapAfter, gapBefore) : new <int>[defGapArr[0], defGapArr[1], defGapArr[2]];
        }

        if (specBefore != null && specBefore.gapAfterPush || specAfter != null && specAfter.gapBeforePush) {
          fillInPushGaps[i] = true;
        }
      }
      else {
        if (wrapGapSize.isUnset) {
          retValues[i] = new <int>[defGapArr[0], defGapArr[1], defGapArr[2]];
        }
        else {
          retValues[i] = wrapGapSize.getPixelSizes(refSize, container, null);
        }
        fillInPushGaps[i] = wrapGapSize.gapPush;
      }
    }
    return retValues;
  }

  private static function getGaps(compWraps:Vector.<CompWrap>, isHor:Boolean):Vector.<Vector.<int>> {
    var compCount:int = compWraps.length;
    var retValues:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(compCount + 1);
    retValues[0] = compWraps[0].getGaps(isHor, true);
    for (var i:int = 0; i < compCount; i++) {
      var gap1:Vector.<int> = compWraps[i].getGaps(isHor, false);
      var gap2:Vector.<int> = i < compCount - 1 ? compWraps[i + 1].getGaps(isHor, true) : null;

      retValues[i + 1] = mergeSizes(gap1, gap2);
    }

    return retValues;
  }

  private function hasDocks():Boolean {
		return (dockOffX > 0|| dockOffY > 0|| rowIndexes[rowIndexes.length - 1] > MAX_GRID || colIndexes[colIndexes.length - 1] > MAX_GRID);
	}

	/** Adjust min/pref size for columns(or rows) that has components that spans multiple columns (or rows).
	 * @param specs The specs for the columns or rows. Last index will be used if <code>count</code> is greater than this array's length.
	 * @param defPush The default grow weight if the specs does not have anyone that will grow. Comes from "push" in the CC.
	 * @param fss
	 * @param groupsLists
	 */
  private static function adjustMinPrefForSpanningComps(specs:Vector.<CellConstraint>, defPush:Vector.<Number>, fss:FlowSizeSpec, groupsLists:Vector.<Vector.<LinkedDimGroup>>):void {
    // Since 3.7.3 Iterate from end to start. Will solve some multiple spanning components hard to solve problems.
    for (var r:int = groupsLists.length - 1; r >= 0; r--) {
      for  each (var group:LinkedDimGroup in groupsLists[r]) {
        if (group.span == 1) {
          continue;
        }

        var sizes:Vector.<int> = group.getMinPrefMax();
        for (var s:int = LayoutUtil.MIN; s <= LayoutUtil.PREF; s++) {
          var cSize:int = sizes[s];
          if (cSize == LayoutUtil.NOT_SET) {
            continue;
          }

          var rowSize:int = 0;
          var sIx:int = (r << 1) + 1;
          var len:int = Math.min((group.span << 1), fss.sizes.length - sIx) - 1;
          for (var j:int = sIx; j < sIx + len; j++) {
            var sz:int = fss.sizes[j][s];
            if (sz != LayoutUtil.NOT_SET) {
              rowSize += sz;
            }
          }

          if (rowSize < cSize && len > 0) {
            for (var eagerness:int = 0, newRowSize:int = 0; eagerness < 4 && newRowSize < cSize; eagerness++) {
              newRowSize = fss.expandSizes(specs, defPush, cSize, sIx, len, s, eagerness);
            }
          }
        }
      }
    }
  }

	/** For one dimension divide the component wraps into logical groups. One group for component wraps that share a common something,
	 * line the property to layout by base line.
	 * @param isRows If rows, and not columns, are to be divided.
	 * @return One <code>ArrayList<LinkedDimGroup></code> for every row/column.
	 */
  private function divideIntoLinkedGroups(isRows:Boolean):Vector.<Vector.<LinkedDimGroup>> {
    var fromEnd:Boolean = !(isRows ? lc.topToBottom : LayoutUtil.isLeftToRight(lc, container));
    var primIndexes:Array = isRows ? rowIndexes : colIndexes;
    var secIndexes:Array = isRows ? colIndexes : rowIndexes;
    var primDCs:Vector.<CellConstraint> = isRows ? rowConstr : colConstr;
    var groupLists:Vector.<Vector.<LinkedDimGroup>> = new Vector.<Vector.<LinkedDimGroup>>(primIndexes.length, true);
    var gIx:int = 0;
    var adobeBurnInHell:Object;
    for (adobeBurnInHell in primIndexes) {
      var i:int = int(adobeBurnInHell);
      var dc:CellConstraint;
      if (i >= -MAX_GRID && i <= MAX_GRID) {  // If not dock cell
        dc = primDCs == null || primDCs.length == 0 ? DEF_DIM_C : primDCs[i >= primDCs.length ? primDCs.length - 1 : i];
      }
      else {
        dc = DOCK_DIM_CONSTRAINT;
      }

      var groupList:Vector.<LinkedDimGroup> = new Vector.<LinkedDimGroup>();
      var groupListLength:int = 0;
      groupLists[gIx++] = groupList;
      for (adobeBurnInHell in secIndexes) {
        var ix:int = int(adobeBurnInHell);
        var cell:Cell = isRows ? getCell(i, ix) : getCell(ix, i);
        if (cell == null || cell.compWraps.length == 0) {
          continue;
        }

        var span:int = (isRows ? cell.spany : cell.spanx);
        if (span > 1) {
          span = convertSpanToSparseGrid(i, span, primIndexes);
        }

        var isPar:Boolean = cell.flowx == isRows;
        if ((!isPar && cell.compWraps.length > 1) || span > 1) {
          groupList[groupListLength++] = new LinkedDimGroup("p," + ix, span, isPar ? LinkedDimGroup.TYPE_PARALLEL : LinkedDimGroup.TYPE_SERIAL, !isRows, fromEnd, cell.compWraps);
        }
        else {
          for (var cwIx:int = 0; cwIx < cell.compWraps.length; cwIx++) {
            var cw:CompWrap = cell.compWraps[cwIx];
            var rowBaselineAlign:Boolean = (isRows && lc.topToBottom && dc.getAlignOrDefault(!isRows) == UnitValue.BASELINE_IDENTITY); // Disable baseline for bottomToTop since I can not verify it working.
            var isBaseline:Boolean = isRows && cw.isBaselineAlign(rowBaselineAlign);
            var linkCtx:String = isBaseline ? "baseline" : null;
            // Find a group with same link context and put it in that group.
            var foundList:Boolean = false;
            for (var glIx:int = 0, lastGl:int = groupList.length - 1; glIx <= lastGl; glIx++) {
              var group:LinkedDimGroup = groupList[glIx];
              if (group.linkCtx == linkCtx) {
                group.addCompWrap(cw);
                foundList = true;
                break;
              }
            }

            // If none found and at last add a new group.
            if (!foundList) {
              var cws:Vector.<CompWrap> = new Vector.<CompWrap>(1);
              cws[0] = cw;
              groupList[groupListLength++] = new LinkedDimGroup(linkCtx, 1, isBaseline ? LinkedDimGroup.TYPE_BASELINE : LinkedDimGroup.TYPE_PARALLEL, !isRows, fromEnd, cws);
            }
          }
        }
      }
    }

    return groupLists;
  }

	/** Spanning is specified in the uncompressed grid number. They can for instance be more than 60000 for the outer
	 * edge dock grid cells. When the grid is compressed and indexed after only the cells that area occupied the span
	 * is erratic. This method use the row/col indexes and corrects the span to be correct for the compressed grid.
	 * @param span The span un the uncompressed grid. <code>LayoutUtil.INF</code> will be interpreted to span the rest
	 * of the column/row excluding the surrounding docking components.
	 * @param indexes The indexes in the correct dimension.
	 * @return The converted span.
	 */
  private static function convertSpanToSparseGrid(curIx:int, span:int, indexes:Array):int {
    var lastIx:int = curIx + span;
    var retSpan:int = 1;
    for (var ix:Object in indexes) {
      if (ix <= curIx) {
        continue;
      }   // We have not arrived to the correct index yet

      if (ix >= lastIx) {
        break;
      }

      retSpan++;
    }
    return retSpan;
	}

	private function isCellFree(r:int, c:int, occupiedRects:Vector.<Vector.<int>>):Boolean {
    if (getCell(r, c) != null) {
      return false;
    }

    for each (var rect:Vector.<int> in occupiedRects) {
      if (rect[0] <= c && rect[1] <= r && rect[0] + rect[2] > c && rect[1] + rect[3] > r) {
        return false;
      }
    }
    
    return true;
	}

	private function getCell(r:int, c:int):Cell {
		return grid[(r << 16) + c];
	}

  private function setCell(r:int, c:int, cell:Cell):void {
    if (c < 0 || r < 0) {
      throw new ArgumentError("Cell position cannot be negative. row: " + r + ", col: " + c);
    }

    if (c > MAX_GRID || r > MAX_GRID) {
      throw new ArgumentError("Cell position out of bounds. Out of cells. row: " + r + ", col: " + c);
    }

    rowIndexes[r] = true;
    colIndexes[c] = true;

    grid[(r << 16) + c] = cell;
  }

	/** Adds a docking cell. That cell is outside the normal cell indexes.
	 * @param dockInsets The current dock insets. Will be updated!
	 * @param side top == 0, left == 1, bottom = 2, right = 3.
	 * @param cw The compwrap to put in a cell and add.
	 */
	private function addDockingCell(dockInsets:Vector.<int>, side:int, cw:CompWrap):void {
		var r:int, c:int, spanx:int = 1, spany:int = 1;
		switch (side) {
			case 0:
			case 2:
				r = side == 0? dockInsets[0]++ : dockInsets[2]--;
				c = dockInsets[1];
				spanx = dockInsets[3] - dockInsets[1] + 1;  // The +1 is for cell 0.
				colIndexes[dockInsets[3]] = true; // Make sure there is a receiving cell
				break;

			case 1:
			case 3:
				c = side == 1? dockInsets[1]++ : dockInsets[3]--;
				r = dockInsets[0];
				spany = dockInsets[2] - dockInsets[0] + 1;  // The +1 is for cell 0.
				rowIndexes[dockInsets[2]] = true; // Make sure there is a receiving cell
				break;

			default:
				throw new ArgumentError("Internal error 123.");
		}

		rowIndexes[r] = true;
		colIndexes[c] = true;

		grid[(r << 16) + c] = new Cell(cw, spanx, spany, spanx > 1);
	}

	//***************************************************************************************
	//* Helper Methods
	//***************************************************************************************

	internal static function layoutBaseline(parent:ContainerWrapper, compWraps:Vector.<CompWrap>, dc:CellConstraint, start:int, size:int, sizeType:int, spanCount:int):void {
		var aboveBelow:Vector.<int> = getBaselineAboveBelow(compWraps, sizeType, true);
		var blRowSize:int= aboveBelow[0] + aboveBelow[1];

    var cc:CC = compWraps[0].cc;
    // Align for the whole baseline component array
    var align:UnitValue = cc.vertical.align;
    if (spanCount == 1 && align == null) {
      align = dc.getAlignOrDefault(false);
    }
    if (align == UnitValue.BASELINE_IDENTITY) {
      align = UnitValue.CENTER;
    }

    var offset:int = start + aboveBelow[0] + (align != null ? Math.max(0, align.getPixels(size - blRowSize, parent, null)) : 0);
    for (var i:int = 0, iSz:int = compWraps.length; i < iSz; i++) {
      var cw:CompWrap = compWraps[i];
      cw.y += offset;
      if (cw.y + cw.h > start + size) {
        cw.h = start + size - cw.y;
      }
    }
	}

  internal static function layoutSerial(parent:ContainerWrapper, compWraps:Vector.<CompWrap>, dc:CellConstraint, start:int, size:int, isHor:Boolean, fromEnd:Boolean):void {
    var fss:FlowSizeSpec = mergeSizesGapsAndResConstrs(
      getComponentResizeConstraints(compWraps, isHor),
      getComponentGapPush(compWraps, isHor),
      getComponentSizes(compWraps, isHor),
      getGaps(compWraps, isHor));

		var pushW:Vector.<Number> = dc.fill ? GROW_100 : null;
		var sizes:Vector.<int> = LayoutUtil.calculateSerial(fss.sizes, fss.resConstsInclGaps, pushW, LayoutUtil.PREF, size);
		setCompWrapBounds2(parent, sizes, compWraps, dc.getAlignOrDefault(isHor),  start, size, isHor, fromEnd);
	}

	private static function setCompWrapBounds2(parent:ContainerWrapper, allSizes:Vector.<int>, compWraps:Vector.<CompWrap>, rowAlign:UnitValue, start:int, size:int, isHor:Boolean, fromEnd:Boolean):void {
    var totSize:int = LayoutUtil.sum(allSizes, 0, allSizes.length);
    var cc:CC = compWraps[0].cc;
    var align:UnitValue = correctAlign(cc, rowAlign, isHor, fromEnd);

    var cSt:int = start;
    var slack:int = size - totSize;
    if (slack > 0 && align != null) {
      var al:int = Math.min(slack, Math.max(0, align.getPixels(slack, parent, null)));
      cSt += (fromEnd ? -al : al);
    }

    for (var i:int = 0, bIx:int = 0, iSz:int = compWraps.length; i < iSz; i++) {
      var cw:CompWrap = compWraps[i];
      if (fromEnd) {
        cSt -= allSizes[bIx++];
        cw.setDimBounds(cSt - allSizes[bIx], allSizes[bIx], isHor);
        cSt -= allSizes[bIx++];
      }
      else {
        cSt += allSizes[bIx++];
        cw.setDimBounds(cSt, allSizes[bIx], isHor);
        cSt += allSizes[bIx++];
      }
    }
  }

  internal static function layoutParallel(parent:ContainerWrapper, compWraps:Vector.<CompWrap>, dc:CellConstraint, start:int, size:int, isHor:Boolean, fromEnd:Boolean):void {
    var sizes:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(compWraps.length);    // [compIx][gapBef,compSize,gapAft]
    for (var i:int = 0; i < sizes.length; i++) {
      var cw:CompWrap = compWraps[i];
      var cDc:DimConstraint = cw.cc.getDimConstraint(isHor);
      var resConstr:Vector.<ResizeConstraint> = new <ResizeConstraint>[
        cw.isPushGap(isHor, true) ? GAP_RC_CONST_PUSH : GAP_RC_CONST,
        cDc.resize,
        cw.isPushGap(isHor, false) ? GAP_RC_CONST_PUSH : GAP_RC_CONST
      ];

      var sz:Vector.<Vector.<int>> = new <Vector.<int>>[cw.getGaps(isHor, true), (isHor ? cw.horSizes : cw.verSizes), cw.getGaps(isHor, false)];
      sizes[i] = LayoutUtil.calculateSerial(sz, resConstr, dc.fill ? GROW_100 : null, LayoutUtil.PREF, size);
    }

    setCompWrapBounds(parent, sizes, compWraps, dc.getAlignOrDefault(isHor), start, size, isHor, fromEnd);
  }

	private static function setCompWrapBounds(parent:ContainerWrapper, sizes:Vector.<Vector.<int>>, compWraps:Vector.<CompWrap>, rowAlign:UnitValue, start:int, size:int, isHor:Boolean, fromEnd:Boolean):void {
    for (var i:int = 0; i < sizes.length; i++) {
      var cw:CompWrap = compWraps[i];

      var align:UnitValue = correctAlign(cw.cc, rowAlign, isHor, fromEnd);

      var cSizes:Vector.<int> = sizes[i];
      var gapBef:int = cSizes[0];
      var cSize:int = cSizes[1];  // No Math.min(size, cSizes[1]) here!
      var gapAft:int = cSizes[2];

      var cSt:int = fromEnd ? start - gapBef : start + gapBef;
      var slack:int = size - cSize - gapBef - gapAft;
      if (slack > 0 && align != null) {
        var al:int = Math.min(slack, Math.max(0, align.getPixels(slack, parent, null)));
        cSt += (fromEnd ? -al : al);
      }

      cw.setDimBounds(fromEnd ? cSt - cSize : cSt, cSize, isHor);
    }
  }

  private static function correctAlign(cc:CC, rowAlign:UnitValue, isHor:Boolean, fromEnd:Boolean):UnitValue {
    var align:UnitValue = (isHor ? cc.horizontal : cc.vertical).align || rowAlign;
    if (align == UnitValue.BASELINE_IDENTITY) {
      align = UnitValue.CENTER;
    }

    if (fromEnd) {
      if (align == UnitValue.LEFT) {
        align = UnitValue.RIGHT;
      }
      else if (align == UnitValue.RIGHT) {
        align = UnitValue.LEFT;
      }
    }
    return align;
  }

  internal static function getBaselineAboveBelow(compWraps:Vector.<CompWrap>, sType:int, centerBaseline:Boolean):Vector.<int> {
    var maxAbove:int = -32768;
    var maxBelow:int = -32768;
    for (var i:int = 0, iSz:int = compWraps.length; i < iSz; i++) {
      var cw:CompWrap = compWraps[i];
      var height:int = cw.getSize(sType, false);
      if (height >= LayoutUtil.INF) {
        return new <int>[LayoutUtil.INF / 2, LayoutUtil.INF / 2];
      }

      var baseline:int = cw.getBaseline(sType);
      var above:int = baseline + cw.getGapBefore(sType, false);
      maxAbove = Math.max(above, maxAbove);
      maxBelow = Math.max(height - baseline + cw.getGapAfter(sType, false), maxBelow);

      if (centerBaseline) {
        cw.setDimBounds(-baseline, height, false);
      }
    }
    return new <int>[maxAbove, maxBelow];
  }

  internal static function getTotalSizeParallel(compWraps:Vector.<CompWrap>, sType:int, isHor:Boolean):int {
    var size:int = sType == LayoutUtil.MAX ? LayoutUtil.INF : 0;
    for (var i:int = 0, iSz:int = compWraps.length; i < iSz; i++) {
      var cw:CompWrap = compWraps[i];
      var cwSize:int = cw.getSizeInclGaps(sType, isHor);
      if (cwSize >= LayoutUtil.INF) {
        return LayoutUtil.INF;
      }

      if (sType == LayoutUtil.MAX ? cwSize < size : cwSize > size) {
        size = cwSize;
      }
    }
    return constrainSize(size);
  }

  internal static function getTotalSizeSerial(compWraps:Vector.<CompWrap>, sType:int, isHor:Boolean):int {
    var totSize:int = 0;
    for (var i:int = 0, iSz:int = compWraps.length, lastGapAfter:int = 0; i < iSz; i++) {
      var wrap:CompWrap = compWraps[i];
      var gapBef:int = wrap.getGapBefore(sType, isHor);
      if (gapBef > lastGapAfter) {
        totSize += gapBef - lastGapAfter;
      }

      totSize += wrap.getSize(sType, isHor);
      totSize += (lastGapAfter = wrap.getGapAfter(sType, isHor));

      if (totSize >= LayoutUtil.INF) {
        return LayoutUtil.INF;
      }
    }
    return constrainSize(totSize);
  }

  private static function getTotalGroupsSizeParallel(groups:Vector.<LinkedDimGroup>, sType:int, countSpanning:Boolean):int {
    var size:int = sType == LayoutUtil.MAX ? LayoutUtil.INF : 0;
    for (var i:int = 0, iSz:int = groups.length; i < iSz; i++) {
      var group:LinkedDimGroup = groups[i];
      if (countSpanning || group.span == 1) {
        var grpSize:int = group.getMinPrefMax()[sType];
        if (grpSize >= LayoutUtil.INF) {
          return LayoutUtil.INF;
        }

        if (sType == LayoutUtil.MAX ? grpSize < size : grpSize > size) {
          size = grpSize;
        }
      }
    }
    return constrainSize(size);
  }

	/**
	 * @param compWraps
	 * @param isHor
	 * @return Might contain LayoutUtil.NOT_SET
   */
  private static function getComponentSizes(compWraps:Vector.<CompWrap>, isHor:Boolean):Vector.<Vector.<int>> {
    var compSizes:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(compWraps.length);
    for (var i:int = 0; i < compSizes.length; i++) {
      compSizes[i] = isHor ? compWraps[i].horSizes : compWraps[i].verSizes;
    }
    return compSizes;
  }

  /** Merges sizes and gaps together with Resize Constraints. For gaps {@link #GAP_RC_CONST} is used.
	 * @param resConstr One resize constriant for every row/component. Can be lesser in length and the last element should be used for missing elements.
	 * @param gapPush If the corresponding gap should be considered pushing and thus want to take free space if left over. Should be one more than resConstrs!
	 * @param minPrefMaxSizes The sizes (min/pref/max) for every row/component.
	 * @param gapSizes The gaps before and after each row/component packed in one double sized array.
	 * @return A holder for the merged values.
	 */
	private static function mergeSizesGapsAndResConstrs(resConstr:Vector.<ResizeConstraint>, gapPush:Vector.<Boolean>, minPrefMaxSizes:Vector.<Vector.<int>>, gapSizes:Vector.<Vector.<int>>):FlowSizeSpec {
    var sizes:Vector.<Vector.<int>> = new Vector.<Vector.<int>>((minPrefMaxSizes.length << 1) + 1);  // Make room for gaps around.
		var resConstsInclGaps:Vector.<ResizeConstraint> = new Vector.<ResizeConstraint>(sizes.length, true);
		sizes[0] = gapSizes[0];
    var i:int, crIx:int;
		for (i = 0, crIx = 1; i < minPrefMaxSizes.length; i++, crIx += 2) {
			// Component bounds and constraints
			resConstsInclGaps[crIx] = resConstr[i];
			sizes[crIx] = minPrefMaxSizes[i];
      sizes[crIx + 1] = gapSizes[i + 1];
      if (sizes[crIx - 1] != null) {
        resConstsInclGaps[crIx - 1] = gapPush[i < gapPush.length ? i : gapPush.length - 1] ? GAP_RC_CONST_PUSH : GAP_RC_CONST;
      }

      if (i == (minPrefMaxSizes.length - 1) && sizes[crIx + 1] != null) {
        resConstsInclGaps[crIx + 1] = gapPush[(i + 1) < gapPush.length ? (i + 1) : gapPush.length - 1] ? GAP_RC_CONST_PUSH : GAP_RC_CONST;
      }
    }

		// Check for null and set it to 0, 0, 0.
    for (i = 0; i < sizes.length; i++) {
      if (sizes[i] == null) {
        sizes[i] = new Vector.<int>(3, true);
      }
    }

		return new FlowSizeSpec(sizes, resConstsInclGaps);
	}

  private static function mergeSizes(oldValues:Vector.<int>, newValues:Vector.<int>):Vector.<int> {
    if (oldValues == null) {
      return newValues;
    }

    if (newValues == null) {
      return oldValues;
    }

    var ret:Vector.<int> = new Vector.<int>(oldValues.length, true);
    for (var i:int = 0; i < ret.length; i++) {
      ret[i] = mergeSizes2(oldValues[i], newValues[i], true);
    }

    return ret;
  }

  private static function mergeSizes2(oldValue:int, newValue:int, toMax:Boolean):int {
    if (oldValue == LayoutUtil.NOT_SET || oldValue == newValue) {
      return newValue;
    }

    if (newValue == LayoutUtil.NOT_SET) {
      return oldValue;
    }

    return toMax != oldValue > newValue ? newValue : oldValue;
  }

  internal static function constrainSize(s:int):int {
    return s > 0 ? (s < LayoutUtil.INF ? s : LayoutUtil.INF) : 0;
  }

  internal static function correctMinMax(s:Vector.<int>):void {
    if (s[LayoutUtil.MIN] > s[LayoutUtil.MAX]) {
      s[LayoutUtil.MIN] = s[LayoutUtil.MAX];
    }  // Since MAX is almost always explicitly set use that

    if (s[LayoutUtil.PREF] < s[LayoutUtil.MIN]) {
      s[LayoutUtil.PREF] = s[LayoutUtil.MIN];
    }

    if (s[LayoutUtil.PREF] > s[LayoutUtil.MAX]) {
      s[LayoutUtil.PREF] = s[LayoutUtil.MAX];
    }
  }

  internal static function extractSubArray(specs:Vector.<CellConstraint>, arr:Vector.<Number>, ix:int, len:int):Vector.<Number> {
    var i:int;
    if (arr == null || arr.length < ix + len) {
      var growLastArr:Vector.<Number> = new Vector.<Number>(len, true);
      // Handle a group where some rows (first one/few and/or last one/few) are docks.
      for (i = ix + len - 1; i >= 0; i -= 2) {
        var specIx:int = (i >> 1);
        if (specs[specIx] != DOCK_DIM_CONSTRAINT) {
          growLastArr[i - ix] = ResizeConstraint.WEIGHT_100;
          return growLastArr;
        }
      }
      return growLastArr;
    }

    var newArr:Vector.<Number> = new Vector.<Number>(len, true);
    for (i = 0; i < len; i++) {
      newArr[i] = arr[ix + i];
    }
    return newArr;
  }

	//private static WeakHashMap<Object, int[][]>[] PARENT_ROWCOL_SIZES_MAP = null;
	private static var PARENT_ROWCOL_SIZES_MAP:Vector.<Dictionary>;

  private static function putSizesAndIndexes(parComp:Object, sizes:Vector.<int>, ixArr:Vector.<int>, isRows:Boolean):void {
    // Lazy since only if designing in IDEs
    if (PARENT_ROWCOL_SIZES_MAP == null) {
      PARENT_ROWCOL_SIZES_MAP = new <Dictionary>[new Dictionary(), new Dictionary()];
    }

    PARENT_ROWCOL_SIZES_MAP[isRows ? 0 : 1][parComp] = new <Vector.<int>>[ixArr, sizes];
  }

  internal static function getSizesAndIndexes(parComp:Object, isRows:Boolean):Vector.<Vector.<int>> {
    if (PARENT_ROWCOL_SIZES_MAP == null) {
      return null;
    }

    return PARENT_ROWCOL_SIZES_MAP[isRows ? 0 : 1][parComp];
  }

	//private static WeakHashMap<Object, ArrayList<WeakCell>> PARENT_GRIDPOS_MAP = null;
	private static var PARENT_GRIDPOS_MAP:Dictionary;
	private static function saveGrid(parComp:ComponentWrapper, grid:Array):void {
    // Lazy since only if designing in IDEs
    if (PARENT_GRIDPOS_MAP == null) {
      PARENT_GRIDPOS_MAP = new Dictionary();
    }

		var weakCells:Vector.<WeakCell> = new Vector.<WeakCell>(grid.length, true);
    var weakCellsLength:int = 0;
    for (var key:Object in grid) {
      var cell:Cell = grid[key];
      var xyInt:Number = key as Number;
      if (xyInt == xyInt) {
        var x:int = xyInt & 0x0000;
        var y:int = xyInt >> 16;

        for each (var cw:CompWrap in cell.compWraps) {
          weakCells[weakCellsLength++] = new WeakCell(cw.comp.component, x, y, cell.spanx, cell.spany);
        }
      }
		}

		PARENT_GRIDPOS_MAP[parComp.component] = weakCells;
	}

  internal static function getGridPositions(parComp:Object):Dictionary {
    var weakCells:Vector.<WeakCell> = PARENT_GRIDPOS_MAP != null ? PARENT_GRIDPOS_MAP[parComp] : null;
    if (weakCells == null) {
      return null;
    }

    var retMap:Dictionary = new Dictionary();
    for each (var wc:WeakCell in weakCells) {
      var component:Object = Dictionaries.getFirst(wc.componentRef);
      if (component != null) {
        retMap[component] = new <int>[wc.x, wc.y, wc.spanX, wc.spanY];
      }
    }

    return retMap;
  }
}
}

import flash.utils.Dictionary;

final class WeakCell {
  internal const componentRef:Dictionary = new Dictionary(true);
  internal var x:int, y:int, spanX:int, spanY:int;

  function WeakCell(component:Object, x:int, y:int, spanX:int, spanY:int) {
    componentRef[component] = true;
    this.x = x;
    this.y = y;
    this.spanX = spanX;
    this.spanY = spanY;
  }
}


