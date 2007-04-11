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
// @file: AutoRefresher
// @author: Uday M. Shankar
// @original author: Easwar Natarajan
// @date: 31-03-2007
// @description: A Autorefresher component. If this is added to a view. The 
// view auto refreshes every x seconds. It would be more correct to say that 
// a specified method at caller will be executed every x seconds. Refreshing 
// is one such task that might be required to be auto-executed every x seconds.
// Hence, this component is called AutoRefresher.
//
////////////////////////////////////////////////////////////////////////////////

package flexed.utils
{
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.core.UIComponent;
	
	import flash.events.TimerEvent;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Timer;
	
	public class AutoRefresher
	{	
		private var _delay:int = 15*1000;
		private var _repeatCount:int = 1;
		private var _refreshFunction:Function;
		private var _refresherOwner:UIComponent;
		private var _refreshAlways:Boolean = false;
		private var timer:Timer;
		private var paused:Boolean;
		
		private static var instanceColl:ArrayCollection = new ArrayCollection();
		
		public function Refresher():void{
			instanceColl.addItem(this);
		}
		
		/**
		 * Retrieves all active instances of 
		 * the refresher obj
		 */
		public static function getAllInstances():ArrayCollection{
			return instanceColl;
		}

		/**
		 * Retrieves all active instances of 
		 * the refresher obj
		 */
		public static function startAll():void{
			if(instanceColl != null){
				for(var k:int=0; k<instanceColl.length; k++){
					if(instanceColl[k] is AutoRefresher)
						instanceColl[k]._refreshFunction();
				}
				for(var i:int=0; i<instanceColl.length; i++){
					if(instanceColl[i] is AutoRefresher)
						instanceColl[i].start();
				}
			}
		}
		
		public static function stopAll():void{
			if(instanceColl != null){
				for(var i:int=0; i<instanceColl.length; i++){
					if(instanceColl[i] is AutoRefresher)
						instanceColl[i].stop();
				}
			}
		}
		
		public function set refreshFunction(fn:Function):void{
			_refreshFunction = fn;
		}
		
		public function set delay(delay:int):void{
			_delay = delay;
		}
		
		public function get delay():int{
			return _delay;
		}
		
		public function set repeatCount(repeatCount:int):void{
			_repeatCount = repeatCount;
		}
		
		public function set owner(owner:UIComponent):void{
			if(_refresherOwner != null) {
				_refresherOwner.removeEventListener(FlexEvent.HIDE, hideListener);
				_refresherOwner.removeEventListener(FlexEvent.SHOW, showListener);
			}
			_refresherOwner = owner;
			_refresherOwner.addEventListener(FlexEvent.HIDE, hideListener);
			_refresherOwner.addEventListener(FlexEvent.SHOW, showListener);
		}
		
		public function start():void{
			if(timer && timer.running) timer.stop();
			if(timer == null){
				timer = new Timer(_delay,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			}
			
			// Just in case the refresher is not set to the view.....
			var tempParent:DisplayObjectContainer = _refresherOwner;
			var flag:Boolean = false;
			while(tempParent != null && tempParent.visible == true){
				tempParent = tempParent.parent;
			}
			if(tempParent == null){ 
				timer.start();
			}else{
				if(timer.running) stop();
			}
		}
		
		public function stop():void{
			if(timer != null && timer.running)
				timer.stop();
		}
		
		private function showListener(event:FlexEvent):void{
			if(timer && !timer.running) {
				if(_refreshFunction != null) 
					_refreshFunction();
				if(_refresherOwner.visible) 
					timer.start();
			}
		}
		
		private function hideListener(event:FlexEvent):void{
			if(timer != null && timer.running) 
				timer.stop();
		}

		private function onTimerComplete(event:TimerEvent):void{
			if(_refreshFunction != null) 
				_refreshFunction();
			// do not start the timer if the object is not visible 
			start();
		}		
	}
}