
// CircleMenu (C) Edvard Toth (03/2008)
//
// http://www.edvardtoth.com
//
// This source is free for personal use. Non-commercial redistribution is permitted as long as this header remains included and unmodified.
// All other use is prohibited without express permission.

package {
	
	import flash.display.*;
	import flash.events.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import Utils;
	import Colors;
	
	public class CircleMenu extends MovieClip
	{
		private var circleElement:CircleMenuElement;
		private var toolTip:CircleMenuTooltip = new CircleMenuTooltip();
		
		private var colors:Array = [Colors.spectrum1,Colors.spectrum2,Colors.spectrum3,Colors.spectrum4,Colors.spectrum5,Colors.spectrum6];

		private var colorID:Number = Math.round (Utils.randomize (0, colors.length-1));
		
		private var menuItems:Array = ["sweet", "awesome", "cool", "da bomb", "delicious", "rockin", "radical", "wicked", "fantastic"]; 
	
		private var dX:Number = 0;
		private var dY:Number = 0;
		private var aX:Number = 0;
		private var aY:Number = 0;
		private var vX:Number = 0;
		private var vY:Number = 0;

		private var spring:Number = 0.3;
		private var friction:Number = 0.70;
		
		private var minRadius:Number = 32;
		private var stepRadius:Number = 18;
		private var lineThickness:Number = 16;
		
		public function CircleMenu()
		{
			// in case circles are set to overlap each other
			this.blendMode = flash.display.BlendMode.LAYER;
			
			for (i=0; i < menuItems.length; i++)
			{
				if (colorID > colors.length-1)
				{
					colorID = 0;
				}

			// radius, color, linethickness
			circleElement = new CircleMenuElement(minRadius + i*stepRadius , colors[colorID], lineThickness);
			circleElement.menuText = menuItems[i];
			
			addChild (circleElement);
			
			colorID++;
			}

			alphaTween = new Tween (this, "alpha", None.none, 0, 1, 0.5, true);
			alphaTween.addEventListener (TweenEvent.MOTION_FINISH, tweenFinish);
		}
		
		private function tweenFinish (event:TweenEvent):void
		{
			addChild (toolTip);
			toolTip.visible = false;
			toolTip.mouseEnabled = false;
			toolTip.mouseChildren = false;
		}
		
		public function toolTipOn (inText:String):void
		{
			toolTip.visible = true;
			toolTip.field.text = inText;
			addEventListener (Event.ENTER_FRAME, updateFrame);
		}

		public function toolTipOff ():void
		{
			toolTip.visible = false;
			toolTip.field.text = "";
			removeEventListener (Event.ENTER_FRAME, updateFrame);
		}

		
		private function updateFrame (event:Event):void
		{
			dX = mouseX - toolTip.x;
			dY = (mouseY - 20) - toolTip.y;
			
			aX = dX * spring;
			aY = dY * spring;
			
			vX += aX;
			vY += aY;
			
			vX *= friction;
			vY *= friction;
			
			toolTip.x += vX;
			toolTip.y += vY;
		}
		
		
	}
	
}