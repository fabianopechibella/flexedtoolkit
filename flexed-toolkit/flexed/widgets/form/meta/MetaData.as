package flexed.widgets.form.meta {
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class MetaData {
		public var _prettyNames:Object;
		private var xmlFile:String = "";
		
		public function MetaData(filePath:String = "prettyNames.xml"):void {
			xmlFile = filePath;
			init();
		}
		private function init():void {
			_prettyNames=new Object();
			loadMetaFile(xmlFile, prettyNamesLoaded);
		}

		private function loadMetaFile(metaFile:String,completeFunction:Function):void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, completeFunction);

			var request:URLRequest = new URLRequest(metaFile);
			loader.load(request);			
		}
		
		private function prettyNamesLoaded(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			var prettyNamesXML:XML = new XML(loader.data);
			
			var groups:XMLList=prettyNamesXML.elements("group");
			
			
			for each(var group:XML in groups) {
				var groupObj:Object=new Object();
				var groupName:String=group.attribute("name").toString();
				
				groupObj.name=groupName;
				
				
				var tags:String=group.descendants("tag");
				
				for each(var tag:XML in tags) {
					var tagObj:Object=new Object();
					var tagName:String=tag.attribute("name").toString();
					var tagRef:String=tag.attribute("ref").toString();
					
					tagObj.name=tagName;
					
					if(tagRef!=null && tagRef!="") {
						tagObj.ref=tagRef;
					} else {
						tagObj.prettyNames=new Object();
						
						var prettyNames:Object=tag.descendants("prettyName");
						for each(var prettyName:XML in prettyNames) {
							var _name:String=prettyName.attribute("name").toString();
							var _value:String=prettyName.attribute("value").toString();
							
							tagObj.prettyNames[_name]=_value;
						}
					}
				
					groupObj[tagName]=tagObj;
				}
				
				_prettyNames[groupName]=groupObj;
			}
		}
		public function prettyNames(group:String,tag:String):Object {
			var groupObj:Object=_prettyNames[group];
			if(groupObj!=null) {
				var tagObj:Object=groupObj[tag];
				
				if(tagObj!=null) {
					if(tagObj.ref!=null) {
						var tmp:Array=tagObj.ref.split(".");
						if(tmp.length==2) {
							return prettyNames(tmp[0],tmp[1]);
						}
					} else if(tagObj.prettyNames!=null) {
						return tagObj.prettyNames;
					}
				}
			}
			return null;
		}
		public function prettyName(group:String,tag:String,name:String):String {
			var _prettyNames:Object=prettyNames(group,tag);
			if(_prettyNames!=null) {
				return _prettyNames[name];
			}

			return null;
		}
		
	}
}