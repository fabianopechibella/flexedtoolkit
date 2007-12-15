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
// @file: alert
// @author: Uday M. Shankar
// @date: 31-03-2007
// @description: Extending the Alert to create more customized alerts 
// with predefined icons etc.
//
////////////////////////////////////////////////////////////////////////////////
package flexed.widgets.alerts
{
	import mx.controls.Alert;
	
	public class alert extends Alert
	{
		[Embed(source="alert_error.gif")]
		private static var iconError:Class;
		
		[Embed(source="alert_info.gif")]
		private static var iconInfo:Class;
		
		[Embed(source="alert_confirm.gif")]
		private static var iconConfirm:Class;

		public static function info(message:String, closehandler:Function=null):void{
			show(message, "Information", Alert.OK, null, closehandler, iconInfo);
		}
		
		public static function error(message:String, closehandler:Function=null):void{
			show(message, "Error", Alert.OK, null, closehandler, iconError);
		}
		
		public static function confirm(message:String, closehandler:Function=null):void{
			show(message, "Confirmation", Alert.YES | Alert.NO, null, closehandler, iconConfirm);
		}

	}
}