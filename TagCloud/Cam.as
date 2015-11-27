package  
{
	import flash.events.*;
	import flash.display.Sprite;
	
	public class Cam extends Sprite
	{
		private var words:String = new String ("game development,game design,environment art,character design,maya mel script,3d modeling,texturing,digital art,technical art,art direction,concept art,pixel art,art galleries,code examples,videogames,console games,casual games,social games,game industry,flash development,actionscript sources,flash experiments,papervision3d,pixel bender,shaders,bitmapdata manipulation,iphone apps,css and xml,vector illustration,interactive design,user interaction,widgets,oldschool,visual effects,user interface,photography");
		
		// yeah yeah this will break encapsulation, but it's way faster than setters and getters
		public var xPos:Number;
		public var yPos:Number;
		public var zPos:Number;

		public var dx:Number;
		public var dy:Number;
		public var dz:Number;
		
		public var focalLength:Number;
	
		private var zSpeed:Number;
		
		private var xWaveOffset:uint;
		private var yWaveOffset:uint;
		private var zWaveOffset:uint;
		
		private var waveSpeed:Number;
		
		private var angle:Number = 1;
		
		private var word:String;
		private var wordIndex:Number = -1; // to start with 0 after increment
		private var wordList:Array;
		
		public function Cam (inFocalLength:Number, inZSpeed:Number, inXWaveOffset:uint, inYWaveOffset:uint, inZWaveOffset:uint, inWaveSpeed:Number) 
		{
			xPos = 0;
			yPos = 0;
			zPos = 0;
			
			dx = 0;
			dy = 0;
			dz = 0;
			
			focalLength = inFocalLength;
			zSpeed = inZSpeed;
			xWaveOffset = inXWaveOffset;
			yWaveOffset = inYWaveOffset;
			zWaveOffset = inZWaveOffset;
			
			waveSpeed = inWaveSpeed;
			
			wordList =  new Array();
			wordList = words.split(",");
			
			addEventListener (Event.ENTER_FRAME, updateFrame);
		}

		private function updateFrame (event:Event):void
		{
			dx = 0 + Math.cos(angle) * xWaveOffset;
			dy = 0 + Math.sin(angle) * yWaveOffset;

			dz = dz + zSpeed + Math.cos(angle) * zWaveOffset;
			
			xPos += (dx - xPos) * 0.1;
			yPos += (dy - yPos) * 0.1;
			zPos += (dz - zPos) * 0.1;
			
			angle += waveSpeed;
		}
		
		public function nextWord():String
		{
			wordIndex++;
			if (wordIndex > wordList.length - 1)
			{
				wordIndex = 0;
			}
			
			word = wordList[wordIndex];
			return word;
		}
		
	}
}

