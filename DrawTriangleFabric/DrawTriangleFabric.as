// (c) edvardtoth.com

package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.display.TriangleCulling;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
		
	[SWF(width=800,height=800,frameRate=30,backgroundColor=0x0099ff)]
	public class DrawTriangleFabric extends Sprite {
	
		private const GRIDSIZE:int = 20;
		private const GRIDSIZE_MINUS_ONE:int = GRIDSIZE-1;
		private const OCTAVES:int = 3;
		private const SPEED:Number = 0.015;
		
		private var lineAlpha:Number = 0;
		private var lineAlphaMod:Number = 0.01;
		
		//[Embed(source="assets.swf", symbol="Texture")]
		//private var textureAsset:Class;
		private var textureSprite:Sprite = new Cloth();
		
		//[Embed(source="assets.swf", symbol="Decal")]
		//private var decalAsset:Class;
		private var decalSprite:Sprite = new Decal();
		
		private var vertices:Vector.<Number> = new Vector.<Number>;
		private var uvtData:Vector.<Number> = new Vector.<Number>;
		private var indices:Vector.<int> = new Vector.<int>;
		private var projectedVerts:Vector.<Number> = new Vector.<Number>;

		private var noiseMap:BitmapData = new BitmapData(GRIDSIZE, GRIDSIZE, false);
		private var texture:BitmapData;
		
		private var view:PerspectiveProjection = new PerspectiveProjection();
		private var canvas:Sprite = new Sprite();
		private var transformMatrix:Matrix3D = new Matrix3D;
		private var scaleMatrix:Matrix = new Matrix();
		
		public function DrawTriangleFabric() {
				
			// setup stage properties
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			stage.align = StageAlign.TOP_LEFT;
			
			// generate texture from embedded asset
			//textureSprite = new textureAsset() as Sprite;
			texture = new BitmapData (textureSprite.width, textureSprite.height, false);
			texture.draw (textureSprite);			
	
			// center canvas
			canvas.x = stage.stageWidth * 0.5;
			canvas.y = stage.stageHeight * 0.5;
			addChild(canvas);
			
			// setup projection
			view.fieldOfView = 35;
			view.projectionCenter = new Point (stage.stageWidth * 0.5, stage.stageHeight * 0.5);
			
			// add decal
			//decalSprite = new decalAsset() as Sprite;
			addChild (decalSprite);
			decalSprite.x = stage.stageWidth;
			decalSprite.y = 0;
			decalSprite.cacheAsBitmap = true;
			
			// position projection using a matrix
			transformMatrix.prependScale(.8,.03,.8);
			transformMatrix.appendRotation(-45, Vector3D.X_AXIS);
			transformMatrix.appendRotation(25, Vector3D.Y_AXIS);
			transformMatrix.appendRotation(180, Vector3D.Z_AXIS);
			transformMatrix.appendTranslation (-9.5,-7,-22);
			transformMatrix.append(view.toMatrix3D());
			
			// prepare a matrix used to fit the noisemap to the bigger texturemap
			scaleMatrix.scale (texture.width / noiseMap.width, texture.height / noiseMap.height);
			
			addEventListener(Event.ENTER_FRAME, updateFrame, false, 0, true);
		}
		
		private function updateFrame(event:Event):void {

			// generate vertex, index and UV data
			for (var yPos:int = 0; yPos < GRIDSIZE; yPos++) {
				
				for (var xPos:int = 0; xPos < GRIDSIZE; xPos++) {
					
					// y coordinate (second value) is derived from clamped grayscale values of the noise map
					vertices.push (xPos-GRIDSIZE, -(noiseMap.getPixel(xPos, yPos) & 0xFF), yPos-GRIDSIZE);
					uvtData.push (xPos / GRIDSIZE_MINUS_ONE, yPos / GRIDSIZE_MINUS_ONE, 0);
					
					if (yPos < GRIDSIZE_MINUS_ONE && xPos < GRIDSIZE_MINUS_ONE) {
						
						// triangle 1
						indices.push (
							yPos * GRIDSIZE + xPos,
							yPos * GRIDSIZE + xPos + 1,
							(yPos + 1) * GRIDSIZE + xPos);
						
						// triangle 2
						indices.push (
							yPos * GRIDSIZE + xPos + 1,
							(yPos + 1) * GRIDSIZE + xPos + 1,
							(yPos + 1) * GRIDSIZE + xPos);						
					}
				}
			}
	
			var offsets:Array = [];
			var offset:Number = getTimer() * SPEED;
			
			for(var i:uint = 0; i < OCTAVES; i++) {
				
				// offsets are used for animating the various octaves of the perlin noise map
				offsets.push(new Point(0, offset/(i+1)));
			}
			
			// render noiseMap
			noiseMap.perlinNoise(GRIDSIZE, GRIDSIZE, OCTAVES, 32, true, true, BitmapDataChannel.ALPHA, true, offsets);
			// refresh texture
			texture.draw (textureSprite);
			// draw noiseMap on top of texture with HARDLIGHT blendmode to achieve highlights/sheen
			texture.draw (noiseMap, scaleMatrix, null, BlendMode.HARDLIGHT, null, true);
			
			// project
			Utils3D.projectVectors(transformMatrix, vertices, projectedVerts, uvtData);
					
				// modify gridline alpha values
				lineAlpha += lineAlphaMod;
				if (lineAlpha >= 1.0 || lineAlpha <=0) {
					lineAlphaMod *= -1;
				}
			
			// draw
			canvas.graphics.clear();
			canvas.graphics.lineStyle(1.0, 0x000000, lineAlpha);
			canvas.graphics.beginBitmapFill(texture, null, false, true);
			canvas.graphics.drawTriangles(projectedVerts, indices, uvtData, TriangleCulling.NONE);
			canvas.graphics.endFill();
			
			// clear vectors
			vertices.length = 0;
			uvtData.length = 0;
			indices.length = 0;
		}
	}
}