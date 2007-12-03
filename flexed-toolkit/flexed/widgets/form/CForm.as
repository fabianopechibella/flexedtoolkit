 package flexed.widgets.form
{
	/**
	 *  The CForm allows users to create entry forms very easily. CForm picks up 
	 *  field names, types and attributes from an xml file and lays out the form.
	 *  The values entered in the form are available by single methods exposed. For
	 *  further information on these, check out the Methods section.
	 *
	 *  @mxml
	 *
	 *  <p>Using this component in the application is very simple. Use the following 
	 *  syntax for basic usage:</p>
	 *  &lt;flexed:CForm id="exampleCform" widgetsFile="controls.xml" width="100%" height="100%" /&gt;
	 */

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import flexed.widgets.form.custom.SectionTitle;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.containers.HBox;
	import mx.controls.Alert;
	import mx.controls.HRule;
	import mx.controls.Label;
	import mx.events.DynamicEvent;
	import mx.rpc.events.*;
	import mx.validators.ValidationResult;
	
	/**
	 *  CFormLoadComplete is dispatched after all the controls are created
	 *  and the properties array is created. 
	 *
	 *  @eventType mx.events.DynamicEvent
	 *
	 *  @see mx.events.DynamicEvent
	 */		 
	[Event(name="CFormLoadComplete", type="mx.events.DynamicEvent")]
	
	public class CForm extends Canvas
	{
		
		private var BASE_CONTAINER:HBox = new HBox();
		
		// object that will contain all the widgets
		public var widgets:Object;
		// path of the widgets file
		public var widgetsFile:String;
		// the xml of all widgets
		public var widgetsXML:XML;
		// array containing fieldTypes
		public var fieldType:Array = new Array();
		// data that is loaded to cform using the setData() method
		public var originalData:Array = new Array();
		// data that is loaded to cform using default values from xml  
		public var defaultData:Array = new Array();
		// columns in the layout grid
		public var gridColumns:Array = new Array();
		// number of columns
		public var columns:int;
		
		// the custom function fired by caller to customize cform 		
		private var _customizeCForm:Function;
		// function to update cform
		private var _updateCForm:Function;
		// the gap between the label and the renderer
		private var _indicatorGap:int = DefaultConfig.GENERAL_INDICATORGAP;
		// entire contents of the xml file
		private var _xmlContent:XML = new XML();
		
		public function CForm():void{
			prepareCForm();
			init();
		}
		
		private function prepareCForm():void{
			BASE_CONTAINER.id = "cont";
			BASE_CONTAINER.percentHeight = 100;
			BASE_CONTAINER.percentWidth = 100;
			BASE_CONTAINER.horizontalScrollPolicy = "off";
			BASE_CONTAINER.verticalScrollPolicy = "off";
			BASE_CONTAINER.setStyle("horizontalGap",8);
			BASE_CONTAINER.setStyle("paddingTop", 4);
			BASE_CONTAINER.setStyle("paddingBottom", 4);
			BASE_CONTAINER.setStyle("paddingLeft", 4);
			BASE_CONTAINER.setStyle("paddingRight", 4);
			this.addChild(BASE_CONTAINER);	
		}
		
		public function init():void{
			initCForm();
		}

		/**
		 * @private 
		 * Initializes the CForm. Loads the widgets xml file.
		 *
		 * Called on <i>creationComplete</i>.
		 * 
		 */
		private function initCForm(event:Event = null):void{
			if(widgetsFile != null) createCForm(widgetsFile);
		}		
		
		/**
		 *  Sets a custom function specified by the caller. This
		 *  function can be used to manipulate fields in the CForm. 
		 *
		 *  @param customizer The custom function located in the caller, 
		 *  which will be fired on the CForm
		 *
		 */
		public function set cFormCustomizer(customizer:Function):void{
			this._customizeCForm = customizer;
		}
		
		/**
		 *  Returns the custom function (if there is one) specified by the caller.
		 *
		 *  @return The custom function
		 *
		 */
		public function get cFormCustomizer():Function{
			return _customizeCForm;
		}

		/**
		 *  Need to document this.
		 *
		 */
		public function set cFormUpdater(updater:Function):void{
			this._updateCForm = updater;
		}

		/**
		 *  Need to document this.
		 *
		 */
		public function get cFormUpdater():Function{
			return _updateCForm;
		}

		/**
		 *  Returns the entire xml content 
		 *  of the controls xml.
		 *
		 *  @return XML from the controls xml
		 *
		 */
		public function get xmlContent():XML{
			return _xmlContent;
		}

		/**
		 *  Returns the entire xml content 
		 *  of the controls xml.
		 *
		 *  @return XML from the controls xml
		 *
		 */
		public function get isDirty():Boolean{
			var obj:Object = this.getData();
			if(obj != null)
				return true;
			else
				return false;
		}

		/**
		 *  Need to document this.
		 *  Custom validation for the form. This will be 
		 *  used in <code>validateCForm</code>
		 *
		 */
		public function set cFormValidation(validatorFunction:Function):void{
			_customizeCForm = validatorFunction;
		}
		
		/**
		 *  This returns all the values from the form. The original values 
		 *  that were set by the caller.
		 *
		 *  @return Original values from the form. 
		 *
		 */
		public function fetchCFormValues():Array{
			return originalData;
		}

		/**
		 *  @private
		 *  This returns all the values from the form. The original values 
		 *  that were set by the caller.
		 *
		 *  @return Original values from the form. 
		 *
		 */	
		private function createCForm(widgetsFile:String): void{
			var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, loadFromXML);
			
			var request:URLRequest = new URLRequest(widgetsFile);
				loader.load(request);
		}

		/**
		 *  @private
		 *  Fired on Event.COMPLETE  of URLLoader in createCForm
		 *
		 *  @param event Original values from the form. 
		 *
		 */	
		private function loadFromXML(event:Event): void{ 
			var loader:URLLoader = URLLoader(event.target);
			widgetsXML = new XML(loader.data);
			_xmlContent = widgetsXML;
			layoutCForm(widgetsXML);
		}
		


		/**
		 *  @private
		 *  Renders all UI components in specified group and column.
		 *
		 *  @param widgetsXML  XML component created based on user 
		 *  specified field xml file. It will have the list of fields 
		 *  grouped together to display with the columns.
		 *
		 *  @event <i>CFormLoadComplete eventObjectClassName [description]</i> 
		 *
		 */			
		private function layoutCForm(widgetsXML:XML): void{
			var alertFlag:Boolean = false;
					
			var groups:XMLList = widgetsXML.descendants("group");
			var label:String  = widgetsXML.descendants("label");
			var cols:String = widgetsXML.attribute("columns").toString();
			var verticalgap:String = widgetsXML.attribute("vgap").toString();
			var indigap:String = widgetsXML.attribute("igap").toString();
			var vgap:int = DefaultConfig.GENERAL_VERTICALGAP;
			
			this.label = label.toString();

			if (cols != "")	
				this.columns = int(cols);
			else 
				this.columns = 0;

			if (verticalgap!=null && verticalgap!="") 
				vgap=int(verticalgap);

			if (indigap!=null && indigap!="") 
				_indicatorGap=int(indigap);

			for (var colCount:int = 0; colCount < this.columns; colCount++) 
			{
				var grid:Grid = new Grid();
				grid.id = grid + colCount.toString();
				grid.setStyle("verticalGap", vgap);
				grid.percentHeight = 100;
				grid.percentWidth = 100;
				BASE_CONTAINER.addChild(grid);
				gridColumns[colCount+1] = grid;
			}
			
			widgets = new Object();
			for each(var group:XML in groups) {
				var whichColumn:String = group.attribute("column").toString();
				var currentColumn:int;

				if (whichColumn != "") 
					currentColumn = int(whichColumn);
				else 
					currentColumn = 0;

				if(currentColumn > 0 && currentColumn <= columns){
					layoutCFormGroup(group, currentColumn);
				}else{
					if(alertFlag != true){
						Alert.show("Error in the columns specified.","Screen Layout Error");
						alertFlag = true;
					}
				}		
			}

			var event:DynamicEvent=new DynamicEvent("CFormLoadComplete");
			dispatchEvent(event);
		}

		/**
		 *  @private
		 *  Renders UI components of a group in the specified column.
		 *
		 *  @param groupXML  Fields falling under a group.
		 *  @param currentColumn Column number for layout.
		 *
		 */	
		private function layoutCFormGroup(groupXML:XML, currentColumn:int):void{
			var rows:XMLList=groupXML.descendants("row");
			var row:XML;

			var eachWidget:Array = new Array();
			var name:String = groupXML.attribute("label").toString();

			var grid:Grid = gridColumns[currentColumn];

			var gTitleItem:GridItem = null;
			var gHruleItem:GridItem = null;
			
			if (name != '') {
				var title:Label = new Label();
				title.text = name;
				title.styleName = DefaultConfig.GENERAL_TITLE_STYLE;
				
				var hRule:HRule = new HRule();
				hRule.percentWidth = 100;
				hRule.styleName = DefaultConfig.GENERAL_TITLEHR_STYLE;
				
				var gTitlerow:GridRow = new GridRow();				
				gTitleItem = new GridItem();
				gTitleItem.addChild(title);
				gTitleItem.colSpan = 2;
				gTitleItem.percentWidth = 100;
				gTitlerow.addChild(gTitleItem);
				
				var gHrulerow:GridRow = new GridRow();
				gHruleItem = new GridItem();
				gHruleItem.addChild(hRule);
				gHruleItem.colSpan = 2;
				gHruleItem.percentWidth = 100;
				gHrulerow.addChild(gHruleItem);
				
				grid.addChild(gTitlerow);
				grid.addChild(gHrulerow);
				
			}
			var maxcolspan:int=2;
			var defaultDataLength:int = 0;
			for each(row in rows) {
				var fields:XMLList = row.descendants("field"); 
				var field:XML;
				
				var gItemrow:GridRow=new GridRow();
				var colspan:int=0;
				var gItemrow1:GridRow=new GridRow();
				var hasChild : Boolean = false;
				for each(field in fields) {
	            	eachWidget = new Array();
	            	var fieldId:String = field.attribute("id").toString();
	            	fieldId = fieldId.replace(/ /g,"");
	            	var fieldName:String = null; 
	            	if(field.attribute("label").length()!= 0)
	            		fieldName = field.attribute("label").toString();
					var tooltip:String = null;
	            	if(field.attribute("tooltip").length()!= 0)
	            		tooltip = field.attribute("tooltip").toString();
	            	var defaultVal:String = null;
	            		
	            	eachWidget["fieldId"] = fieldId;
					eachWidget["default"] = defaultVal;
					eachWidget["field"] = field;
					
					hasChild = true;
	            	var gLabel:GridItem=new GridItem();
	            	var gItemlabel:Label=new Label();
	            		gItemlabel.text = fieldName;
	            	var styleName:String = DefaultConfig.GENERAL_LABEL_STYLE; 
	            	
	            	if (field.child("label").attribute("style").toString()!=""){
	            		styleName=field.child("label").attribute("style").toString();
	            	}

	            	if (field.child("label").attribute("height").toString()!=""){
	            		gItemlabel.height=int(field.child("label").attribute("height"));
	            	}
	            	
	            	gItemlabel.styleName=styleName;
	            	gItemlabel.toolTip=tooltip;
	            	gLabel.addChild(gItemlabel);
	            	
	            	var renderer:CFormItemRenderer = createCFormItemRenderer(fieldId, fieldName, field, fields);
	            	renderer.getUIComponent().name = fieldId;
	            	
	            	if (field.child("widget").attribute("style").toString()!="")
		            	renderer.getUIComponent().styleName=field.child("widget").attribute("style").toString();
	            	
	            	if(field.child("widget").attribute("default").toString() != "")
	            		defaultVal = field.child("widget").attribute("default").toString();
					
					// storing defaultval in an object					
					defaultData[fieldId] = defaultVal;
					defaultDataLength++;
	            	
	            	var gItemvalue:GridItem = new GridItem();
	            	gItemvalue.addChild(renderer.getUIComponent());
	            	
	            	if(renderer.getUIComponent() is SectionTitle){
	            		gItemvalue.colSpan = 2;
	            		gItemrow.addChild(gItemvalue);
	            	}else{
		            	if(fieldName!=null) {
		            		if (((field.child("label").attribute("enableNextrow").toString()=="true")||(groupXML.attribute("enableNextrow").toString()=="true")) && (field.child("label").attribute("enableNextrow").toString()!="false")){
		            			gLabel.colSpan=2;
		            			gItemrow.addChild(gLabel);
		            		}else{
	            				gItemrow.addChild(gLabel);
		            		}
		            		colspan++;
		            	}
		            	
		            	if (((field.child("label").attribute("enableNextrow").toString()=="true")||(groupXML.attribute("enableNextrow").toString()=="true")) && (field.child("label").attribute("enableNextrow").toString()!="false")){
	            			gItemvalue.colSpan=2;
	            	 		gItemrow1.addChild(gItemvalue);   
		            	}else{
							gItemrow.addChild(gItemvalue);
		            	}
		            	
		            	if(field.child("widget").attribute("colspan").length()!=0) {
		            		var span:int=int(field.child("widget").attribute("colspan").toString());
		            		gItemvalue.colSpan=span;
		            		colspan=colspan+span;
		            	}else {
		            		colspan++;
		            	}
	            	}
	            	eachWidget["formItem"] = gItemlabel;
	            	eachWidget["renderer"] = renderer;
	            	widgets[fieldId] = eachWidget;
				}
				defaultData["length"] = defaultDataLength;
				
				if(hasChild == true){
					grid.addChild(gItemrow);
					if (((field.child("label").attribute("enableNextrow").toString()=="true")
							||(groupXML.attribute("enableNextrow").toString()=="true")) 
						&& (field.child("label").attribute("enableNextrow").toString()!="false"))
							grid.addChild(gItemrow1);
				}
				maxcolspan=Math.max(maxcolspan,colspan);
			}
			if(gTitleItem!=null) gTitleItem.colSpan=maxcolspan;
			if(gHruleItem!=null) gHruleItem.colSpan=maxcolspan;			

			if (name != '') {
				var grow:GridRow=new GridRow();
				grid.addChild(grow);
			}
		}
	
		/**
		 *  @private
		 *  Create each formItem using the renderers
		 *
		 *  @param id Id of the control
		 *  @param name Name of the control
		 *  @param field The XML containing the field details
		 *  @param fields An XML List of all fields
		 *
		 *  @return CFormItemRenderer Output of <code>renderDefaultItem</code> 
		 *
		 */			
		private function createCFormItemRenderer(id:String, name:String, field:XML, fields:XMLList):CFormItemRenderer {
        	var widget:XMLList = field.child("widget");
        	var widgetType:String = widget.attribute("type").toString();
        	fieldType[id] = widgetType;
        	if(widgetType == "table"){
        		var column :XMLList = widget.child("column");
        		return renderDefaultItem(widgetType,widget,column);
        	}
        	else{
        		return renderDefaultItem(widgetType, widget);
        	}
		}
		
		/**
		 *  @private
		 *  Create each formItem using default custom renderers
		 *
		 *  @param widgetType Type of control
		 *  @param attributes XML List of attributes of the control
		 *  @param columns The XML List containing the column info
		 *
		 *  @return renderer Created from the passed parameters
		 *
		 */
		private function renderDefaultItem(widgetType:String, attributes:XMLList, columns:XMLList= null):CFormItemRenderer {
			var renderer:CFormItemRenderer;
			var defaultVal:String = attributes.attribute("default").toString();
			if(widgetType.toLocaleLowerCase() == "radiogroup") {
				var rdos:Array = new Array();
				var items:XMLList=attributes.descendants("item");
				var selectedItem:String = "";
				for each(var item:XML in items) {
                	var rdoAttribs:Object=new Object();
						rdoAttribs.label = item.attribute("label").toString();
						rdoAttribs.data = item.attribute("data").toString();
						rdoAttribs.value =  item.attribute("selected").toString();
					rdos.push(rdoAttribs);
            	}
            	renderer = new CFormItemRadioButtonGroup(rdos);
			} else if(widgetType.toLocaleLowerCase() == "display") {
				renderer = new CFormItemDisplay();
				CFormItemDisplay(renderer).setAttributesFromXML(attributes);
				CFormItemDisplay(renderer).setValue(defaultVal);
			} else if(widgetType.toLocaleLowerCase() == "dualdisplay") {
				renderer = new CFormItemDualDisplay();
				CFormItemDualDisplay(renderer).setAttributesFromXML(attributes);
				CFormItemDualDisplay(renderer).setValue(defaultVal);
			} else if(widgetType.toLocaleLowerCase() == "stepper") {
				renderer = new CFormItemNumericStepper();
				CFormItemNumericStepper(renderer).setAttributesFromXML(attributes);
				CFormItemNumericStepper(renderer).setValue(defaultVal);
			} else if(widgetType.toLocaleLowerCase() == "date") {
				renderer = new CFormItemDate();
				CFormItemDate(renderer).setAttributesFromXML(attributes);
				CFormItemDate(renderer).setValue(defaultVal);
			} else if(widgetType.toLocaleLowerCase() == "combobox") {
				renderer = new CFormItemCombobox();
				var dataProvider:ArrayCollection = new ArrayCollection();
				var cmboitems:XMLList=attributes.descendants("item");
				var selectedCmboItem:String = "";
				for each(var cmboitem:XML in cmboitems) {
                	var _data:Object=new Object();
					_data.label = cmboitem.attribute("label").toString();
					_data.data = cmboitem.attribute("data").toString();
					dataProvider.addItem(_data);
					if(cmboitem.attribute("selected").toString() == "true") selectedCmboItem =  cmboitem.attribute("data").toString();
            	}
				CFormItemCombobox(renderer).setDataProvider(dataProvider);
				CFormItemCombobox(renderer).setAttributesFromXML(attributes);
				if(selectedItem != "") CFormItemCombobox(renderer).setValue(selectedCmboItem);
			} else if(widgetType.toLocaleLowerCase() == "textarea") {
				renderer = new CFormItemTextArea();
				CFormItemTextArea(renderer).setAttributesFromXML(attributes);
				CFormItemTextArea(renderer).setValue(defaultVal);
			} else if(widgetType.toLocaleLowerCase() == "dualtext") {
				renderer = new CFormItemDualText();
				CFormItemDualText(renderer).setAttributesFromXML(attributes);
				CFormItemDualText(renderer).setValue(defaultVal);
			} else if (widgetType.toLocaleLowerCase() == "table") {
				renderer = new CFormItemTable();
				var tableAttribs:XMLList = attributes.descendants("column");
				CFormItemTable(renderer).setAttributesFromXML(attributes)
				CFormItemTable(renderer).setColumns(columns);
			} else if (widgetType.toLocaleLowerCase() == "title") {
				renderer = new CFormItemTitle();
				CFormItemTitle(renderer).setAttributesFromXML(attributes);
				CFormItemTitle(renderer).setValue(defaultVal);
			} else if (widgetType.toLocaleLowerCase()=="spacer"){
				renderer = new CFormItemSpace();
				CFormItemSpace(renderer).setAttributesFromXML(attributes);
			}else {
				renderer = new CFormItemText();
				CFormItemText(renderer).setAttributesFromXML(attributes);
				CFormItemText(renderer).setValue(defaultVal);
			}
			return renderer;
		}

		/**
		 *  @private
		 *  Set the values passed in to the controls in CForm
		 *
		 *  @param values an Object containing values 
		 *
		 */
		private function setFormValues(values:Object, mode:String = "original"):void {
			var widget:Array;
			var key:String;
			
			originalData = new Array();
			var originalDataLength:int = 0;
			for (key in widgets) {
				if (values[key] != null) {
					widgets[key]["renderer"].setValue(values[key]);
					if(mode == "original")
						originalData[key] = values[key];
				} else if(values[key]==null){
					if (widgets[key]["renderer"] is CFormItemDisplay)
						widgets[key]["renderer"].setValue("-");
					else if (widgets[key]["renderer"] is CFormItemText)
						widgets[key]["renderer"].setValue("");
				}
				originalDataLength++;
			}
			originalData["length"] = originalDataLength;
		}

		/**
		 *  Resets the values in the controls to empty or 0 
		 *
		 */
		public function resetCForm():void {
			var widget:Array;
			var key:String;
			for (key in widgets) {
				if (widgets[key]["renderer"] is CFormItemText || widgets[key]["renderer"] is CFormItemTextArea)
					widgets[key]["renderer"].setValue("");	
				else if(widgets[key]["renderer"] is CFormItemCombobox)
					widgets[key]["renderer"].getUIComponent().selectedIndex=0;	
				else if(widgets[key]["renderer"] is CFormItemDisplay)
					widgets[key]["renderer"].setValue("");
				else if(widgets[key]["renderer"] is CFormItemRadioButtonGroup)
					widgets[key]["renderer"].setValue(null);
				else if(widgets[key]["renderer"] is CFormItemNumericStepper)
					widgets[key]["renderer"].setValue(0);
			}
		}
		
		/**
		 *  Resets the value of the controls. Boolean Control will 
		 *  have none of the controls selected. Text Fields will be made empty.
		 *
		 */
		private function resetCFormItem():void{
			for each(var widget:Array in widgets) {
				var xmlWidget:XMLList = widget["field"].child("widget");
	        	var widgetType:String = xmlWidget.attribute("type").toString();
				if(widgetType.toLowerCase() == "radiogroup"){
					widget["renderer"].setValue(null);
				}else if(widgetType.toLowerCase() == "text"){
					widget["renderer"].setValue("");
				}
			}
		}
		
			
		/**
		 *  Set the values passed in to the controls in CForm
		 *  <span style="hide">Why is there two methods for the same purpose?</span>
		 *
		 *  @param values an Object containing values 
		 *
		 */
		public function setData(values:Object):void {
			var vals:Object=new Object();
			
			var widget:Array;
			var key:String;
			for (key in widgets) {
				var value:Object = values[key];
				
				if(key.indexOf(".")!=-1) {
					var tmp:Array=key.split(".");
					var _tmp0:String=tmp[0];
					var _tmp1:String=tmp[1];
					var _tmp2:String=tmp[2];
					
					if(tmp.length>2){
						if(values[_tmp0][_tmp1]) value=values[_tmp0][_tmp1][_tmp2];					
					}else{
						if(values[_tmp0]) value=values[_tmp0][_tmp1];
					}
				}
				vals[key]=value;
			}			
			setFormValues(vals);
		}

		/**
		 *  Gets values from CForm 
		 *
		 *  @param onlyModifiedValues If <code>true</code> is 
		 *  passed, only modified items are returned. if <code>false</code> 
		 *  is passed, all the values are returned.
		 *
		 *  @default true
		 *
		 */		
		public function getData(onlyModifiedValues:Boolean=true):Object {
			var obj:Object=new Object();
			var values:Object=getCFormValues(onlyModifiedValues);
			return values;
		}		

		/**
		 *  @private
		 *  Called by <code>getData</code>. Soon <code>getCFormValues</code> will be made private 
		 *  and all external calls for <code>getCFormValues</code>
		 *	replaced by <code>getData</code>
		 * 
		 *  @param onlyModifiedValues If <code>true</code> is 
		 *  passed, only modified items are returned. if <code>false</code> 
		 *  is passed, all the values are returned.
		 *
		 *  @default true		 
		 *
		 */
		private function getCFormValues(onlyModifiedValues:Boolean=true): Object {
			var values:Object=new Object();
			if(originalData.length == 0)
				originalData = defaultData;
					
			for each(var widget:Array in widgets) {
				var fieldId:String = widget["fieldId"];
				var currentValue:Object = widget["renderer"].getValue();
				var originalValue:Object = originalData[widget["fieldId"]];
				if(currentValue == null)
					continue;
				
	        	var xmlWidget:XMLList = widget["field"].child("widget");
	        	var widgetType:String = xmlWidget.attribute("type").toString();
	        	if (widgetType.toLowerCase() == "radiogroup" && (originalValue != null)) {
	        		originalValue = String(originalValue);
	        	}else if (widgetType.toLowerCase() == "display" && onlyModifiedValues)
	        		continue;
	        	else if (widgetType.toLowerCase() == "table" && onlyModifiedValues)
	        	    continue;
	        	else if(widgetType.toLowerCase() == "title"){
	        		continue;
	        	}
	        	else{
	        		originalValue = (originalValue == null)? "" : originalValue;
	        	}
				if(currentValue == originalValue && onlyModifiedValues) 
					continue;
				values[fieldId] = currentValue;
			}

			return values;
		}

		/**
		 *  @private
		 *  Validate the CForm using the custom 
		 *  validation function specified using <code>cFormCustomizer</code>
		 *
		 *  @return Boolean based on whether the content of 
		 *  the form pass validation or not.
		 *
		 */			
		private function validateCForm():Boolean {
			var valid:Boolean=true;
			if(_customizeCForm!=null) {
				var values:Object=getCFormValues(false);
				for (var key:String in values) {
					var result:ValidationResult = _customizeCForm(key, values[key], values);
					if(result.isError) {
						widgets[key].renderer.getUIComponent().errorString = result.errorMessage;
						valid=false;
					} else {
						widgets[key].renderer.getUIComponent().errorString="";
					}
				}
			}
			return valid;
		}

		/**
		 *  Returns the renderer of the control with the passed 
		 *  id. This is useful, if caller wants to perform specific 
		 *  actions on select controls in CForm. Eg:- Setting 
		 *  dataproviders dynamically to combo drop downs.
		 *
		 *  @param id Id of the control
		 *
		 *  @return CFormItemRenderer If renderer is found, else return null
		 *
		 */
		public function getRenderer(id:String):CFormItemRenderer {
			if(widgets[id]) return widgets[id]["renderer"];
			return null;
		}
		
		/**
		 *  Removes all controls from the container.
		 *
		 */
		public function clearCform():void{
			BASE_CONTAINER.removeAllChildren();
		}

	}
}