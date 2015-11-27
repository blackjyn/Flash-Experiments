// SimpleInterpolation function (C) edvardtoth.com
//
// baseRangeStart - start value of the base numeric range
// baseRangeEnd - end value of the base numeric range
// baseCurrentValue - an arbitrary value within the base range: this is the value that's going to be interpolated to a corresponding value within the target range
// targetRangeStart - start value of the target numeric range
// targetRangeEnd - end value of the target numeric range
//
// Basic example: SimpleInterpolation (0, 1, 0.6, 0, 100);
// This will return 60 since in a proportional sense 0.6 in the 0-to-1 range is the same as 60 in the 0-to-100 range.

function SimpleInterpolation (baseRangeStart:Number, baseRangeEnd:Number, baseCurrentValue:Number, targetRangeStart:Number, targetRangeEnd:Number):Number
{
	var baseRangeFull:Number = baseRangeEnd - baseRangeStart;
	var baseFinalValue:Number;
	var targetCurrentValue:Number;	
		
	if (baseRangeFull == 0)
	{
		baseFinalValue = 1;
	} 
	else 
	{
		baseFinalValue = (Math.min (Math.max ((baseCurrentValue - baseRangeStart) / baseRangeFull, 0.0), 1.0));
	}
			 
	targetCurrentValue = (targetRangeStart + ((targetRangeEnd - targetRangeStart) * baseFinalValue));
	return targetCurrentValue;
}