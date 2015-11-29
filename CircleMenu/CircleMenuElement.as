
// CircleMenu (C) Edvard Toth (03/2008)
//
// http://www.edvardtoth.com
//
// This source is free for personal use. Non-commercial redistribution is permitted as long as this header remains included and unmodified.
// All other use is prohibited without express permission.

package {

	import flash.utils.getTimer;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import fl.motion.Color;
	import flash.media.Sound;
	
	import Utils;
	
	public class CircleMenuElement extends MovieClip
	{
		public var menuText:String;
		
		private var circlesound:Sound = new Circlesound();
		
		private var startTime:Number;
		private var currentTime:Number;
		private var delayTime:Number = 100;
		
		private var soundPlayed:Boolean = true;
		
		private var fromPoint:Point = new Point (Utils.randomize(-50,-200), 0);
		private var toPoint:Point = new Point (Utils.randomize(50,200), 0);
		
		private var elementActive:Boolean = false;
		
		private var defaultColor:ColorTransform;
		private var selectedColor:ColorTransform = new ColorTransform (0,0,0,1,255,255,255,0);
		private var transPercent:Number = 0;
		private var transMod:Number = 0;
		
		private var originalRotation:Number = 0;
		private var targetRotation:Number = 0;
		
		private var inPoint:Point = new Point();
		private var outPoint:Point = new Point();
		
		private var centerX:Number = 0;
		private var centerY:Number = 0;
		
		private var segmentX:Number = 0;
		private var segmentY:Number = 0;
		
		private var steps:Number;
		
		private var startAngle:Number = Math.round(Utils.randomize (-90,-45))/360;
		private var arcAngle:Number = Math.abs (startAngle*2);

		private var currentAngle:Number;
		private var angleStep:Number;
		
		private var twoPI:Number = 2 * Math.PI;
				
		private var quad1:Number = 0;
		private var quad2:Number = 0;
		private var quad3:Number = 0;
		private var quad4:Number = 0;
		private var quadSum:Number = 0;
		
		private var quad1a:Number = 0;
		private var quad2a:Number = 0;
		
		private var rotationSum:Number = 0;
		
		// degrees are expressed as "degree/360"
		public function CircleMenuElement (inRadius:Number, inColor:Number, inLineThickness:Number) 
		{
			
			startAngle += .0; // to start it at 12 o'clock
		
			steps = Math.floor ((arcAngle*360)/4);  // resolution of arc
				
			angleStep = arcAngle / steps;
		
			segmentX = centerX + Math.cos(startAngle * twoPI) * inRadius;
			segmentY = centerY + Math.sin(startAngle * twoPI) * inRadius;
			
				this.graphics.moveTo(segmentX, segmentY);
				this.graphics.lineStyle(inLineThickness, inColor, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.BEVEL);

			for(var i=1; i <= steps; i++)
			{
				currentAngle = startAngle + i * angleStep;

				segmentX = centerX + Math.cos(currentAngle * twoPI) * inRadius;
				segmentY = centerY + Math.sin(currentAngle * twoPI) * inRadius;
				
				this.graphics.lineTo(segmentX, segmentY);
			}
			
			addEventListener (Event.ADDED_TO_STAGE, activateElement);
		}
	
		
		function activateElement (event:Event):void
		{
			startTime = getTimer();
			
			originalRotation = Utils.randomize (-180, 180);		
			
			defaultColor = this.transform.colorTransform;

			stage.addEventListener (Event.RESIZE, resizeRecalcCenter);
			
			addEventListener (MouseEvent.ROLL_OUT, rolloutElement);
			addEventListener (MouseEvent.ROLL_OVER, rolloverElement);
			
			addEventListener (Event.ENTER_FRAME, updateElement);
		}
		
		
		private function updateElement (event:Event):void
		{
			currentTime = getTimer();
			
			dX = root.mouseX - outPoint.x;
			dY = root.mouseY - outPoint.y;

				switch (elementActive)
				{
					case true:
		
					// checks for a short delay to avoid "rattle" when mouse is moved fast over the multiple circles
					if (currentTime - startTime > delayTime)
					{
					
					targetRotation = Math.atan2(dY, dX) * 180 / Math.PI;
					transMod = 0.04;
					
						if (soundPlayed == false)
						{
							circlesound.play();
							soundPlayed = true;
						}
						
					}
					break;
				
					case false:
				
					targetRotation = originalRotation;
					transMod = -0.02;				

					break;
				}

					if (targetRotation < 0) 
					{ 
						quad1 += (targetRotation-quad1a); 
					} 
						
					quad1a = targetRotation; 
			
					if (targetRotation > 0) 
					{ 
						quad2 += (targetRotation-quad2a); 
					} 
					
					quad2a = targetRotation; 
			
					if (quad3 - 180 > targetRotation) 
					{ 
						quad1 += 360; 
					} 
			
						quad3 = targetRotation; 
			
					if (quad4 + 180 < targetRotation) 
					{ 
						quad2 -= 360; 
					}
					
						quad4 = targetRotation; 
					
						quadSum = quad1+quad2; 
					
			
					rotationSum += (quadSum-rotationSum)/5; 
			
					this.rotation = rotationSum; 
				
					recalcCenter();
			
					
				transPercent += transMod;
				
				if (transPercent < 0)
				{
					transPercent = 0;				
				}
				if (transPercent > 1)
				{
					transPercent = 1;			
				}
				
					this.transform.colorTransform =	Color.interpolateTransform (defaultColor, selectedColor, transPercent);
		}
		

		private function resizeRecalcCenter (event:Event):void
		{
			recalcCenter(); // recalc center when resized to avoid incorrect behavior
		}
		
		private function recalcCenter ():void
		{
			inPoint.x = this.x;  
			inPoint.y = this.y;
				
			outPoint = this.localToGlobal (inPoint);
		}
		
		private function rolloverElement (event:MouseEvent):void
		{
			soundPlayed = false;
			
			startTime = getTimer();
		
			elementActive = true;
			
			event.currentTarget.parent.toolTipOn(menuText);
		}
		
		private function rolloutElement (event:MouseEvent):void
		{
			elementActive = false;

			event.currentTarget.parent.toolTipOff();
		}
		
		
	} // end class
	
} // end package