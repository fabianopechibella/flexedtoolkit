package flexed.widgets.buttons
{
    import mx.controls.Button;
    
    public class CButton extends Button
    {
        public static var SAVE:int       = 1;
        public static var OK:int         = 2;
        public static var CANCEL:int     = 3;

        [Embed("btn_save.png")]
        private var saveIcon:Class;
        [Embed("btn_ok.png")]
        private var okIcon:Class;
        [Embed("btn_cancel.png")]
        private var cancelIcon:Class;
                
        public function CButton (btnType:int=0):void{
            this.width = 80;					//setting predefined width
            this.height = 30;					//setting predefined height
            this.setStyle("paddingLeft",5);		//setting predefined padding
            
            if(btnType == SAVE)
            {
                this.label = "Save";			//setting predefined label
                this.setStyle("icon", saveIcon);//setting icon based on info from caller
            } 
			else if(btnType == OK)
            {
                this.label = "OK";
                this.setStyle("icon", okIcon);
            }
			else if(btnType == CANCEL)
            {
                this.label = "Cancel";
                this.setStyle("icon", cancelIcon);
            }
        }
    }
}