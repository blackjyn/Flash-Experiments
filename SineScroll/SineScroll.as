// (c) edvardtoth.com

package 
{
	import flash.display.*;
	import flash.errors.IOError;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.geom.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	[SWF(width='570', height='350', framerate='50')]

	public class SineScroll extends MovieClip
	{
		// ===== embed shader here
		[Embed (source = "sinescroll.pbj", mimeType = "application/octet-stream")]
		private var shaderObj:Class;
		// =====
		
		private var displayWidth:Number;
		private var displayHeight:Number;

		private var sinespeed:Number = 100;
		private var sinespeedMod:Number = -0.1;
		
		private var shader:Shader;
		
		private var canvasImage:BitmapData;
		
		private var displayHolder:Sprite;
		private var decal:Decal;
		
		private var scroll:Scroll;
		private var scrollString:String = "\t\t\t DEMOSCENE-STYLE SINE SCROLLER DONE USING PIXEL BENDER AND FLASH. OLD-SCHOOL AWESOMENESS COMES FULL CIRCLE... \t\t\t";
		
		private var amplitude1:Number = 1;
		private var amplitude2:Number = 1;
		private var amps:Number;
		
		private var theSound:Sound;
		private var theChannel:SoundChannel;
		
		public function SineScroll()
		{
			if ( stage != null )
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				//stage.quality = StageQuality.MEDIUM;

				displayWidth = stage.stageWidth;
				displayHeight = stage.stageHeight;
			}	
			
			// this is the image in the Library
			canvasImage = new BitmapData (displayWidth, displayHeight, true, 0x00000000);

			decal = new Decal();
			addChild (decal);

			scroll = new Scroll();
			scroll.scrolltext.text = scrollString;
			
			
			displayHolder = new Sprite();
			addChild (displayHolder);
			
			displayHolder.cacheAsBitmap = true;
			copper.cacheAsBitmap = true;
			copper.mask = displayHolder;
			
			var dropShadow:DropShadowFilter = new DropShadowFilter (5, 45, 0, 1, 4, 4, 1, 1, false, false);
			copper.filters = [dropShadow];
			
			// instantiate the embedded shader
			shader = new Shader(new shaderObj());
			
			// specify the image as the input-image for the shader
			shader.data.canvas.input = canvasImage;
			
			thesound = new Sound (new URLRequest ("music.mp3"));
			thesound.addEventListener (Event.OPEN, onOpen);
			thesound.addEventListener (IOErrorEvent.IO_ERROR, onError);
			
			addEventListener (Event.ENTER_FRAME, updateFrame, false, 0, true);
		}
		
		private function onOpen (event:Event):void
		{
			thechannel = thesound.play();
		}
		private function onError (event:IOErrorEvent):void
		{
		}
		
		private function updateFrame (event:Event):void
		{
			if (scroll.scrolltext.scrollH < scroll.scrolltext.maxScrollH)
			{
				scroll.scrolltext.scrollH += 5;				
			}
			else
			{
				scroll.scrolltext.scrollH = 0;
			}
			
			canvasImage.fillRect (canvasImage.rect, 0x00000000);
			canvasImage.draw (scroll, scroll.transform.matrix, null, null, canvasImage.rect, false);
			
			sinespeed += sinespeedMod;
			if (sinespeed >= 100)
			{
				sinespeedMod = -0.1;
			}
			if (sinespeed <= 0)
			{
				sinespeedMod = 0.1;
			}
			shader.data.sinespeed.value = [sinespeed];
			
			amplitude1 += 0.01;
			amplitude2 += 0.05;
			
			amps = Math.sin (amplitude1) * 20 + Math.sin (amplitude2) * 100;
			shader.data.amplitude.value = [amps];
			
			// draw and fill with image + shader
			displayHolder.graphics.clear();
			displayHolder.graphics.beginShaderFill (shader);
			displayHolder.graphics.drawRect (0, 0, displayWidth, displayHeight);
			displayHolder.graphics.endFill();
		}
		
		
	}
	
}