// (C) edvardtoth.com

package {
	
	import flash.display.Sprite;
	
	public class Star extends Sprite
	{
		public var xPos:Number;
		public var yPos:Number;
		public var zPos:Number;
		
		public function Star()
		{
			xPos = 0;
			yPos = 0;
			zPos = 0;
			
			graphics.beginFill (0xffffff);
			graphics.drawCircle (0.0, 0.0, 3.0);
			graphics.endFill();
		}
		
	}
	
}