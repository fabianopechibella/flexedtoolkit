package flexed.widgets.form {
	import mx.controls.TextArea;
	import mx.core.UIComponent;
	
	public class CFormItemTextArea implements CFormItemRenderer {
		private var textArea:TextArea;
		
		public function CFormItemTextArea() {
			textArea = new TextArea();
			textArea.height = DefaultConfig.WIDGET_TEXTAREA_HEIGHT;
			textArea.width = DefaultConfig.WIDGET_TEXTAREA_WIDTH;
		}
		
		public function getUIComponent():UIComponent{
			return textArea;
		}
		
		public function getValue():Object{
			return textArea.text;
		}
		
		public function isEditable():Boolean{
			return textArea.editable;
		}
		
		public function setEnabled(enabled:Boolean):void{
			textArea.enabled=enabled;
		}
		
		public function isEnabled():Boolean{
			return textArea.enabled;
		}
		
		public function setEditable(editable:Boolean):void{
			textArea.editable=editable;
		}
		
		public function setValue(value:Object):void{
			textArea.text=String(value);
		}
		
		public function setAttributes(attributes:Array):void{
			var editable:String=attributes["editable"];
			
			var _editable:Boolean=true;
			if(editable.toLocaleLowerCase() == "false") _editable=false;
			
			setEditable(_editable);
		
			if (attributes["width"]!=null)
				textArea.width=attributes["width"];
			if (attributes["height"]!=null)
				textArea.height=attributes["height"];
			
		}
		
		public function setAttributesFromXML(attributes:XMLList):void{
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