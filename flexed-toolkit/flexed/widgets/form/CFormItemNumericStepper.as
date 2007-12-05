package flexed.widgets.form {
	import mx.controls.NumericStepper;
	import mx.core.UIComponent;
	
	public class CFormItemNumericStepper implements CFormItemRenderer {
		private var numStep:NumericStepper;
		
		public function CFormItemNumericStepper() {
			numStep = new NumericStepper();
			numStep.height = DefaultConfig.WIDGET_NUMERICSTEPPER_HEIGHT;
			numStep.width = DefaultConfig.WIDGET_NUMERICSTEPPER_WIDTH;
		}
		public function getUIComponent():UIComponent	{
			return numStep;
		}
		
		public function getValue():Object
		{
			return numStep.value;
		}
		
		public function isEditable():Boolean
		{
			return numStep.enabled;
		}
		
		public function setEnabled(enabled:Boolean):void
		{
			numStep.enabled = enabled;
		}
		
		public function isEnabled():Boolean
		{
			return numStep.enabled;
		}
		
		public function setEditable(editable:Boolean):void
		{
			numStep.enabled = editable;
		}
		
		public function setValue(value:Object):void
		{
			numStep.value = int(value);
		}
		
		public function setMinValue(value:int):void
		{
			numStep.minimum = value;
		}
		
		public function setMaxValue(value:int):void
		{
			numStep.maximum = value;
		}
		
		public function setAttributes(attributes:Array):void {
			var editable:String = attributes["editable"];
			var minVal:int = int(attributes["min"]);
			var maxVal:int = int(attributes["max"]);
			
			var _editable:Boolean=true;
			if(editable=="false") _editable=false;
			if (minVal >= 0) setMinValue(minVal);
			if (maxVal > 0) setMaxValue(maxVal);
			
			setEditable(_editable);
			
			if (attributes["maxChars"]!=null && attributes["maxChars"]!="")
			numStep.maxChars=attributes["maxChars"];
			
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