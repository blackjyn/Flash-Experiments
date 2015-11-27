//TagCloud (c) edvardtoth.com

package  
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import Utils;
	import Stats;
	
	public class Tagcloud extends MovieClip
	{
		// ===============================================
		// SETTINGS
		// ===============================================

			private var hWidth:Number = 0;
			private var hHeight:Number = 0;
			private var hDepth:Number = 0;
			
			private var numWords:Number = 15;
			
			private var focalLength:Number = 	500;

			private var zSpeed:Number = 		5;
			
			private var xWaveOffset:uint =	100;
			private var yWaveOffset:uint =	100;
			private var zWaveOffset:uint =	11;
			
			private var waveSpeed:Number = 		0.02;
			
		// ===============================================
		// ===============================================
	
			private var cam:Cam;
			
			private var tagWord:Tagword;
		
			private var renderBitmapData:BitmapData;
			private var renderBitmap:Bitmap;
			private var clipRect:Rectangle;
			private var offsetMatrix:Matrix;
			
			private var smoothing:Boolean = false;
			
		public function Tagcloud() 
		{
			if (stage != null)
			{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.HIGH;
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			}
			this.blendMode = BlendMode.LAYER;
			
			//this.scrollRect = this.getRect(this);
			
			hWidth = (this.width / this.scaleX) / 2;
			hHeight = (this.height / this.scaleY) / 2;
			
			renderBitmapData = new BitmapData (this.width , this.height  , true, 0x00ffffff);
			renderBitmap = new Bitmap (renderBitmapData, PixelSnapping.AUTO, smoothing);
			clipRect = new Rectangle (0, 0, this.width, this.height );
			
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}

			// Camera object is created with parameters, and placed in the center of active area
			cam = new Cam (focalLength, zSpeed, xWaveOffset, yWaveOffset, zWaveOffset, waveSpeed);	
			cam.x = hWidth;
			cam.y = hHeight;
			
			offsetMatrix = new Matrix();
			offsetMatrix.translate (hWidth, hHeight);

			addChild (renderBitmap);
				
				// Word objects are added to the camera-object
				for (i = 0; i < numWords; i++)
				{
					tagWord = new Tagword (hWidth, hHeight, cam);
					cam.addChild (tagWord);
				}
				
			addEventListener (Event.ENTER_FRAME, render);
		}
		
		private function setupGrid():void
		{
		grid = new Sprite();
		
		gridBitmapData = new Gridpng(8,8);
		
		grid.graphics.beginBitmapFill (gridBitmapData, null, true, false);
		grid.graphics.drawRect (0, 0, this.width, this.height);
		grid.graphics.endFill();
		
		addChild (grid);
		
		grid.mouseChildren = false;
		grid.mouseEnabled = false;
		
		grid.blendMode = BlendMode.ERASE;		
		grid.alpha = 0.75;
		}
		
		private function render (event:Event):void
		{
			renderBitmapData.fillRect (clipRect, 0x00ffffff);
			renderBitmapData.draw (cam, offsetMatrix, null, null, clipRect, smoothing);
		}

	
	}
	
}





