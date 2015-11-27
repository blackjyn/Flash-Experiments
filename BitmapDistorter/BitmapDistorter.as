
// BitmapDistorter (C) edvardtoth.com

package 
{
	import flash.events.*;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Matrix;
	
	public class BitmapDistorter extends Sprite
	{
		private var topLeftX:Number;
		private var topLeftY:Number;
		private var topRightX:Number;
		private var topRightY:Number;
		private var bottomLeftX:Number;
		private var bottomLeftY:Number;
		private var bottomRightX:Number;
		private var bottomRightY:Number;

		private var topLeftHandle:Handle;
		private var topRightHandle:Handle;
		private var bottomLeftHandle:Handle;
		private var bottomRightHandle:Handle;

		private var topLeft:Point;
		private var topRight:Point;
		private var bottomLeft:Point;
		private var bottomRight:Point;
		
		private var myBitmapData:BitmapData;
		
		private var matrix:Matrix = new Matrix();
		
		private var vtx01:Array;
		private var vtx02:Array;
		private var vtx03:Array;
		private var vtx04:Array;
		
		public function BitmapDistorter (
									inTopLeftX:Number, 
									inTopLeftY:Number, 
									inTopRightX:Number, 
									inTopRightY:Number, 
									inBottomLeftX:Number,
									inBottomLeftY:Number,
									inBottomRightX:Number,
									inBottomRightY:Number,
									inBitmapData:BitmapData
									)

		{
				
			myBitmapData = inBitmapData;
						
			topLeftX 		= inTopLeftX;
			topLeftY 		= inTopLeftY;
			topRightX 		= inTopRightX;
			topRightY 		= inTopRightY;
			bottomLeftX 	= inBottomLeftX;
			bottomLeftY 	= inBottomLeftY;
			bottomRightX 	= inBottomRightX;
			bottomRightY 	= inBottomRightY;

			topLeft 	= new Point (topLeftX, topRightY);
			topRight	= new Point (topRightX, topRightY);
			bottomLeft	= new Point (bottomLeftX, bottomLeftY);
			bottomRight = new Point (bottomRightX, bottomRightY);

			topLeftHandle = new Handle (topLeft.x, topLeft.y);
			topRightHandle = new Handle (topRight.x, topRight.y);
			bottomLeftHandle = new Handle (bottomLeft.x, bottomLeft.y);
			bottomRightHandle = new Handle (bottomRight.x, bottomRight.y);

			addChild (topLeftHandle);
			addChild (topRightHandle);
			addChild (bottomLeftHandle);
			addChild (bottomRightHandle);
						
			// vertices
			vtx01 = new Array (topLeft, 	new Point (0					,0));
			vtx02 = new Array (topRight, 	new Point (myBitmapData.width	,0));
			vtx03 = new Array (bottomLeft,	new Point (0					,myBitmapData.height));
			vtx04 = new Array (bottomRight,	new Point (myBitmapData.width	,myBitmapData.height));

			addEventListener (Event.ENTER_FRAME, updateFrame);
		}

		
		function updateFrame (event:Event):void
		{
			this.graphics.clear ();
			
			topLeft.x = topLeftHandle.x;
			topLeft.y = topLeftHandle.y;
			
			topRight.x = topRightHandle.x;
			topRight.y = topRightHandle.y;
			
			bottomLeft.x = bottomLeftHandle.x;
			bottomLeft.y = bottomLeftHandle.y;
			
			bottomRight.x = bottomRightHandle.x;
			bottomRight.y = bottomRightHandle.y;
			
			
			drawTriangle (vtx01, vtx02, vtx03);
			drawTriangle (vtx02, vtx04, vtx03);	
		}

	
		function drawTriangle( p0In:Array, p1In:Array, p2In:Array ):void
		{
			var points:Array = calcUVs(p0In, p1In, p2In);
			var p0:Point = points[0];
			var p1:Point = points[1];
			var p2:Point = points[2];

			this.graphics.beginBitmapFill(myBitmapData, matrix);

			this.graphics.moveTo(p0.x, p0.y);
			this.graphics.lineTo(p1.x, p1.y);
			this.graphics.lineTo(p2.x, p2.y);
			
			this.graphics.endFill();
		}
		
		function calcUVs( p0In:Array, p1In:Array, p2In:Array):Array
		{
			var p0:Point = p0In[0];
			var uv0:Point = p0In[1];
			var p1:Point = p1In[0];
			var uv1:Point = p1In[1];
			var p2:Point = p2In[0];
			var uv2:Point = p2In[1];

			var du1:Number = uv1.x - uv0.x;
			var dv1:Number = uv1.y - uv0.y;
			var du2:Number = uv2.x - uv0.x;
			var dv2:Number = uv2.y - uv0.y;
			var dx1:Number = p1.x - p0.x;
			var dy1:Number = p1.y - p0.y;
			var dx2:Number = p2.x - p0.x;
			var dy2:Number = p2.y - p0.y;
			var det:Number = 1.0 / ((du1 * dv2) - (du2 * dv1));
			matrix.a = (( dv2 * dx1) + (-dv1 * dx2)) * det;
			matrix.b = (( dv2 * dy1) + (-dv1 * dy2)) * det;
			matrix.c = ((-du2 * dx1) + ( du1 * dx2)) * det;
			matrix.d = ((-du2 * dy1) + ( du1 * dy2)) * det;
			matrix.tx = p0.x - ( (uv0.x * matrix.a) + (uv0.y * matrix.c) );
			matrix.ty = p0.y - ( (uv0.x * matrix.b) + (uv0.y * matrix.d) );

			return(new Array( p0, p1, p2 ) );
		}

	
		
	}
}
