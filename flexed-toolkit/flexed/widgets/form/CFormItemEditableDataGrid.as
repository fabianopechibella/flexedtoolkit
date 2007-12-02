package com.extremenetworks.matisse.common.widgets
{
	import flexed.widgets.form.custom.EditableDataGrid;
	
	import mx.collections.ArrayCollection;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	
	
	public class CFormItemEditableDataGrid implements PropertyValueRenderer
	{
		private var grid:EditableDataGrid = new EditableDataGrid();
		public function CFormItemEditableDataGrid(){
			//TODO: implement function
			super();
			grid.editable = true;
		}
		
		/** Enables/Disables a control
		 * @param enabled : Enabled/Disabled Status
		 * @return void
		 */ 
		public function setEnabled(enabled:Boolean):void{
			grid.enabled = enabled;			
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function isEnabled():Boolean{
			return grid.enabled;
		}
		
		/**
		 * @inheritDoc
		 */ 		
		public function setEditable(editable:Boolean):void{
			grid.editable = editable;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function isEditable():Boolean{
			return grid.editable;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function setValue(value:Object):void{
			// Do not directly assign it 
			// if not original values array of property sheet is passed
			// hence any change in the view will reflect in "original" array
			// thus current value and original value will always be equal
			// grid.editGrid.dataProvider = value;
			// You can pass only array as the value
			if (value is Array){
				grid.editGrid.dataProvider = new ArrayCollection();
				for(var i:int = 0; i <value.length;i++){
					grid.editGrid.dataProvider.addItem({ipAddress:value[i]["ipAddress"],netmask:value[i]["netmask"]});
				} 
			}else{
				grid.editGrid.dataProvider = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getValue():Object{
			return grid.editGrid.dataProvider;
		}
		
		
		public function setWidth(width:String):void{
			grid.gridWidth=int(width);
		}
		
		public function setHeight(height:String):void{
			grid.gridWidth=int(height);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getUIComponent():UIComponent{
			return grid;
		}
		
		private function setAttributes(attributes:Array):void {
			var editable:String = attributes["editable"];
			if (attributes["width"]!=null)
				setWidth(attributes["width"]);
			if (attributes["height"]!=null)
				setHeight(attributes["height"]);
		}
		
		/**
		 * Sets the Attributes for the Grid
		 */		
		public function setAttributesFromXML(attributes:XMLList):void {
			var tmp:Array = new Array();
			var attrList:XMLList = attributes.attributes();
			
			for(var i:int = 0;i < attrList.length();i++) {
				var name:String = attrList[i].name();
				tmp[name] = attrList[i];
			}			
			setAttributes(tmp);
		}
		
		/**
		 * Sets the Columns of the Grid
		 */ 
		public function setColumns(columns:XMLList):void {
			var colInfo : Array = new Array();
			for(var pName:String in columns) {
				var column : DataGridColumn = new DataGridColumn();
				column.headerText = columns[pName].name;
				column.dataField = columns[pName].id;
				column.width = columns[pName].width;
				colInfo.push(column);
			}
			this.grid.columns = colInfo;
		}
	}
}