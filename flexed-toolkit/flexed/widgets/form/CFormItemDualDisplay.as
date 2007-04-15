package flexed.widgets.form {
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.controls.Alert;
	import mx.containers.HBox;
	
	public class CFormItemDualDisplay implements CFormItemRenderer {
		private var display0:Label;
		private var display1:Label;
		private var ddBox:HBox;
		private const delimiter:String = '|~^|';
		
		public function CFormItemDualDisplay() {
			ddBox = new HBox();
			display0 = new Label();
			display1 = new Label();
			display0.height = 21;
			display1.height = 21;
			display0.width = 83;
			display1.width = 83;
			ddBox.addChild(display0);
			ddBox.addChild(display1);
		}
		public function getUIComponent():UIComponent	{
			return ddBox;
		}
		
		public function getValue():Object
		{
			return display0.text + delimiter + display1.text;
		}
		
		public function isEditable():Boolean
		{
			return false;
		}
		
		public function setEnabled(enabled:Boolean):void
		{
//			display.enabled = enabled;
		}
		
		public function isEnabled():Boolean
		{
			return false;
		}
		
		public function setEditable(editable:Boolean):void
		{
//			display.enabled = editable;
		}
		
		public function setValue(value:Object):void
		{
			var dualValue:Array = value.toString().split(delimiter);
			display0.text = String(dualValue[0]);
			display1.text = String(dualValue[1]);
		}
		public function setAttributes(attributes:Array):void {
			var editable:String = attributes["editable"];
			
			var _editable:Boolean = true;
			if(editable == "false") _editable = false;
			
			setEditable(_editable);
		}
		public function setAttributesFromXML(attributes:XMLList):void {
			var tmp:Array = new Array();
			var attrList:XMLList = attributes.attributes();
			var fixedValueFlag:Boolean = false;
			var fixedValue:String = '';
			
			for(var i:int = 0;i < attrList.length();i++) {
				var name:String = attrList[i].name();
				if (name.toLowerCase() == 'text') {
					fixedValueFlag = true;
					fixedValue = attrList[i];
				}
				tmp[name] = attrList[i];
			}
			if (fixedValueFlag) {
				setValue(fixedValue);
			}
//			setAttributes(tmp);
		}
		
	}
}