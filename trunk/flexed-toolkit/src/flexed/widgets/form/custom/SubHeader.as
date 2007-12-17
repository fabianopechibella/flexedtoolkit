package flexed.widgets.form.custom
{
	import flash.display.DisplayObject;
	
	import flexed.widgets.form.DefaultConfig;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.HRule;
	import mx.controls.Label;
	import mx.controls.Spacer;
	
	public class SubHeader extends VBox
	{
		[Bindable] public var headerStyle:String = DefaultConfig.GENERAL_GROUP_STYLE;
		[Bindable] public var lineStyle:String = DefaultConfig.GENERAL_GROUPHR_STYLE;
		[Bindable] public var subHeaderText:String = "";
		[Bindable] public var showLine:Boolean = false;
		
		private var controlBar:HBox = new HBox();
		private var hbxInnerContainer:HBox = new HBox();
		private var grpHeader:Label = new Label();
		private var spacer:Spacer = new Spacer();
		private var line:HRule = new HRule();
		
		
		public function SubHeader():void{
			createHeader();
		}
		
		
		private function createHeader():void{
			this.id = "vbxBaseContainer";
			this.percentWidth = 100;
			this.setStyle("verticalGap",1);
		
			hbxInnerContainer.id = "hbxInnerContainer";
			hbxInnerContainer.percentWidth = 100;
			hbxInnerContainer.percentHeight = 100;
			hbxInnerContainer.setStyle("verticalAlign", "middle");
			hbxInnerContainer.setStyle("horizontalGap", 1);
		
			grpHeader.id = "lblGroupHeader";
			grpHeader.styleName = headerStyle;
			grpHeader.text = subHeaderText;
			hbxInnerContainer.addChild(grpHeader);
		 
			spacer.id = "spacer";
			spacer.percentWidth = 100;
			hbxInnerContainer.addChild(spacer);
		
			controlBar.id = "grpControls";
			controlBar.setStyle("horizontalGap", 1);
			hbxInnerContainer.addChild(controlBar);
		
			line.id = "grpHeaderLine";
			line.visible = showLine;
			line.styleName = DefaultConfig.GENERAL_GROUPHR_STYLE;
			
			this.addChild(hbxInnerContainer);
			this.addChild(line);
		}
		
		public function addControls(control:DisplayObject):void{
			controlBar.addChild(control);
		}
		
		public function removeControls(control:DisplayObject):void {
			controlBar.removeChild(control);
		}
		
	}
}