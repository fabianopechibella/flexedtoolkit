package flexed.widgets.form.meta {
	public class MetaHelper {
		private static var metaData:MetaData=new MetaData();
		
		public function MetaHelper(_prettyNamesPath:String):void {
			
		}
		
		public static function prettyNames(group:String,tag:String):Object {
			return metaData.prettyNames(group,tag);
		}
		public static function prettyName(group:String,tag:String,name:String):String {
			return metaData.prettyName(group,tag,name);
		}

	}
}