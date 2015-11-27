// Interactive Pixel Bender wave example (c) edvardtoth.com

package 
{
	import flash.display.*;
	import flash.events.*;
	import Stats;
	
	[SWF(width='570', height='570', framerate='30')]

	public class WaveDisturbance extends MovieClip
	{
		// ===== embed shader here
		[Embed (source = "disturbance.pbj", mimeType = "application/octet-stream")]
		private var shaderObj:Class;
		// =====
		
		private var shader:Shader;
		private var shaderImage:ShaderImage;
		
		private var displayWidth:Number;
		private var displayHeight:Number;
		
		private var ticker:Number = 0;
		
		public function WaveDisturbance()
		{
			if ( stage != null )
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;

				displayWidth = stage.stageWidth;
				displayHeight = stage.stageHeight;
			}	
				
			// the performance-meter
			var stats:Stats = new Stats();
			addChild (stats);
				
			// this is the image in the Library
			shaderImage = new ShaderImage(0,0);
			
			// instantiate the embedded shader
			shader = new Shader(new shaderObj());
			
			// specify the image as the input-image for the shader
			shader.data.src.input = shaderImage;
		
			addEventListener (Event.ENTER_FRAME, updateFrame, false, 0, true);
		}
		
		private function updateFrame (event:Event):void
		{
			// assign values to the shader parameters based on the state of the sliders, the position of the mouse-pointer, etc.
			ticker += (speedSlider.value * 0.005);
			
			shader.data.ticker.value = [ticker];
			shader.data.xPos.value = [mouseX];
			shader.data.yPos.value = [mouseY];
			shader.data.radius.value = [radiusSlider.value];
			shader.data.amplitude.value = [amplitudeSlider.value];
			
			// draw and fill with image + shader
			graphics.clear();
			graphics.beginShaderFill (shader);
			graphics.drawRect (0, 0, displayWidth, displayHeight);
			graphics.endFill();
		}

	}
	
}