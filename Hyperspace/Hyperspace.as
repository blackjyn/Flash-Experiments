// (C) edvardtoth.com

package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.PixelSnapping;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	public class Hyperspace extends MovieClip
	{
		private var starNum:int;
		private var starSpeed:Number;
		
		private var displayWidth:Number;
		private var displayHeight:Number;
		private var halfDisplayWidth:Number;
		private var halfDisplayHeight:Number;
		
		private var circleWidth:Number;
		private var circleHeight:Number;
		private var circleAngle:Number;
		private var circlePoint:Point;
		
		private var currentStar:Star;
		private var starField:Vector.<Star>;
		private var starHolder:Sprite;
		
		private var canvasBitmapData:BitmapData;
		private var canvasBitmap:Bitmap;
		private var canvasBlur:BlurFilter;
		private var canvasFade:ColorMatrixFilter;
		
		private var clipRect:Rectangle;
		private var point:Point;
		
		public function Hyperspace():void 
		{
			if ( stage != null )
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.quality = StageQuality.MEDIUM;

				displayWidth = stage.stageWidth;
				displayHeight = stage.stageHeight;
			}		
			
			halfDisplayWidth = displayWidth >> 1;
			halfDisplayHeight = displayHeight >> 1;
				
			circleWidth = displayWidth >> 2;
			circleHeight = displayHeight >> 2;

			circleAngle = 0;
			circlePoint = new Point (0, 0);
			
			clipRect = new Rectangle (0, 0, displayWidth, displayHeight);
			point = new Point (0, 0);
			
			starHolder = new Sprite();
			starField = new Vector.<Star>; // the stars are stored in this Vector (typed array)
			starNum = 1000; // the number of stars
			starSpeed = 1.2;

			var canvasFadeMatrix:Array = new Array();
						
			canvasFadeMatrix = canvasFadeMatrix.concat([1, 0, 0, 0, 0]); 	// red
			canvasFadeMatrix = canvasFadeMatrix.concat([0, 0, 0, 0, 0]); 	// green
			canvasFadeMatrix = canvasFadeMatrix.concat([0, 0, 0, 0, 0]); 	// blue
			canvasFadeMatrix = canvasFadeMatrix.concat([0, 0, 0, 0.97, 0]); // alpha

			canvasFade = new ColorMatrixFilter (canvasFadeMatrix);
			canvasBlur = new BlurFilter (8, 8, 1);
			
			canvasBitmapData = new BitmapData (displayWidth, displayHeight, true, 0x00000000);
			canvasBitmap = new Bitmap (canvasBitmapData, PixelSnapping.AUTO, false);
			
			addChildAt (canvasBitmap, 0);
			
			// create the initial set of stars
			for (var i:int = 0; i < starNum; i++)
			{
				currentStar = new Star();
				
				currentStar.xPos = Math.random() * 50.0 - 25.0;
				currentStar.yPos = Math.random() * 50.0 - 25.0;
				currentStar.zPos = Math.random() * 100.0;

				starHolder.addChild (currentStar);

				starField[i] = currentStar;
			}
			
			addEventListener(Event.ENTER_FRAME, updateFrame, false, 0, true);
		}
		
		private function updateFrame(event:Event):void 
		{
			// the stars' point of origin is slowly moving around on a elliptical path
			// this is where the points of the path are calculated / updated
			
			circlePoint.x = halfDisplayWidth + Math.cos (circleAngle) * circleWidth;
			circlePoint.y = halfDisplayHeight + Math.sin (circleAngle) * circleHeight;
			circleAngle += 0.02;

			var i:int = -1; // to make sure the first element in the while-loop is handled properly
			
			while (++i < starNum)
			{
				currentStar = starField[i];
				
				// if a star reaches or goes past the camera-plane, 
				// it's assigned new random coordinates and pushed back 
				if (currentStar.zPos <= 0.0) 
				{ 
					currentStar.xPos = Math.random() * 50 - 25;
					currentStar.yPos = Math.random() * 50 - 25;
					currentStar.zPos = 100.0;
				}
					
				currentStar.zPos -= starSpeed;
				currentStar.x = currentStar.xPos / currentStar.zPos * displayWidth + circlePoint.x;
				currentStar.y = currentStar.yPos / currentStar.zPos * displayHeight + circlePoint.y;
				
				// the proper scale and transparency of each star is set here
				currentStar.scaleX = currentStar.scaleY = currentStar.alpha = 1.0 - currentStar.zPos * 0.01;
			}
			
			// the on-screen bitmap buffer is processed here, and the 
			// starHolder container is drawn into it every frame as well.
			// besides creating the "redshift" trail-effect this also makes it 
			// unnecessary to check for out-of-bounds stars in order to reduce off-screen draw.
			// (try "Show Redraw Regions" to verify)
			
			canvasBitmapData.applyFilter (canvasBitmapData, clipRect, point, canvasBlur);
			canvasBitmapData.applyFilter (canvasBitmapData, clipRect, point, canvasFade);
			canvasBitmapData.draw (starHolder, starHolder.transform.matrix, null, null, clipRect, false);
		}

	}
	
}