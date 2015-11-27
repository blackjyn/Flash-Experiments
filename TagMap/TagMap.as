// TagMap (c) edvardtoth.com

package
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	import org.cove.ape.Vector;
	
	public class TagMap extends MovieClip
	{
		private var wordRequests:Vector.<Object>;
		private var vernacular:String;
		private var wordList:Array;
		private var req:Object;
		private var blank:Sprite;
		
		public function TagMap() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.HIGH;
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			
			wordRequests = new Vector.<Object>();

			dictionary = "game development , game design , environment art , design,development , character design , maya , MEL , script , 3D , modeling , texturing , digital art , technical art , art direction , concept art , pixel art , art galleries , code examples , videogames , console games , casual games , social games , game industry , flash , flash development , object oriented , actionscript , AS3 , sources , experiments , papervision3d , pixel bender , shaders , bitmapdata , manipulation , apps , CSS , XML , HTML , vector , illustration , illustrator , interactive ,user interaction , interface , UI , widgets , oldschool , visual , effects , photography , facebook , procedural , animation , tweening , tools , art pipeline , rapid prototyping , performance , optimization ";
	
			wordList = new Array();
			wordList = dictionary.split(",");

			startUp();
		}
	
		private function startUp():void {
			wordTagArea(0,0,800,800);
			addEventListener (Event.ENTER_FRAME, updateFrame, false, 0, true);
		}
		
		private function updateFrame(event:Event):void {

			if (wordRequests.length > 0) {
				req = wordRequests.pop();
				wordTagArea(req.x0, req.y0, req.x1, req.y1);
			} else {
				
				removeEventListener (Event.ENTER_FRAME, updateFrame);
				var timer:Timer = new Timer (3000, 1);
				timer.addEventListener (TimerEvent.TIMER_COMPLETE, onTimerEnd, false, 0 , true);
				timer.start();
			}
		}
		
		private function onTimerEnd (event:TimerEvent):void {
			
			blank = new Sprite ();
			blank.graphics.beginFill (0xffffff, 1.0);
			blank.graphics.drawRect (0, 0, 560, 560);
			blank.graphics.endFill();
			blank.alpha = 0;
			
			addChild (blank);
			addEventListener (Event.ENTER_FRAME, blankFadeIn, false, 0, true);
		}
		
		private function blankFadeIn(event:Event):void {
			
			if (blank.alpha < 1) {
				blank.alpha += 0.1;
			} else {
				blank.alpha = 1.0;
				removeEventListener (Event.ENTER_FRAME, blankFadeIn);
				
				while (this.numChildren > 0) {
					this.removeChildAt (0);
				}
				
				startUp();
			}
		}
	
		private function wordTagArea(x0:Number, y0:Number, x1:Number, y1:Number):void {
				var n:int = Math.floor (Math.random() * wordList.length);
				var word:String = wordList[n];
				var wordtag:WordTag = new WordTag (word);
				addChild (wordtag);
				wordtag.place(x0, y0, x1, y1);
		}
		
		public function wordTagRequest(x0:Number, y0:Number, x1:Number, y1:Number) {
				rWidth = x1-x0;
				rHeight = y1-y0;
				if ((rWidth > 20) && (rHeight > 20)) {
					addWordTagRequest(x0, y0, x1, y1);
				}
		}
		
		private function addWordTagRequest(x0:Number, y0:Number, x1:Number, y1:Number) {
				var req = {x0:x0, y0:y0, x1:x1, y1:y1};
				wordRequests.push (req);
		}

	}
}
