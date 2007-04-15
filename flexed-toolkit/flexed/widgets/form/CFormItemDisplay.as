package flexed.widgets.form{
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.controls.Alert;
	import mx.events.IndexChangedEvent;
	
	public class CFormItemDisplay implements CFormItemRenderer {
		private var display:Label;
		
		public function CFormItemDisplay()
		{
			display = new Label();
			display.height = 21;
			display.width = 175;
			display.styleName = "viewLabelValue" ;
		}
				
		public function getUIComponent():UIComponent	{
			return display;
		}
		
		public function getValue():Object
		{
			return display.text;
		}
		
		public function isEditable():Boolean
		{
			return false;
		}
		
		public function setEnabled(enabled:Boolean):void
		{
			display.enabled = enabled;
		}
		
		public function isEnabled():Boolean
		{
			return false;
		}
		
		public function setEditable(editable:Boolean):void
		{
//			display.enabled = editable;
		}
		
		public function setWidth(width:String):void
		{
			display.width=int(width);	
			
		}
		public function setHeight(height:String):void
		{
			display.height=int(height);
		}
		
		public function setValue(value:Object):void
		{
			display.text = String(value);
		}
		
		public function setAttributes(attributes:Array):void {
			var editable:String = attributes["editable"];
			var _editable:Boolean = true;
			if(editable == "false") _editable = false;
				setEditable(_editable);
			if (attributes["width"]!=null)
				setWidth(attributes["width"]);
			if (attributes["height"]!=null)
				setHeight(attributes["height"]);
				if (attributes["styleName"]!=null)
					display.styleName=attributes["styleName"];
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
		
	}
}