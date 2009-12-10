package flexed.utils.location
{
	import flash.display.Sprite;
	import flash.events.FileListEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	[Event(name="pingStarted", type="LocationEvent")]
	[Event(name="filesAdded", type="LocationEvent")]
	[Event(name="maximumPings", type="LocationEvent")]
	[Event(name="pingTimeOut", type="LocationEvent")]
	[Event(name="pingTerminated", type="LocationEvent")]
	
	
	public class WatchDog extends Sprite
	{
		
		private var _className:String = flash.utils.getQualifiedClassName(this) as String; 
		private var _watchedLocation:File;
		private var _lastAddedFile:File;
		private var _pingTimer:Timer;
		private var _pingCounter:Number;
		private var _existingFiles:Array = new Array();
		private var _existingFileCount:int;
		private var _currentFiles:Array = new Array();
		private var _currentFileCount:int;
		private var _newFiles:Array = new Array();
		private var _lastFileCount:int;
	
		[Bindable] public var fileExtensions:Array;
		[Bindable] public var pingAutoRetire:Number;
		[Bindable] public var locationPath:String;
		[Bindable] public var pingFrequency:Number = 1000;
		[Bindable] public var maximumPings:Number;
		[Bindable] public var includeSystemFiles:Boolean = false;
		
		public function WatchDog():void{
			//do something here
		}
		
		public function startPinging(frequency:Number = 1000, autoRetire:Number = 0, maxPings:Number = 0):void{
			
			if(locationPath != null && locationPath.length > 1){
				_watchedLocation = new File();
				_watchedLocation.nativePath = locationPath;
				_watchedLocation.addEventListener(FileListEvent.DIRECTORY_LISTING, dirListHandler);
				
				pingFrequency = frequency;
				pingAutoRetire = autoRetire;
				
				if(maxPings > 0)
					maximumPings = maxPings;
				
				trace(_className + ": Location to watch - " + locationPath);
				trace(_className + ": Ping frequency set to - " + pingFrequency);
				
				if (_pingTimer == null) {
					if(pingAutoRetire > 0){
						_pingTimer = new Timer(pingFrequency, pingAutoRetire);
					}else{
						_pingTimer = new Timer(pingFrequency);
						trace(_className + ": Ping Auto Retire time not specified. Going on an ***infinite loop***!");
					}
					_pingTimer.addEventListener(TimerEvent.TIMER, pingTimerCounter);
				} else {
					_pingTimer.reset();
				}
				_pingCounter = 0;
				_pingTimer.start();
				
				trace(_className + ": WatchDog alert and watching folder.");
			}else{
				throw new Error("No Location specified!", 1001);
			}
		}
		
		protected function pingTimerCounter(event:TimerEvent):void{
			_pingCounter++;
			trace(_className + ": Bow!!! " + _pingCounter);
			_watchedLocation.getDirectoryListingAsync();
			if(maximumPings > 0){
				if(_pingCounter >= maximumPings){
					stopPinging();
					var data:Object = new Object();
					data.newFiles = _newFiles;
					var le:LocationEvent = new LocationEvent(LocationEvent.MAXIMUM_PINGS, data);
					this.dispatchEvent(le);
				}
			}
		}
		
		protected function dirListHandler(event:FileListEvent):void{
			_currentFiles = event.files as Array;
			_currentFiles.sortOn("creationDate");
			
			if(includeSystemFiles == false)
				_currentFiles = filterSysFiles(_currentFiles);
			
			if(fileExtensions.length > 0)
				_currentFiles = filterExtensions(_currentFiles, fileExtensions);
			
			_currentFileCount = _currentFiles.length;
			 
			if(_pingCounter == 1){
				_existingFiles = _currentFiles; //saving initial state
				_existingFileCount = _existingFiles.length;
				_lastFileCount = _currentFiles.length;
			}
			
			if(_currentFileCount != _lastFileCount){
				_newFiles = new Array();
				
				var _deltaFiles:Array = _newFiles = deltaFiles(_existingFiles, _currentFiles);
				
				var data:Object = new Object();
					data.files = _currentFiles;
					data.newFiles = _deltaFiles;
					data.newFileCount = _deltaFiles.length;
				
				if(_currentFileCount > _lastFileCount){
					trace(_className + ": WatchDog finds New file!");
					var leFilesAdded:LocationEvent = new LocationEvent(LocationEvent.FILES_ADDED, data);
					this.dispatchEvent(leFilesAdded);
				}
				
				_lastFileCount	 = _currentFileCount;
			}
		}
		
		
		public function stopPinging():void{
			trace(_className + ": Mission accomplished. WatchDog going to sleep.");
			_pingTimer.stop();
			var data:Object = new Object();
				data.newFiles = _newFiles;
			var event:LocationEvent = new LocationEvent(LocationEvent.PING_TERMINATED, data);
			this.dispatchEvent(event);
		}
		
		protected function deltaFiles(oldfiles:Array, newfiles:Array):Array{
			var delta:Array = new Array();
			
			// finding the new files
			for(var i:int = 0; i < newfiles.length; i++){
				if(indexOfFile(newfiles[i], oldfiles) == -1) delta.push(newfiles[i]);
			}

			return delta;
		}
		
		protected function indexOfFile(find:File, inArray:Array):int{
			var index:int = -1;
			
			for(var i:int = 0; i < inArray.length; i++){
				if(inArray[i].name == find.name)
					index = i;
			}
			
			return index;
		}
		
		protected function filterExtensions(allfiles:Array, extensions:Array):Array{
			var files:Array = new Array();
			
			// filtering only the files with required extensions
			if(extensions != null && extensions.length > 0){
				for each(var ext:String in extensions){
					for(var i:int = 0; i < allfiles.length; i++){
						if(allfiles[i].extension == ext) files.push(allfiles[i]);
					}
				}
			}
			
			return files;
		}
		
		protected function filterSysFiles(allfiles:Array):Array{
			var files:Array = new Array();

			// filtering system and hidden files from the final list
			for(var j:int = 0; j < allfiles.length; j++){
				if(allfiles[j].isHidden == false && allfiles[j].isDirectory == false) files.push(allfiles[j]);
			}
			
			return files;
		}

	}
}