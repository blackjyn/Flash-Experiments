// (c) edvardtoth.com

package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	[SWF(width='570', height='570', framerate='60')]

	public class DepthMap extends MovieClip
	{
		// ===== embed shader here
		[Embed (source = "depthmapfilter.pbj", mimeType = "application/octet-stream")]
		private var shaderObj:Class;
		// =====
		
		private var shader:Shader;
		private var depthMapImage:DepthMapImage;
		
		private var canvasImage:BitmapData;
		
		private var displayHolder:Sprite;
		private var cardImage:Sprite;		
		private var decal:Decal;
		
		private var mainScale:Number = 1;
		
		private var displayWidth:Number;
		private var displayHeight:Number;
		
		private var ticker:Number = 0;
		
		private var ctrlFlag:Boolean;
		
		public function DepthMap()
		{
			if ( stage != null )
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;

				displayWidth = stage.stageWidth;
				displayHeight = stage.stageHeight;
			}	
				
			// this is the image in the Library
			depthMapImage = new DepthMapImage(0,0);
			canvasImage = new BitmapData (displayWidth, displayHeight, true, 0x00000000);

			decal = new Decal();
			addChild (decal);

			displayHolder = new Sprite();
			addChild (displayHolder);
			
			cardImage = new CardImage();
			cardImage.rotation -= 5;
			cardImage.x = displayWidth / 2;
			cardImage.y = displayHeight / 2;
			cardImage.alpha = 0;
			addChild (cardImage);
						
			cardImage.addEventListener (MouseEvent.MOUSE_DOWN, onDown);
			cardImage.addEventListener (MouseEvent.MOUSE_UP, onUp);
			stage.addEventListener (KeyboardEvent.KEY_DOWN, onKDown);
			
			// instantiate the embedded shader
			shader = new Shader(new shaderObj());
			
			// specify the image as the input-image for the shader
			shader.data.dmap.input = depthMapImage;
			shader.data.canvas.input = canvasImage;
			
			addEventListener (Event.ENTER_FRAME, updateFrame, false, 0, true);
		}
		
		private function updateFrame (event:Event):void
		{
			canvasImage.fillRect (canvasImage.rect, 0x00000000);
			canvasImage.draw (cardImage, cardImage.transform.matrix, null, null, canvasImage.rect, true);
			
			// draw and fill with image + shader
			displayHolder.graphics.clear();
			displayHolder.graphics.beginShaderFill (shader);
			displayHolder.graphics.drawRect (0, 0, displayWidth, displayHeight);
			displayHolder.graphics.endFill();
		}
		
		private function onDown (event:MouseEvent):void
		{
			cardImage.startDrag();			
		}
		private function onUp (event:MouseEvent):void
		{
			cardImage.stopDrag();			
		}
		
		private function onKDown (event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case 40:
				mainScale += 0.05;
				break;
				
				case 38:
				mainScale -= 0.05;
				break;
			}
			
			if (mainScale > 1)
				{mainScale = 1;}
				if (mainScale < 0)
				{mainScale = 0;}
							
				cardImage.scaleX = cardImage.scaleY = mainScale;
				
				shader.data.zDepth.value = [mainScale];
			
		}
		
		
	}
	
}