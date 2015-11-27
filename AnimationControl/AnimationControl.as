// (C) edvardtoth.com

package {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class AnimationControl {
	
		public function AnimationControl() {
		}
		
		public static function stopAll (item:*):void {
			
			if (item is DisplayObjectContainer) {
				controlAnimation (item, "stop");
			}
		}
		
		public static function playAll (item:*):void {
			
			if (item is DisplayObjectContainer) {
				controlAnimation (item, "play");
			}
		}

		private static function controlAnimation (item:DisplayObjectContainer, funct:String):void {
			
		var clip:MovieClip;
	        var child:DisplayObjectContainer;
			
		    if (item is MovieClip) {
				
				clip = item as MovieClip;
				
				clip[funct]();
		    }
		    
		    if (clip.numChildren > 0)
		    {
		        for (var i:int=0, n:int = clip.numChildren; i < n; ++i)
		        {
		            if (clip.getChildAt(i) is DisplayObjectContainer)
		            {
		                child = clip.getChildAt(i) as DisplayObjectContainer;
		                
		                if (child.numChildren != 0) {
					
					controlAnimation (child, funct) 

		                } else if (child is MovieClip) {
		             
					clip = child as MovieClip;

		             	        if (clip.totalFrames > 1) {
								
					clip[funct]();

					}
		                }
		            }
		        }
		    }
		}


  }
}