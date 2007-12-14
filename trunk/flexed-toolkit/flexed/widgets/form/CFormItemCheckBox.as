package flexed.widgets.form {
	import mx.controls.CheckBox;
	import mx.core.UIComponent;
	
	public class CFormItemCheckBox implements CFormItemRenderer {
		private var chkBox:CheckBox;
		
		public function CFormItemCheckBox() {
			chkBox = new CheckBox();
		}
		
		public function getUIComponent():UIComponent{
			return chkBox;
		}
		
		public function getValue():Object{
			return chkBox.selected;
		}
		
		public function isEditable():Boolean{
			// TODO: Should do something better			
			return chkBox.enabled;
		}
		
		public function setEnabled(enabled:Boolean):void{
			chkBox.enabled = enabled;
		}
		
		public function isEnabled():Boolean{
			return chkBox.enabled;
		}
		
		public function setEditable(editable:Boolean):void{
			chkBox.enabled = editable;
		}
		
		public function setValue(value:Object):void{
				chkBox.selected = value;
		}
		
		public function setAttributes(attributes:Array):void{
			var editable:String=attributes["editable"];
	
			if(editable == null) editable = "true";
				
			var _editable:Boolean=true;
			if(editable.toLocaleLowerCase() == "false") _editable=false;
			
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