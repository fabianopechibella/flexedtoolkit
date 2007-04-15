////////////////////////////////////////////////////////////////////////////////
//
// *Copyright (c) 2007 Uday M. Shankar
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
// @authors: Uday M. Shankar, Easwar Natarajan
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

	/**
	 *  A Autorefresher component. If this is added to a view. The 
	 *  view auto refreshes every x seconds. It would be more correct to say that 
	 *  a specified method at caller will be executed every x seconds. Refreshing 
	 *  is one such task that might be required to be auto-executed every x seconds.
	 *  Hence, this component is called AutoRefresher.
	 *
	 *  @mxml
	 *
	 *  <p>Using this component in the application is very simple. Use the following 
	 *  syntax for basic usage:</p>
	 *  &lt;flexed:AutoRefresher id="exampleAutoRefresh" delay="1" refreshFunction="FunctionPassedFromCaller" /&gt;
	 */		
	public class AutoRefresher
	{	
		private var _delay:int = 15*1000;
		private var _repeatCount:int = 1;
		private var _refreshFunction:Function;
		private var _refresherOwner:UIComponent;
		private var _refreshAlways:Boolean = false;
		
		private var timer:Timer;
		private var paused:Boolean;
		
		private static var allInstances:ArrayCollection = new ArrayCollection();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 */		
		public function Refresher():void{
			allInstances.addItem(this);
		}
		
		/**
	     *  Retrieves all instances of the AutoRefresher.
	     */
		public static function getAllInstances():ArrayCollection{
			return allInstances;
		}

		/**
	     *  Starts all instances of the AutoRefresher.
	     */		 
		public static function startAll():void{
			if(allInstances != null){
				for(var k:int=0; k<allInstances.length; k++){
					if(allInstances[k] is AutoRefresher)
						allInstances[k]._refreshFunction();
				}
				for(var i:int=0; i<allInstances.length; i++){
					if(allInstances[i] is AutoRefresher)
						allInstances[i].start();
				}
			}
		}
		
		/**
	     *  Stops all instances of the AutoRefresher.
	     */
		public static function stopAll():void{
			if(allInstances != null){
				for(var i:int=0; i<allInstances.length; i++){
					if(allInstances[i] is AutoRefresher)
						allInstances[i].stop();
				}
			}
		}
		
		/**
	     *  A function from the caller can be set here 
	     *  and will be executed when the idle timeout occurs.
	     *
	     *  @param refreshFunction Function of type void passed in by the caller.
	     */
		public function set refreshFunction(refresherfn:Function):void{
			_refreshFunction = refresherfn;
		}
		
		/**
	     *  Getter & Setter for the time interval of the AutoRefresher.
	     *
	     *  @param delay The interval at which the refresher 
	     *  should execute the function specified.
	     */
		public function set delay(delay:int):void{
			_delay = delay;
		}
		
		public function get delay():int{
			return _delay;
		}
		
		/**
	     *  Getter & Setter for number of times the AutoRefresher 
	     *  should repeat execution.
	     *
	     *  @param repeatCount The interval at which the refresher 
	     *  should execute the function specified.
	     */
		public function set repeatCount(repeatCount:int):void{
			_repeatCount = repeatCount;
		}
		
		/**
	     *  Getter & Setter for the owner of the AutoRefresher. This is 
	     *  done to support one of the key features of the AutoRefresher.
	     * 
	     *  <p>The AutoRefresher stops when the view on which its running 
	     *  is not visible. This is so that the refresher doesnt waste 
	     *  client/server resources when the view is not 
	     *  actually visible on the screen.</p>
	     * 
	     *  <p>If this attribute is not set, then the autorefresher just 
	     *  keeps on executing even if the screen is invisible.</p>
	     *
	     *  @param owner The owner of the AutoRefresher 
	     *  i.e The caller screen of the the AutoRefresher.
	     */
		public function set owner(owner:UIComponent):void{
			if(_refresherOwner != null) {
				_refresherOwner.removeEventListener(FlexEvent.HIDE, hideListener);
				_refresherOwner.removeEventListener(FlexEvent.SHOW, showListener);
			}
			_refresherOwner = owner;
			_refresherOwner.addEventListener(FlexEvent.HIDE, hideListener);
			_refresherOwner.addEventListener(FlexEvent.SHOW, showListener);
		}
		
		/**
	     *  Starts the refresher.
	     */
		public function start():void{
			if(timer && timer.running) timer.stop();
			if(timer == null){
				timer = new Timer(_delay,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			}
			
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

		/**
	     *  Stops the refresher if its running.
	     */
		public function stop():void{
			if(timer != null && timer.running)
				timer.stop();
		}

		/**
	     *  @private 
	     *  The function that will be fired the owner view
	     *  is made visible.
	     */
		private function showListener(event:FlexEvent):void{
			if(timer && !timer.running) {
				if(_refreshFunction != null) 
					_refreshFunction();
				if(_refresherOwner.visible) 
					timer.start();
			}
		}
		
		/**
	     *  @private 
	     *  The function that will be fired the owner view
	     *  is made invisible.
	     */
		private function hideListener(event:FlexEvent):void{
			if(timer != null && timer.running) 
				timer.stop();
		}

		/**
	     *  @private 
	     *  The function that will be fired whenever the timer
	     *  event occurs.
	     */
		private function onTimerComplete(event:TimerEvent):void{
			if(_refreshFunction != null) 
				_refreshFunction();
			start();
		}		
	}
}