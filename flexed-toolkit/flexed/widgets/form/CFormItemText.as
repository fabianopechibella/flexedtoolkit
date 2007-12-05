package flexed.widgets.form {
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	
	public class CFormItemText implements CFormItemRenderer {
		private var textInput:TextInput;
		
		public function CFormItemText() {
			textInput = new TextInput();
			textInput.height = DefaultConfig.WIDGET_TEXT_HEIGHT;
			textInput.width = DefaultConfig.WIDGET_TEXT_WIDTH;;
		}
		public function getUIComponent():UIComponent	{
			return textInput;
		}
		
		public function getValue():Object
		{
			return textInput.text;
		}
		
		public function isEditable():Boolean
		{
			return textInput.editable;
		}
		
		public function setEnabled(enabled:Boolean):void
		{
			textInput.enabled=enabled;
		}
		
		public function isEnabled():Boolean
		{
			return textInput.enabled;
		}
		
		public function setEditable(editable:Boolean):void
		{
			textInput.editable=editable;
		}
		
		public function setValue(value:Object):void
		{
			textInput.text=String(value);
		}
		
		public function setAttributes(attributes:Array):void {
			var editable:String=attributes["editable"];
			var width:String=attributes["width"];
			
			if(editable == null) editable = "true";
				
			var _editable:Boolean=true;
			if(editable.toLocaleLowerCase() == "false") _editable=false;
			
			setEditable(_editable);
			if(width) textInput.width=int(width);
			
			if (attributes["displayAsPassword"])
			textInput.displayAsPassword=true;
			
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