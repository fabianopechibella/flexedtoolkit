package flexed.widgets.form.custom
{
	/**
	 * TimePicker component by Randy Drisgill (randy@drisgill.com)
	 * Based on code by Andrew Lisse
	 * Modified by Uday M. Shankar [udayms@gmail.com]
	 * To use it, you simply place it in the same directory as your mxml file and include it with:
	 * <timePicker id="mytime">
	 * Or you can pass in now="true" and it will default to the current time:
	 * <timePicker id="mytime" now="true"/>
	 * Or you can pass in an hour, minute, and second to set the time:
	 * <timePicker id="mytime" hour="4" minute="44" meridian="34"/>
	 * Or you can use the setValue method, if that suits you better:
	 * <mx:Button label="setTime" click="mytime.setValue('3','1','34');" />
	 * And finally you can get the selected time by using the getValue method:
	 * <mx:Button label="getTime" click="alert(mytime.getValue());" />
	 * 
	 */
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.TextInput;
	
	public class TimeEntry extends HBox
	{
		
		[Embed(source="assets/uparrow.png")]
		private var icoUpArrow:Class;
		[Embed(source="assets/downarrow.png")]
		private var icoDownArrow:Class;
		private var now:Boolean;
		//incoming variables (now = true tells it to use current time)
		private var hour:String = '0';
		private var minute:String = '0';
		private var second:String = '0';
		
		
		//internal vars
		private var selTimeFocus:TextInput = tHour;
		private var minTime:Number = 0;
		private var maxTime:Number = 23;		
		
		private var tHour:TextInput = new TextInput();
		private var tMinute:TextInput = new TextInput();
		private var tSecond:TextInput = new TextInput();
		
		public function TimeEntry():void{
			createComponent();
			initComponent();
		}
		
		private function createComponent():void{
			this.setStyle("horizontalGap",0);
			this.setStyle("verticalAlign","middle");
			
			var hbxEntryFields:HBox = new HBox();
				hbxEntryFields.id = "EntryFields";
				hbxEntryFields.setStyle("horizontalGap",0);
				hbxEntryFields.setStyle("borderStyle","inset");
				hbxEntryFields.setStyle("verticalAlign","middle");
				hbxEntryFields.setStyle("paddingTop",0);
				hbxEntryFields.setStyle("paddingBottom",0);
				hbxEntryFields.height = 22;
			this.addChild(hbxEntryFields);
			
			var vbxControls:VBox = new VBox();
				vbxControls.setStyle("verticalAlign","bottom");
				vbxControls.setStyle("verticalGap",0);
				vbxControls.setStyle("horizontalGap",0);
			this.addChild(vbxControls); 	
			
			var seperator:Label = new Label();
				seperator.setStyle("textAlign","center");
				seperator.setStyle("paddingLeft",0);
				seperator.setStyle("paddingRight",0);
				seperator.setStyle("paddingTop",0);
				seperator.setStyle("paddingBottom",6);
				seperator.setStyle("fontWeight","bold");
				seperator.width = 7;
				seperator.text = ":";
				
				tHour = new TextInput();
				tHour.id = "tHour";
				tHour.maxChars = 2;
				tHour.restrict = "0-9";
				tHour.width = 17;
				tHour.height = 21;
				tHour.setStyle("borderStyle","none");
				tHour.setStyle("textAlign","right");
				tHour.setStyle("paddingRight",0);
				tHour.setStyle("paddingLeft",0);
				tHour.addEventListener(FocusEvent.FOCUS_IN, focusTime);
				tHour.addEventListener(FocusEvent.FOCUS_OUT, valTime);
				tHour.toolTip = "Hours";
				tHour.text = "12";
			hbxEntryFields.addChild(tHour);
			
			hbxEntryFields.addChild(seperator);

				tMinute = new TextInput();
				tMinute.id = "tMinute";
				tMinute.maxChars = 2;
				tMinute.restrict = "0-9";
				tMinute.width = 17;
				tMinute.height = 21;
				tMinute.setStyle("borderStyle","none");
				tMinute.setStyle("textAlign","right");
				tMinute.setStyle("paddingRight",0);
				tMinute.setStyle("paddingLeft",0);
				tMinute.addEventListener(FocusEvent.FOCUS_IN, focusTime);
				tMinute.addEventListener(FocusEvent.FOCUS_OUT, valTime);
				tMinute.toolTip = "Minutes";
				tMinute.text = "00";
			hbxEntryFields.addChild(tMinute);
			
			seperator = new Label();
			seperator.setStyle("textAlign","center");
			seperator.setStyle("paddingLeft",0);
			seperator.setStyle("paddingRight",0);
			seperator.setStyle("paddingTop",0);
			seperator.setStyle("paddingBottom",6);
			seperator.setStyle("fontWeight","bold");
			seperator.width = 7;
			seperator.text = ":";
			hbxEntryFields.addChild(seperator);

				tSecond = new TextInput();
				tSecond.id = "tSecond";
				tSecond.maxChars = 2;
				tSecond.restrict = "0-9";
				tSecond.width = 17;
				tSecond.height = 21;
				tSecond.setStyle("borderStyle","none");
				tSecond.setStyle("textAlign","right");
				tSecond.setStyle("paddingRight",0);
				tSecond.setStyle("paddingLeft",0);
				tSecond.addEventListener(FocusEvent.FOCUS_IN, focusTime);
				tSecond.addEventListener(FocusEvent.FOCUS_OUT, valTime);
				tSecond.toolTip = "Seconds";
				tSecond.text = "00";
			hbxEntryFields.addChild(tSecond);
			
			
			var btnUp:Button = new Button();
				btnUp.id = "btnUp";
				btnUp.setStyle("icon",icoUpArrow);
				btnUp.setStyle("verticalGap", 0);
				btnUp.setStyle("cornerRadius", 0);
				btnUp.width = 15;
				btnUp.height = 11;
				btnUp.addEventListener(MouseEvent.CLICK, arrowUp); 
			vbxControls.addChild(btnUp);
			
			var btnDown:Button = new Button();
				btnDown.id = "btnDown";
				btnDown.setStyle("icon",icoDownArrow);
				btnDown.setStyle("verticalGap", 0);
				btnDown.setStyle("cornerRadius", 0);
				btnDown.width = 15;
				btnDown.height = 11;
				btnDown.addEventListener(MouseEvent.CLICK, arrowDown);
			vbxControls.addChild(btnDown);
		}
		
		//init function
		private function initComponent():void	{
			setCurrentTime(showCurrentTime);
		//set the initial picker focus to hours
			focusTime();
		}
		
		private function setCurrentTime(now:Boolean):void{
			//if now is passed in as true use current time
			if(now){
				//get current hours and mins
				var d:Date = new Date();
				var hour:Number = d.getHours();
				var minute:Number = d.getMinutes();
				var second:Number = d.getSeconds();
				//adjust away from military time
				
				//set the actual time in the picker
				setValue(hour.toString(),minute.toString(),second.toString());
			}else{
				//set the actual time in the picker
				setValue("00","00","00");
			}
		}		
		
		//on up arrow click
		private function arrowUp(event:MouseEvent):void{
			//if we have hit our max for this focus, cycle back to the minimum for this focus
			if(selTimeFocus.text == maxTime.toString()){
				if(selTimeFocus == tHour){
					selTimeFocus.text = minTime.toString();
				}else{//for mins, pad the zero
					selTimeFocus.text = minTime.toString();
				}
			//otherwise increment
			}else{
				var nValue:Number = Number(selTimeFocus.text)+1;
				selTimeFocus.text = nValue.toString(); // (nValue < 10 ? "0"+nValue : nValue);
			}
			//if the focused field is not a number, pad it
			if(isNaN(Number(selTimeFocus.text))){
				selTimeFocus.text = minTime.toString();
			}
		}
		
		//on picker arrow down
		private function arrowDown(event:MouseEvent):void{
			//if we are at the minimum val, its time to switch to the max value
			if((selTimeFocus.text == minTime.toString()) || (!selTimeFocus.text)){
				selTimeFocus.text = maxTime.toString();
			//else decrement it
			}else{
				var nValue:Number = Number(selTimeFocus.text)-1;
					selTimeFocus.text = nValue.toString(); 
			}
			//if the focused field is not a number, pad it
			if(isNaN(Number(selTimeFocus.text))){
				selTimeFocus.text = minTime.toString();
			}
		}
		
		//validate manual inputs
		private function valTime(event:FocusEvent):void{
			var theBox:TextInput = event.currentTarget as TextInput;
			var minNum:Number = 0;
			var maxNum:Number = 0;
			
			if(theBox.id == "tHour"){
				minNum = 0; maxNum = 23;
			}else if(theBox.id == "tMinute"){
				minNum = 0; maxNum = 59;
			}else if(theBox.id == "tSecond"){
				minNum = 0; maxNum = 59;
			} 
			if(Number(theBox.text)<minNum){
				theBox.text = minNum.toString();
			}else if(Number(theBox.text)>maxNum){
				theBox.text = maxNum.toString();
			}
			//if focus was on minutes, pad the low nums
			if(theBox == tMinute){
				theBox.text = (Number(theBox.text) < 10 ? "0"+theBox.text : theBox.text);
			}
		}
		
		//sets the focused area and min max numbers
		private function focusTime(event:FocusEvent = null):void{
			var theBox:TextInput = new TextInput();
			var minNum:Number = 0;
			var maxNum:Number = 0;
			
			if(event == null){
				theBox = tHour;
				minNum = 0; maxNum = 23;
			}else{
				theBox = event.currentTarget as TextInput;
				
				if(theBox.id == "tHour"){
				minNum = 1; maxNum = 12;
				}else if(theBox.id == "tMinute"){
					minNum = 00; maxNum = 59;
				}else if(theBox.id == "tSecond"){
					minNum = 00; maxNum = 59;
				}
			}
			
			selTimeFocus = theBox;
			maxTime = maxNum;
			minTime = minNum;
		}
		
		//get the picked time as a string
		public function getValue():String{
			return tHour.text+":"+tMinute.text+":"+tSecond.text;
		}

		//set the picker value
		public function setValue(h:String,m:String,s:String):void{
			tHour.text   = h; //(h < 10 ? "0"+Number(h) : h);
			tMinute.text = m; //(m < 10 ? "0"+Number(m) : m);
			tSecond.text = s; //(s < 10 ? "0"+Number(s) : s);
		}
		
		public function set showCurrentTime(show:Boolean):void{
			now = show;
			setCurrentTime(show);
		}
		
		public function get showCurrentTime():Boolean{
			return now;
		}
	}
}