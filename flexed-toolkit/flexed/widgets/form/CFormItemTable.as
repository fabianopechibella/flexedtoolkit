package flexed.widgets.form {
	import mx.controls.DataGrid;
	import mx.utils.ObjectProxy;
	import mx.core.UIComponent;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.dataGridClasses.DataGridColumn;
	
	public class CFormItemTable implements CFormItemRenderer {
		private var table:DataGrid;
		
		public function CFormItemTable() {
			table = new DataGrid();
			//table.minHeight = 60;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getUIComponent():UIComponent{
			return table;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getValue():Object{
			return table.dataProvider;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function setValue(value:Object):void{
			var collect : ArrayCollection = null;
			if(value is ArrayCollection){
				collect = ArrayCollection(value);
			}
			else if (value is ObjectProxy ){
				var collectObj : ObjectProxy = ObjectProxy(value);
				collect = new ArrayCollection;
				collect.addItem(collectObj);
			}
			table.dataProvider = collect;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setEnabled(enabled:Boolean):void{
			table.enabled = enabled;
		}
			
		/**
		 * @inheritDoc
		 */		
		public function isEditable():Boolean{
			return false;
		}
		
		/**
		 * @inheritDoc
		 * Implementation will be empty as it is a readonly component
		 */
		public function setEditable(editable:Boolean):void{
			// null	
		}

		/**
		 * @inheritDoc
		 */
		public function isEnabled():Boolean{
			return table.enabled;
		}
		
		public function setWidth(width:String):void{
			table.width=int(width);
		}
		
		public function setHeight(height:String):void{
			table.height=int(height);
		}
		
		public function setAttributes(attributes:Array):void {
			var editable:String = attributes["editable"];
			if (attributes["width"]!=null)
				setWidth(attributes["width"]);
			if (attributes["height"]!=null)
				setHeight(attributes["height"]);
		}
		
		public function setAttributesFromXML(attributes:XMLList):void {
			var tmp:Array = new Array();
			var attrList:XMLList = attributes.attributes();
			
			for(var i:int = 0;i < attrList.length();i++) {
				var name:String = attrList[i].name();
				tmp[name] = attrList[i];
			}			
			setAttributes(tmp);
		}
		
		public function setColumns(columns:XMLList):void {
			var colInfo : Array = new Array();
			
			for each(var col:XML in columns) {
 				var column : DataGridColumn = new DataGridColumn();
				column.headerText = col.attribute("label").toString();
				column.dataField = col.attribute("data").toString();
				column.width = col.attribute("width").toString();
				colInfo.push(column);
         	}
			table.columns = colInfo;
		}
	}
}