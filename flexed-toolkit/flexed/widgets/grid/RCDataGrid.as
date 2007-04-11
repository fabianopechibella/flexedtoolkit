/**
    Copyright (c) 2006. Tapper, Nimer and Associates Inc
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    
      * Redistributions of source code must retain the above copyright notice,
        this list of conditions and the following disclaimer.
      * Redistributions in binary form must reproduce the above copyright notice,
        this list of conditions and the following disclaimer in the documentation
        and/or other materials provided with the distribution.
      * Neither the name of Tapper, Nimer, and Associates nor the names of its
        contributors may be used to endorse or promote products derived from this
        software without specific prior written permission.
    
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
    LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
    CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
    
    @author: Mike Nimer (mikenimer@yahoo.com)
    @ignore
**/


package flexed.widgets.grid
{
    import mx.controls.DataGrid;
    import flash.display.Shape;
    import mx.core.FlexShape;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import mx.rpc.events.AbstractEvent;
    import mx.collections.ArrayCollection;
    import flash.events.Event;

    /**
     * This is an extended version of the built-in Flex datagrid. 
     * This extended version has the correct override logic in it
     * to draw the background color of the cells, based on the value of the
     * data in the row.
     **/
    public class RCDataGrid extends DataGrid
    {
        private var _rowColorFunction:Function;
        
        public function RCDataGrid()
        {
            super();
        }
        
        
        /**
         * A user-defined function that will return the correct color of the
         * row. Usually based on the row data.
         * 
         * expected function signature:
         * public function F(item:Object, defaultColor:uint):uint
         **/
        public function set rowColorFunction(f:Function):void
        {
            this._rowColorFunction = f;
        }
        
        public function get rowColorFunction():Function
        {
            return this._rowColorFunction;
        }
        
        
        
        private var displayWidth:Number; // I wish this was protected, or internal so I didn't have to recalculate it myself.        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);            
            if (displayWidth != unscaledWidth - viewMetrics.right - viewMetrics.left)
            {
                displayWidth = unscaledWidth - viewMetrics.right - viewMetrics.left;
            }
        }
        

        /**
         *  Draws a row background 
         *  at the position and height specified using the
         *  color specified.  This implementation creates a Shape as a
         *  child of the input Sprite and fills it with the appropriate color.
         *  This method also uses the <code>backgroundAlpha</code> style property 
         *  setting to determine the transparency of the background color.
         * 
         *  @param s A Sprite that will contain a display object
         *  that contains the graphics for that row.
         *
         *  @param rowIndex The row's index in the set of displayed rows.  The
         *  header does not count, the top most visible row has a row index of 0.
         *  This is used to keep track of the objects used for drawing
         *  backgrounds so a particular row can re-use the same display object
         *  even though the index of the item that row is rendering has changed.
         *
         *  @param y The suggested y position for the background
         * 
         *  @param height The suggested height for the indicator
         * 
         *  @param color The suggested color for the indicator
         * 
         *  @param dataIndex The index of the item for that row in the
         *  data provider.  This can be used to color the 10th item differently
         *  for example.
         */
        override protected function drawRowBackground(s:Sprite, rowIndex:int,
                                                y:Number, height:Number, color:uint, dataIndex:int):void
        {
            if( this.rowColorFunction != null && this.dataProvider != null)
            {
                if( dataIndex < (this.dataProvider as ArrayCollection).length )
                {
                    var item:Object = (this.dataProvider as ArrayCollection).getItemAt(dataIndex);
                    color = this.rowColorFunction.call(this, item, color);
                }
            }
            
            super.drawRowBackground(s, rowIndex, y, height, color, dataIndex);
        }

    }
}