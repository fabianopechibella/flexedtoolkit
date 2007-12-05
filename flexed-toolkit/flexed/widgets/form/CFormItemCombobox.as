package flexed.widgets.form {
	import mx.collections.ArrayCollection;
	import mx.controls.ComboBox;
	import mx.core.UIComponent;
	
	public class CFormItemCombobox implements CFormItemRenderer {
		private var combo:ComboBox;
		
		public function CFormItemCombobox() {
			combo = new ComboBox();
			combo.height = DefaultConfig.WIDGET_COMBOBOX_HEIGHT;
			combo.width = DefaultConfig.WIDGET_COMBOBOX_WIDTH;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getUIComponent():UIComponent{
			return combo;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getValue():Object{
			return combo.selectedItem.data;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function isEditable():Boolean{
			return combo.enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setEnabled(enabled:Boolean):void{
			combo.enabled = enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isEnabled():Boolean{
			return combo.enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setEditable(editable:Boolean):void{
			combo.editable = editable;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setValue(value:Object):void {
			// Check for data in dataProvider 
			// and select the corresponding label
			//	combo.
			var obj:Object = null;
			if(combo.dataProvider != null){
				for(var i:int = 0; i<combo.dataProvider.length;i++){
					obj = combo.dataProvider[i];
					if(obj.data == value){
						combo.selectedItem = obj;
						break;
					}
				}
			}
			else{
				// Set it to a value
				obj = new Object();
				obj.label = value;
				obj.data = value;
				combo.selectedItem = obj;
			}
		}
		
		/**
		 * Setting DataProvider as ArrayCollection from PropertySheet AS
		 */
		public function setDataProvider(dp:ArrayCollection):void{
			combo.dataProvider = dp;
		}
		

		public function setAttributes(attributes:Array):void {
			var editable:String = attributes["editable"];
			var _editable:Boolean=true;
			
			if(editable == "false")
				_editable = false;
			else if (editable == "true")
				_editable = true;
			else
				_editable = false;
			setEditable(_editable);
		}
		
		
		public function setAttributesFromXML(attributes:XMLList):void {
			var tmp:Array=new Array();
			var attrList:XMLList=attributes.attributes();
			
			for(var i:int=0;i<attrList.length();i++) {
				var name:String=attrList[i].name();
				tmp[name]=attrList[i];
			}			
			setAttributes(tmp);
		}
		
	}
}