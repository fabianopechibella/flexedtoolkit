package  flexed.widgets.form {
	import flexed.widgets.form.custom.TimeEntry;
	
	import mx.containers.HBox;
	import mx.controls.DateField;
	import mx.core.UIComponent;
	import mx.formatters.DateFormatter;

	
	public class CFormItemDate implements CFormItemRenderer {
		public var dtBox:HBox;
		private var dateField:DateField;
		private var timeField:TimeEntry;
		private var timeShown:Boolean = false;
		
		public var currentFormat:String = DefaultConfig.WIDGET_DATE_CURRENTFORMAT;
		public var expectedFormat:String = DefaultConfig.WIDGET_DATE_EXPECTEDFORMAT;
		
		public function CFormItemDate(showTimeEntry:String = "false") {
			dtBox = new HBox();
			dtBox.setStyle("horizontalGap", DefaultConfig.WIDGET_DATE_HGAP);
			dtBox.setStyle("verticalGap", DefaultConfig.WIDGET_DATE_VGAP);

			dateField = new DateField();
			dateField.width = DefaultConfig.WIDGET_DATE_DATEWIDTH;
			dtBox.addChild(dateField);
			
			if(showTimeEntry == "true"){
				timeShown = true;
				dateField.width = DefaultConfig.WIDGET_DATE_DATETIMEWIDTH;
				timeField = new TimeEntry();
				timeField.width = DefaultConfig.WIDGET_DATE_DATETIMEWIDTH;
				dtBox.addChild(timeField);
			}

			
		}
		public function getUIComponent():UIComponent	{
			return dtBox;
		}
		
		public function getValue():Object
		{
			var dtString:String = dateField.text;
			if(timeShown == true) dtString += ' ' + timeField.getValue();
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
			
			if(timeShown == true) timeField.setValue(hour, min, sec);
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