package flexed.widgets.form{
	import flash.events.Event;
	
	import mx.containers.Tile;
	import mx.controls.RadioButton;
	import mx.controls.RadioButtonGroup;
	import mx.core.UIComponent;
	
	public class CFormItemRadioButtonGroup implements CFormItemRenderer{
			
		private var radioButtonGroup:RadioButtonGroup;
		public var container:Tile;
		
		public function CFormItemRadioButtonGroup(radioButtons:Array = null) {
			
			if(radioButtons.length == 0){
				var rdoAttribs:Object = new Object();
					rdoAttribs.label = "Yes";
					rdoAttribs.data = "yes";
					rdoAttribs.value =  "true";
					radioButtons.push(rdoAttribs);

					rdoAttribs = new Object();
					rdoAttribs.label = "No";
					rdoAttribs.data = "no";
					rdoAttribs.value =  "false";
					radioButtons.push(rdoAttribs);
			}
			
			radioButtonGroup = new RadioButtonGroup();
			container = new Tile();
			container.direction = "horizontal";
			
			for(var i:int = 0; i < radioButtons.length; i++){
				var rdoBtn:RadioButton = new RadioButton();
					rdoBtn.id = radioButtons[i].data;
					rdoBtn.label = radioButtons[i].label;
					rdoBtn.group = radioButtonGroup;
					rdoBtn.value = radioButtons[i].data;
					if(radioButtons[i].value == "true")
						rdoBtn.selected = true;
					container.addChild(rdoBtn);
			}

		}
		
		public function getUIComponent():UIComponent{
			return container;
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
			radioButtonGroup.selectedValue = value as String;
			if(value == null){
				for(var i:int = 0; i<radioButtonGroup.numRadioButtons; i++){
					radioButtonGroup.getRadioButtonAt(i).selected = false;
				}
				radioButtonGroup.selection = null;
				radioButtonGroup.selectedValue = null;
			}

			var event : Event = new Event(Event.CHANGE,true,false);
			radioButtonGroup.dispatchEvent(event);
		
		}
	}
}