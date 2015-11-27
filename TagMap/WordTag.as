package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;

	public class WordTag extends MovieClip
	{
		public function WordTag(inText:String = " ") 
		{
			field.text = inText;
			field.autoSize= TextFieldAutoSize.LEFT;
			alpha = 0;
			
			addEventListener (Event.ENTER_FRAME, fadeIn, false, 0, true);
		}
		
		private function fadeIn(event:Event):void {
			
			if (alpha < 1) {
				alpha += 0.1;
			} else {
				removeEventListener (Event.ENTER_FRAME, fadeIn);
			}
		}
		
		private function getWidth ():Number {
			return field.textWidth * scaleX;
		}
		
		private function getHeight ():Number {
			return field.textHeight * scaleY;
		}
		
		
		public function place (x0:Number, y0:Number, x1:Number, y1:Number) {
			
			var rx0:Number;
			var rx1:Number;
			
			var rWidth:Number = x1-x0;
			var rHeight:Number = y1-y0;
			
			var wWidth = getWidth();
			var wHeight = getHeight();
			
			var percent:Number;
			
			if (rHeight < 30) {
				percent = 100;
			} else {
				percent = Math.random() * 40 + 30;
			}
			
			var dWidth:Number = (percent * 0.01) * rWidth;
			var scale:Number = dWidth / wWidth;
			scaleX *= scale;
			scaleY *= scale;
			
			if (getHeight() > rHeight) {
				scale = rHeight / getHeight();
				scaleX *= scale;
				scaleY *= scale;
			}
		
			if ( flip() == 1 ) {
				rx0 = x0 + getWidth();
				rx1 = x1;
				x = x0;
					if ( flip() == 1) {
						y = y0;
						parent.wordTagRequest(rx0, y0, rx1, y0+getHeight());
						parent.wordTagRequest(x0, y0+getHeight(), x1, y1);
					} else {
						y = y1-getHeight();
						parent.wordTagRequest(rx0, y1-getHeight(), rx1, y1);
						parent.wordTagRequest(x0, y0, x1, y1-getHeight());
					}
			} else {
				rx0 = x0;
				rx1 = x1-getWidth();
				x = x1-getWidth();
					if ( flip() == 1) {
						y = y0;
						parent.wordTagRequest(x0, y0, rx1, y0+getHeight());
						parent.wordTagRequest(x0, y0+getHeight(), x1, y1);
					} else {
						y = y1-getHeight();
						parent.wordTagRequest(x0, y1-getHeight(), rx1, y1);
						parent.wordTagRequest(x0, y0, x1, y1-getHeight());
					} 
			}

		}
	
		private function flip():int {
			
			return Math.round (Math.random() * 2);
			
		}
		
	}

}







