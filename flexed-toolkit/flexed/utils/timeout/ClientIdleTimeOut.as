////////////////////////////////////////////////////////////////////////////////
//
// *Copyright (c) 2007
//
// The usual Yada-Yada!
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this code and associated documentation
// files (the "Code"), to deal in the Code without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Code is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Code.
//
// THE CODE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// Further it is worth to mention that no animals have been 
// harmed during the development. No trees have been cut 
// down. Womens rights have been treated with full respect.
// Mankind's safety has been ensured at every step.
//
// Peace!
//
// @file: ClientIdleTimeOut
// @authors: Uday M. Shankar, Venkatesh Ramadurai
// @date: 31-03-2007
// @description: ClientIdleTimeOut component to track user 
// inactivity and act there on.
//
////////////////////////////////////////////////////////////////////////////////
package flexed.utils.timeout
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
	import mx.effects.Blur;
	import mx.containers.HBox;
	import mx.controls.Image;
	import mx.controls.Spacer;
	import mx.controls.Button;

	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the application times out.
	 *
	 *  @eventType mx.events.DynamicEvent
	 */
	[Event(name="appTimedOut", type="mx.events.DynamicEvent")]

	/**
	 *  CientIdleTimeOut is a component which when added to any flex application,
	 *  timesout the application if the user is inactive for a set period of time.
	 *
	 *  <p>This functionality is very useful in business applications which require user
	 *  authentication and login. In such applications, if the user is inactive for 
	 *  a certain period of time, the UI is timedout and disabled.
	 *
	 *  @mxml
	 *
	 *  <p>Using this component in the application is very simple. Use the following 
	 *  syntax for basic usage:</p>
	 *
	 *  <p>
	 *  &lt;flexed:ClientIdleTimeOut id="" /&gt;
	 *  </p>
	 *  
	 *  @includeExample UseIdleTimeout.mxml
	 */	
	public class ClientIdleTimeOut
	{
		
		//--------------------------------------------------------------------------
	    //
	    //  Class variables
	    //
	    //--------------------------------------------------------------------------
	
		private var _uintTimeOutInterval:uint = (.1 * 50 * 1000);//minutes * seconds * milliseconds; Default 5 secs;
		private var _uintConfirmInterval:uint = (.1 * 50 * 1000);//minutes * seconds * milliseconds; Default 5 secs;
		
		private var _timerTimeOut:Timer = new Timer(timeOutInterval);
		private var _timerConfirm:Timer = new Timer(confirmInterval);
		private var _iLastActivity:Number = 0;
		
		private var _mouseListener:Boolean = false;
		private var _keyListener:Boolean = true;
		private var _timedOutFunction:Function = new Function();
		
		[Embed("ico_alert.jpg")]
        private var alertIcon:Class;
        private var timoutPrompt:HBox = null;
        
        private static var _instance:ClientIdleTimeOut = new ClientIdleTimeOut();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 */
		public function ClientIdleTimeOut():void{
			_timerTimeOut.addEventListener(TimerEvent.TIMER, onTimeOutTimer);
			_timerTimeOut.start();
			_timerConfirm.addEventListener(TimerEvent.TIMER, onConfirmTimer);
			
			if(_mouseListener == true) (Application.application as Application).addEventListener(MouseEvent.MOUSE_MOVE, resetLastActivity);
			if(_keyListener == true) (Application.application as Application).addEventListener(KeyboardEvent.KEY_DOWN, resetLastActivity);
		}

		
		public static function get instance():ClientIdleTimeOut{
			return _instance;
		}
		
		public function startTimer():void{
			_timerTimeOut.start();
		}
		
		public function stopTimer():void{
			_timerTimeOut.stop();
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
				timeoutApp();
				
		   }
		}
		
		private function resetConfirmation(event:Event):void{
			hideTimeOutPrompt();
		}
		
		private function hideTimeOutPrompt():void{
			timoutPrompt.visible = false;
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
			if(timoutPrompt == null){
				createPopUp();
			}else{
				timoutPrompt.visible = true;
				timoutPrompt.addEventListener(FlexEvent.SHOW, timeOutConfirmation);
			}
			
		}
		
		public function timeoutApp():void{
			_timedOutFunction();
		}
		
		private function createPopUp():void{
			timoutPrompt = new HBox();
			timoutPrompt.setStyle("backgroundColor",0xffffff);
			timoutPrompt.setStyle("cornerRadius",4);
			timoutPrompt.setStyle("borderStyle","solid");
			timoutPrompt.setStyle("borderColor",0xd50000);
			timoutPrompt.setStyle("borderThickness",2);
			timoutPrompt.setStyle("alpha",1);
			timoutPrompt.width = 350;
		    timoutPrompt.height = 90;
		    timoutPrompt.x=(Application.application.width/2) - (timoutPrompt.width/2);
		    timoutPrompt.y=(Application.application.height/2) - (timoutPrompt.height/2);
		    timoutPrompt.verticalScrollPolicy = "off";
		    timoutPrompt.horizontalScrollPolicy = "off";
		    
		    var imgIcon:Image = new Image();imgIcon.source = alertIcon;
		    timoutPrompt.addChild(imgIcon);
		    
		    var txtCon:VBox = new VBox();
		    txtCon.setStyle("verticalGap",1);
			txtCon.setStyle("horizontalAlign","center");
			txtCon.percentHeight = 100;
			txtCon.percentWidth = 100;
			
			var spacer:Spacer = new Spacer();
			spacer.height = 20;
			spacer.percentWidth = 100;
			txtCon.addChild(spacer);
			
			var promptText:Text = new Text();
			promptText.htmlText = "Move the mouse or type within <b>" + _uintConfirmInterval/1000 + "</b> seconds <br>to stop automatic TIMEOUT.";
			promptText.setStyle("textAlign","center");
			txtCon.addChild(promptText);
			
			var btnKeepAlive:Button = new Button();
			btnKeepAlive.name = "btnKeepAlive";
			btnKeepAlive.label = "Stay Alive!";
			btnKeepAlive.addEventListener("click",resetTimeOut);
			txtCon.addChild(btnKeepAlive);
			
			timoutPrompt.addChild(txtCon);
			timoutPrompt.addEventListener(FlexEvent.INITIALIZE, timeOutConfirmation);
			
			PopUpManager.addPopUp(timoutPrompt,Application.application as Application);
		}
 		
	}
}