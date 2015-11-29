

package {

	public class Utils
	{

		static public function randomize(min:Number, max:Number):Number 
		{
			return (Math.random()*(max - min) + min);
		}
		static public function toRadians (inDegrees:Number):Number
		{
			return (inDegrees * Math.PI / 180);
		}
		static public function toDegrees (inRadians:Number):Number
		{
			return (inRadians * 180 / Math.PI);
		}
		
		
	}
	
}