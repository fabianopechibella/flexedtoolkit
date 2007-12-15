package flexed.widgets.form {
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	import mx.controls.Alert;
	import mx.containers.HBox;
	
	public class CFormItemDualText implements CFormItemRenderer {
		private var textInput0:TextInput;
		private var textInput1:TextInput;
		private var dtBox:HBox;
		private const delimiter:String = '|~^|';
		
		public function CFormItemDualText() {
			dtBox = new HBox();
			textInput0 = new TextInput();
			textInput1 = new TextInput();
			textInput0.height = 21;
			textInput1.height = 21;
			textInput0.width = 83;
			textInput1.width = 83;
			dtBox.addChild(textInput0);
			dtBox.addChild(textInput1);
		}
		public function getUIComponent():UIComponent {
			return dtBox;
		}
		
		public function getValue():Object
		{
			return textInput0.text + delimiter + textInput1.text;
		}
		
		public function isEditable():Boolean
		{
			return textInput0.editable;
		}
		
		public function setEnabled(enabled:Boolean):void
		{
			textInput0.enabled = enabled;
			textInput1.enabled = enabled;
		}
		
		public function isEnabled():Boolean
		{
			return textInput0.enabled;
		}
		
		public function setEditable(editable:Boolean):void
		{
			textInput0.editable = editable;
			textInput1.editable = editable;
		}
		
		public function setValue(value:Object):void
		{
			var dualValue:Array = value.toString().split(delimiter);
			textInput0.text = String(dualValue[0]);
			textInput1.text = String(dualValue[1]);
		}
		public function setAttributes(attributes:Array):void {
			var editable:String = attributes["editable"];
			
			var _editable:Boolean=true;
			if(editable.toLocaleLowerCase() == "false") _editable=false;
			
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