package  flexed.widgets.form {
	import flexed.widgets.form.custom.TimePicker;
	
	import mx.containers.HBox;
	import mx.controls.DateField;
	import mx.core.UIComponent;
	import mx.formatters.DateFormatter;

	
	public class CFormItemDate implements CFormItemRenderer {
		public var dtBox:HBox;
		private var dateField:DateField;
		private var timeField:TimePicker;
		
		public var currentFormat:String = "ddd mmm dd HH:mm:ss yyyy";
		public var expectedFormat:String = "MM/DD/YYYY";
		
		public function CFormItemDate() {
			dtBox = new HBox();
			dtBox.setStyle("horizontalGap", "1");
			dtBox.setStyle("verticalGap", "1");

			dateField = new DateField();
			dtBox.addChild(dateField);

			timeField = new TimePicker();
			dtBox.addChild(timeField);
		}
		public function getUIComponent():UIComponent	{
			return dtBox;
		}
		
		public function getValue():Object
		{
			var dtString: String = dateField.text + ' ' + timeField.getValue();
			return dtString;
		}
		
		public function isEditable():Boolean
		{
			return dtBox.enabled;
		}
		
		public function setEnabled(enabled:Boolean):void
		{
			dtBox.enabled = enabled;
		}
		
		public function isEnabled():Boolean
		{
			return dtBox.enabled;
		}
		
		public function setEditable(editable:Boolean):void
		{
			dtBox.enabled = editable;
		}
		
		public function setValue(value:Object):void
		{
			var df:DateFormatter = new DateFormatter();
			df.formatString = expectedFormat;
			dateField.text = df.format(value);
			
			df.formatString = "J";
			var hour : String = int(df.format(value)).toString();
			df.formatString = "N";
			var min : String = int(df.format(value)).toString();
			df.formatString = "S";
			var sec : String = int(df.format(value)).toString();
			
			timeField.setValue (hour, min, sec);
		}

		public function setAttributes(attributes:Array):void {
			var editable:String=attributes["editable"];
			
			var _editable:Boolean=true;
			if(editable=="false") _editable=false;
			
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