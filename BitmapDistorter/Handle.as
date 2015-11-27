
package  
{
	import flash.display.Sprite;
	import flash.events.*;
		
	public class Handle extends Sprite
	{
		public function Handle (inX:Number, inY:Number) 
		{
			this.x = inX;
			this.y = inY;
			
			this.graphics.lineStyle (3, 0x572025, 1, false, "normal");
			this.graphics.beginFill (0xEBE27D, 1);
			this.graphics.drawCircle (0, 0, 10);
			this.graphics.endFill();

			addEventListener (MouseEvent.MOUSE_DOWN, onDown);
			addEventListener (MouseEvent.MOUSE_UP, onUp);
		}
		
		private function onDown (event:MouseEvent):void
		{
			this.startDrag();
		}
		private function onUp (event:MouseEvent):void
		{
			this.stopDrag();
		}

	}
	
}
