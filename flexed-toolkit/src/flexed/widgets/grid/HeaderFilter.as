package flexed.widgets.grid
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ComboBox;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.events.DynamicEvent;
	
	[Event(name="headerfiltered",type="mx.events.DynamicEvent")]
	
	public class HeaderFilter extends ComboBox 
	{
		
		
		private var clickedColumn:DataGridColumn = new DataGridColumn();
		
		[Bindable] private var filterBy:ArrayCollection = new ArrayCollection();
		[Bindable] private var colName:String = "Filter";
		
		public function HeaderFilter():void{
			super();
			addEventListener("change", filterHandler);
			dataProvider = filterBy;
			prompt = colName;
		}
		
		private function getFilters():ArrayCollection{
			if(filterBy.length < 1){
				var gridData:Array = DataGrid(this.listData.owner).dataProvider.source as Array;
				filterBy = new ArrayCollection();
				var str:String = DataGridListData(this.listData).dataField.toString();
				
				var objCopy:Object = new Object();
				var obj:Object = new Object();
					obj["label"] = obj["data"] = "All";
					filterBy.addItem(obj);
					
				for each(var item:Object in gridData){
					obj = new Object();
					var val:String = item[str].toString();
					obj["label"] = obj["data"] = val;
					if(objCopy[val] == null){
						filterBy.addItem(obj);
						objCopy[val] = val;
					}
				}
			}
			return filterBy;
		}
		
		override public function set data(value:Object):void{
			clickedColumn = value as DataGridColumn;
			prompt = clickedColumn.headerText;
			
			dataProvider = filterBy = getFilters();
			
		}
		
		private function filterHandler(event:Event):void{
			var de:DynamicEvent = new DynamicEvent("headerfiltered", true);
				de.colname = clickedColumn.dataField;
       			dispatchEvent(de);
		}
		
	}
}