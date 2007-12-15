package flexed.widgets.form {
	import flexed.widgets.form.custom.SectionTitle;
	
	import mx.core.UIComponent;
	
	public class CFormItemTitle implements CFormItemRenderer
	{
		private var title:SectionTitle;
		
		public function CFormItemTitle() {
			title = new SectionTitle();
			title.height = DefaultConfig.GENERAL_TITLE_HEIGHT;
			title.setLabelStyle(DefaultConfig.GENERAL_TITLE_STYLE);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getUIComponent():UIComponent{
			//TODO: implement function
			return title;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getValue():Object{
			//TODO: implement function
			return title.viewName;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isEditable():Boolean
		{
			//TODO: implement function
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setEnabled(enabled:Boolean):void{
			//TODO: implement function
			title.enabled = enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isEnabled():Boolean{
			//TODO: implement function
			return title.enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setEditable(editable:Boolean):void{
			//TODO: implement function
		}
		
		/**
		 * @inheritDoc
		 */
		public function setValue(value:Object):void{
			title.viewName = value.toString();
		}		

		public function setAttributes(attributes:Array):void {
			var titleName:String = attributes["name"];
			setValue(titleName);
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