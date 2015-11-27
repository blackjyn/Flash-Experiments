package  
{
	public class Utils 
	{
		public function Utils() 
		{
		}

		public static function randomize(min:Number, max:Number):Number
		{
			return Math.random()*(max - min) + min
		}
		
	}
	
}