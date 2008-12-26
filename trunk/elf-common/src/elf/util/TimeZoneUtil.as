package elf.util
{
	import mx.utils.ObjectUtil;

	public class TimeZoneUtil 
	{

		public static function UTCtoLocalTimeZone(date:Date,tzo:Number):Date {
			if(null == date) {
				return null;
			}
			var date2:Date = ObjectUtil.copy(date) as Date;
			date2.setMinutes(date2.getMinutes() + date2.timezoneOffset + tzo * 60);
			// trace("UTCtoLocalTimeZone:" + date + " --> " + date2);
			return date2;
		}

		
		public static function LocalTimeZonetoUTC(date:Date,tzo:Number):Date {
			if(null == date) {
				return null;
			}
			var date2:Date = ObjectUtil.copy(date) as Date;
			date2.setMinutes(date2.getMinutes() - date2.timezoneOffset - tzo * 60);
			// trace("LocalTimeZonetoUTC:" + date + " --> " + date2);
			return date2;
		}
	}
}