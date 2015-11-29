
// CircleMenu (C) Edvard Toth (03/2008)
//
// http://www.edvardtoth.com
//
// This source is free for personal use. Non-commercial redistribution is permitted as long as this header remains included and unmodified.
// All other use is prohibited without express permission.

package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	import CircleMenu;
	
	public class Main extends MovieClip
	{
		private var circleMenu:CircleMenu = new CircleMenu();
		private var delayTimer:Timer = new Timer(60, 1);
		
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			delayTimer.addEventListener (TimerEvent.TIMER_COMPLETE, prepareFrame);
			delayTimer.start();
		}
		
		// waits 60 milliseconds to make sure everything is rendered
		private function prepareFrame (event:TimerEvent):void
		{
			addChild (circleMenu);
			
			setupMain();
			stage.addEventListener (Event.RESIZE, onResize);
		}
		
		private function onResize (event:Event):void
		{
			setupMain();
		}

		private function setupMain():void
		{
			createBackground();

			// centers menu on the stage, even if window is resized
			circleMenu.x = stage.stageWidth / 2;
			circleMenu.y = stage.stageHeight / 2;
		}
		
		
		private function createBackground ():void
		{
			this.graphics.clear();
			
			this.graphics.beginFill (0x3a3942, 1);
			this.graphics.drawRect (0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
		}
		
	}
	
}