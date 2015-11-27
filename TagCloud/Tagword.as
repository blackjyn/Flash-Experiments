package  
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.TextField;
	import Utils;
	
	public class Tagword extends MovieClip
	{
		private var hWidth:Number;
		private var hHeight:Number;
		
		private var xPos:Number;
		private var yPos:Number;
		private var zPos:Number;
			
		private var scale:Number;
		
		private var word:String;
		private var cam:Cam;

		private var zCurrent:Number;
				
		public function Tagword (inWidth:Number, inHeight:Number, inCam:Cam) 
		{
			hWidth = inWidth;
			hHeight = inHeight;
			cam = inCam;
			
			this.tagtext.text = cam.nextWord();
						
			xPos = Utils.randomize (-hWidth, hWidth);
			yPos = Utils.randomize (-hHeight, hHeight);
			zPos = Utils.randomize (0, (cam.focalLength * 2));
			
			addEventListener (Event.ENTER_FRAME, updateFrame);
		}

		private function updateFrame (event:Event):void
		{
			zCurrent = cam.focalLength + zPos - cam.zPos;

			if (zCurrent > 0)
			{
				scale = cam.focalLength / zCurrent;
				this.x = (cam.xPos - xPos) * scale;
				this.y = (cam.yPos - yPos) * scale;
				this.scaleX = this.scaleY = scale;
				this.alpha = 1 - 0.99 * zCurrent / cam.focalLength * 0.5;
			}
			else
			{
				xPos = Utils.randomize (-hWidth, hWidth);
				yPos = Utils.randomize (-hHeight, hHeight);
				zPos = zPos + cam.focalLength * 2;
				
				this.tagtext.text = cam.nextWord();
			}
			
		}
	
	}
}

