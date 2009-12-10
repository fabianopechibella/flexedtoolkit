package flexed.utils.location
{
	import flash.events.Event;
	
	/**
	 * Event class for the Location WatchDog
	 * @author Uday M. Shankar (udayms@gmail.com)
	 * 
	 */	
	public class LocationEvent extends Event
	{
		
		/**
		 * 
		 * */		
		public static const FILES_ADDED:String = "filesAdded";
		
		/**
		 * 
		 * */		
		public static const MAXIMUM_PINGS:String = "maximumPings";
		
		/**
		 * 
		 * */		
		public static const PING_TERMINATED:String = "pingTerminated";
		
		/**
		 * 
		 * */		
		public static const PING_TIMEOUT:String = "pingTimeout";
		
		/**
		 * 
		 * */		
		public static const PING_STARTED:String = "pingStarted";
				
		
		/**
		 * The event data object.
		 */		
		protected var $data:Object;
		
		/**
		 * Creates a new LocationEvent object.
		 * @param type
		 * @param data
		 * @param bubbles
		 * @param cancelable
		 * 
		 */		
		public function LocationEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.$data = data;
		}
		
		/**
		 * The event data object. 
		 * @return 
		 * 
		 */		
		public function get data():Object
		{
			return $data;
		}
		
		/**
		 * The event data object.
		 * @param value
		 * 
		 */		
		public function set data(value:Object):void
		{
			this.$data = value;
		}
		
		/**
		 * Duplicates an instance of an LocationEvent class.
		 * @return
		 */
		override public function clone():Event
		{
			return new LocationEvent(type,data,bubbles,cancelable);
		}
		
		/**
		 * Returns a string containing all the properties of the Event object.
		 * @return
		 */ 
		override public function toString():String 
		{
			return formatToString("LocationEvent", "type", "data", "bubbles", "cancelable", "eventPhase");
		}
	}
}