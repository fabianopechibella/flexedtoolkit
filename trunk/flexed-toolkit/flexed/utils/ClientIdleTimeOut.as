package flexed.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import mx.events.MoveEvent;
	import mx.core.Application;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import mx.managers.PopUpManager;
	import mx.events.FlexEvent;
	import mx.containers.VBox;
	import mx.controls.Text;
	import mx.containers.Canvas;

	
	public class ClientIdleTimeOut
	{
		
		private var _uintTimeOutInterval:uint = (.1 * 60 * 1000);//minutes * seconds * milliseconds;
		private var _uintConfirmInterval:uint = (.1 * 60 * 1000);//minutes * seconds * milliseconds;
		
		private var _timerTimeOut:Timer = new Timer(timeOutInterval);
		private var _timerConfirm:Timer = new Timer(confirmInterval);
		private var _iLastActivity:Number = 0;
		
		private var _mouseListener:Boolean = false;
		private var _keyListener:Boolean = true;
		private var _timedOutFunction:Function = new Function();
		
		private var timoutPrompt:Canvas = new Canvas();
		
		public function ClientIdleTimeOut():void{
			_timerTimeOut.addEventListener(TimerEvent.TIMER, onTimeOutTimer);
			_timerTimeOut.start();
			_timerConfirm.addEventListener(TimerEvent.TIMER, onConfirmTimer);
			
			if(_mouseListener == true) (Application.application as Application).addEventListener(MouseEvent.MOUSE_MOVE, resetLastActivity);
			if(_keyListener == true) (Application.application as Application).addEventListener(KeyboardEvent.KEY_DOWN, resetLastActivity);
		}
		
		public function set timeOutInterval(timeoutInterval:uint):void{
			_uintTimeOutInterval = timeoutInterval*1000;
			_timerTimeOut.delay = timeoutInterval*1000;
		}
		
		public function get timeOutInterval():uint{
			return _uintTimeOutInterval;
		}

		public function set confirmInterval(confirmInterval:uint):void{
			_uintConfirmInterval = confirmInterval*1000;
			_timerConfirm.delay = confirmInterval*1000;
		}
		
		public function get confirmInterval():uint{
			return _uintConfirmInterval;
		}
		
		public function set listenKeyStroke(registerKeys:Boolean):void{
			_keyListener = registerKeys;
		}

		public function get listenKeyStroke():Boolean{
			return _keyListener;
		}
		
		public function set listenMouseMove(registerMouse:Boolean):void{
			_mouseListener = registerMouse;
		}

		public function get listenMouseMove():Boolean{
			return _mouseListener;
		}
	
		public function set onTimeOut(timeoutFn:Function):void{
			_timedOutFunction = timeoutFn;
		}
		
		/**
		  * called by mousmove resets timout
		  * clears warning
		  */   
		 public function resetLastActivity(evnt:Event):void{
			_iLastActivity = getTimer();
			
			if (_timerConfirm.running){
				_timerConfirm.stop();
			}
			if(!_timerTimeOut.running){
				_timerTimeOut.start();
			}
			
			if(timoutPrompt != null) hideTimeOutPrompt();
		 }


		 /**
		   * Run by time event, if timeout interval has elapsed,
		   * shows warning, starts confirm timer
		  */  
		 private function onTimeOutTimer(event:TimerEvent = null):void{
		 	var iCurTimer:Number = getTimer();
			var iElapsed:Number = iCurTimer - _iLastActivity;
			
			if ( iElapsed >= _uintTimeOutInterval ) {
				showTimeOutPrompt();
				_timerTimeOut.stop();
		   }
		 }
		 
		/**
		  * If the interval passes without user activity,
		  * do the timeout functionality, 
		  * in this case, display a message and disable the app.
		  */
		private function onConfirmTimer(event:TimerEvent = null):void{
			var iCurTimer:Number = getTimer();
			var iElapsed:Number = iCurTimer - _iLastActivity;
			
			if ( iElapsed >= _uintTimeOutInterval ) {
				hideTimeOutPrompt();
				(Application.application as Application).enabled = false;
				_timerConfirm.stop();
				_timerTimeOut.stop();
				_timedOutFunction();
				
		   }
		}
		
		private function resetConfirmation(event:Event):void{
			hideTimeOutPrompt();
		}
		
		private function hideTimeOutPrompt():void{
			PopUpManager.removePopUp(timoutPrompt);
		}
		
		
		private function timeOutConfirmation(event:Event):void{
			_timerConfirm.addEventListener(TimerEvent.TIMER, onConfirmTimer);
			_timerConfirm.start();
		}
		
		private function resetTimeOut(event:Event):void{
			_timerConfirm.stop();
			_timerTimeOut.start();
			(Application.application as Application).enabled = true;
			hideTimeOutPrompt();
		}
		
		private function showTimeOutPrompt():void{
			var cvs:VBox = new VBox();
			cvs.removeAllChildren();
			cvs.percentWidth = 90;
			cvs.addEventListener(FlexEvent.INITIALIZE,timeOutConfirmation);
			
			var promptText:Text = new Text();
			promptText.htmlText = "Move the mouse or type within <b>" + _uintConfirmInterval/1000 + "</b> seconds <br>to stop automatic TIMEOUT.";
			promptText.setStyle("textAlign","center");
			cvs.addChild(promptText);
			
    		timoutPrompt.addEventListener(MouseEvent.MOUSE_MOVE, resetTimeOut);
			timoutPrompt.addEventListener(KeyboardEvent.KEY_DOWN, resetTimeOut);
			timoutPrompt.setStyle("backgroundColor",0xffffff);
			timoutPrompt.setStyle("cornerRadius",4);
			timoutPrompt.setStyle("borderStyle","solid");
			timoutPrompt.setStyle("borderColor",0xd50000);
			timoutPrompt.setStyle("borderThickness",2);
			timoutPrompt.setStyle("alpha",1);
			timoutPrompt.width = 250;
		    timoutPrompt.height = 100;
		    timoutPrompt.x=(Application.application.width/2) - (timoutPrompt.width/2);
		    timoutPrompt.y=(Application.application.height/2) - (timoutPrompt.height/2);
			timoutPrompt.addChild(cvs);

			PopUpManager.addPopUp(timoutPrompt,Application.application as Application);
		}
 		
	}
}