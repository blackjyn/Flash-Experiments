// AURORA MEMBRANE (C) edvardtoth.com

package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	[SWF(width=800,height=800,frameRate=30,backgroundColor=0x000000)]
	public class AuroraMembrane extends Sprite
	{
		private const SIZE:int = 800;			// size of the canvas
		private const NOISESIZE:int = 100;		// size of the noise map
		private const RATIO:Number = SIZE / NOISESIZE;  // ratio to accurately map the noise on the canvas
		private const OCTAVES:int = 3;			// number of perlin noise octaves
		private const SPEED:Number = 0.05;		// speed value used to animate the perlin noise
	
		private var noiseMap:BitmapData;
		private var canvasBitmapData:BitmapData;
		private var canvas:Bitmap;
		
		private var canvasBlur:BlurFilter;
		private var canvasFade:ColorMatrixFilter;
		
		private var clipRect:Rectangle;
		private var point:Point;
		
		private var sound:Sound;
		private var channel:SoundChannel;
		private var leftMagnitude:Number;
		private var rightMagnitude:Number;
		
		private var soundAvailable:Boolean = true;
		
		public function AuroraMembrane()
		{
			// setup stage properties
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			stage.align = StageAlign.TOP_LEFT;
			
			// create matrix for the ColorMatrixFilter used to fade out the continuously overdrawn bitmap
			var canvasFadeMatrix:Array = new Array();
			
			canvasFadeMatrix = canvasFadeMatrix.concat([1, 0, 0, 0, 0]); 	// red
			canvasFadeMatrix = canvasFadeMatrix.concat([0, 1, 0, 0, 0]); 	// green
			canvasFadeMatrix = canvasFadeMatrix.concat([0, 0, 1, 0, 0]); 	// blue
			canvasFadeMatrix = canvasFadeMatrix.concat([0, 0, 0, 0.99, 0]); // alpha
			
			canvasFade = new ColorMatrixFilter (canvasFadeMatrix);
			canvasBlur = new BlurFilter (2, 32, 1); // Y values is much larger than X to achieve vertical streaking
			
			clipRect = new Rectangle (0, 0, SIZE, SIZE);
			point = new Point (0, 0);
			
			noiseMap = new BitmapData (NOISESIZE, NOISESIZE, false, 0x000000);
			
			canvasBitmapData = new BitmapData(SIZE, SIZE, false, 0x000000);
			canvas = new Bitmap(canvasBitmapData, PixelSnapping.AUTO, false);
			addChild(canvas);
			
			// load sound and handle potential stream error
			// effect should still be presentable even if sound cannot be loaded
			sound = new Sound(new URLRequest ("music.mp3"));
			sound.addEventListener(IOErrorEvent.IO_ERROR, function ():void{soundAvailable = false;});

			channel = sound.play();
			
			addEventListener (Event.ENTER_FRAME, updateFrame, false, 0, true);
		}

		private function updateFrame(event:Event):void
		{
			// get peak information from sound, or default to 1 if sound was not available to load
			if (soundAvailable == true) {
				leftMagnitude = channel.leftPeak;
				rightMagnitude = channel.rightPeak;
			} else {
				leftMagnitude = 1;
				rightMagnitude = 1;
			}
			
			var offsets:Array = [];
			var offset:Number = -(getTimer() * SPEED);
		
			for(var i:uint = 0; i < OCTAVES; i++) {
				
				// offsets are used for animating the various octaves of the perlin noise map
				offsets.push(new Point(0, offset/(i+1)));
			}

			// render the noiseMap
			noiseMap.perlinNoise(NOISESIZE, NOISESIZE, OCTAVES, Math.random(), false, false, BitmapDataChannel.RED |BitmapDataChannel.GREEN | BitmapDataChannel.BLUE , false, offsets);

			// apply fading and blurring to the existing contents of the canvas
			canvasBitmapData.applyFilter (canvasBitmapData, clipRect, point, canvasBlur);
			canvasBitmapData.applyFilter (canvasBitmapData, clipRect, point, canvasFade);
			
			for (var y:int = 0; y < NOISESIZE; y++)
			{
				for (var x:int = 0; x < NOISESIZE; x++)
				{
					// separate R,G,B values extracted from the noiseMap using bitwise operators
					var pixelColor:uint = noiseMap.getPixel(x, y);
					var r:int = pixelColor >> 16 & 0xFF;
					var g:int = pixelColor >> 8 & 0xFF;
					var b:int = pixelColor & 0xFF;
					
					// calculate coordinates for displaced pixels
					// the perlin noise map information drives the direction of the displacement, 
					// and the sound values drive the magnitude
					var vX:int = x * RATIO + (g / 0xff - 0.25) * (leftMagnitude * SIZE);
					var vY:int = y * RATIO + (b / 0xff - 0.25) * (rightMagnitude * SIZE);

					// don't render out-of-bounds pixels
					if (vY < 0 || vY >= SIZE || vX < 0 || vX >= SIZE) {
					 continue;
					}
					
					// render the displaced pixel with the right color value
					canvasBitmapData.setPixel(vX, vY, pixelColor);
				}
			}
		}
		
		
	}
}