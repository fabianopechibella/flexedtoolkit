package flexed.widgets.form {
	import mx.core.UIComponent;
	
	public interface CFormItemRenderer {
		
		/**
		 * Enables/Disables a control
		 * @param enabled : Enabled/Disabled Status
		 * @return void
		 */ 
		function setEnabled(enabled:Boolean):void ;
		
		/**
		 * Returns enabled status of the control
		 * @return enabled status  
		 */ 
		function isEnabled():Boolean;
		
		/**
		 * Marks a Control to be editable or not 
		 * @param editable : Editable Status
		 * @return void
		 */ 		
		function setEditable(editable:Boolean):void;
		
		/**
		 * Returns editable status of the control
		 * @return Editable status  
		 */ 
		function isEditable():Boolean;
		
		/**
		 * Sets a value for the control
		 * @param value : value 
		 * @return void
		 */ 
		function setValue(value:Object):void;
		
		/**
		 * Returns the value of the control
		 * @return value
		 */
		function getValue():Object;
		
		/**
		 * Returns the UIComponent of the control
		 * @return uicomponent
		 */
		function getUIComponent():UIComponent;
		
	}
}