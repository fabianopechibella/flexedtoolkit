package flexed.widgets.form{
	import mx.core.UIComponent;
	import mx.controls.RadioButtonGroup;
	import mx.containers.HBox;
	import mx.controls.RadioButton;
	import flash.events.Event;
	import flexed.widgets.form.CFormItemRenderer;
	
	public class CFormItemRadioButton implements CFormItemRenderer{
			
		private var radioButtonGroup:RadioButtonGroup;
		public var comp:HBox;
		
		public function CFormItemRadioButton() {
			radioButtonGroup=new RadioButtonGroup();
			comp=new HBox();
			
			var rb1:RadioButton=new RadioButton();
			rb1.id="enabled";
			rb1.label="Enabled";
			rb1.group=radioButtonGroup;
			rb1.value=true;
			comp.addChild(rb1);
			
			var rb2:RadioButton=new RadioButton();
			rb2.id="disabled";
			rb2.label="Disabled";
			rb2.group=radioButtonGroup;
			rb2.value=false;
			comp.addChild(rb2);
		}
		
		public function getUIComponent():UIComponent{
			return comp;
		}
		
		public function getRadioGroup():RadioButtonGroup{
			return radioButtonGroup;
		}
		
		public function getValue():Object{
			return radioButtonGroup.selectedValue;
		}
		
		public function isEditable():Boolean{
			// TODO: Should do something better			
			return radioButtonGroup.enabled;
		}
		
		public function setEnabled(enabled:Boolean):void {
			radioButtonGroup.enabled=enabled;
		}
		
		public function isEnabled():Boolean{
			return radioButtonGroup.enabled;
		}
		
		public function setEditable(editable:Boolean):void{
			// TODO: Should do something better
			radioButtonGroup.enabled=editable
		}
		
		public function setValue(value:Object):void{
			radioButtonGroup.selectedValue = value;
			if(value == null){
				radioButtonGroup.selection = null;
				radioButtonGroup.selectedValue = null;
				radioButtonGroup.getRadioButtonAt(0).selected = false;
				radioButtonGroup.getRadioButtonAt(1).selected = false;
			}

			var event : Event = new Event(Event.CHANGE,true,false);
			radioButtonGroup.dispatchEvent(event);
		
		}
	}
}