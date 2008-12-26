package elf.util 
{
	import mx.formatters.DateFormatter;
	import mx.formatters.NumberFormatter;
	import mx.utils.StringUtil;

	public class LabelUtil 
	{
		public static function getFileSize(fileSize:Number):String {
			if (fileSize >= 0 && fileSize < 1024 * 1024) {
				var size:int = int(fileSize / 1024);
				return size == 0 ? "1K" : size + "K";
			} else if (fileSize >= 1024 * 1024) {
				var nf:NumberFormatter = new NumberFormatter();
				nf.precision = 2;
				return nf.format(fileSize / 1024 / 1024) + "M";
			}
			return "";
		}

		public static function getSizeStr(size:Number):String {	
			if (size >= 1024 * 1024) {
				return int(size / 1024 / 1024) + "M";
			} else if (size > 0 && size < 1024 * 1024) {
				return "1M";
			} else {
				return "0M";
			}
		}

		public static function getFullDateLabel(date:Date):String {
			
			var df:DateFormatter = new DateFormatter();
			//df.formatString = "YYYY-MM-DD";
			df.formatString = "YYYY-MM-DD HH:NN:SS";
			return df.format(date);
		}

		public static function getDateLabel(date:Date):String {
			
			var df:DateFormatter = new DateFormatter();
			//df.formatString = "YYYY-MM-DD";
			df.formatString = "YYYY-MM-DD";
			return df.format(date);
		}

		public static function getDateTimeLabel(date:Date):String {
			var dateTemp:Date = new Date();
			if(date != null) {
			
				if(dateTemp.fullYear > date.fullYear) {
					return getDateLabel(date);
				}
				if((dateTemp.fullYear == date.fullYear) && (dateTemp.month == date.month) && (dateTemp.date == date.date)) {
					return getDayDateTimeLabel(date);
				}
				if(dateTemp.fullYear == date.fullYear) {
					return getNoYearDateTimeLabel(date);
				}
			}
			var df:DateFormatter = new DateFormatter();
			df.formatString = "YYYY-MM-DD HH:NN:SS";
			return df.format(date);
		}

		public static function getDayDateTimeLabel(date:Date):String {
			var df:DateFormatter = new DateFormatter();
			df.formatString = "HH:NN";
			return df.format(date);
		}

		public static function getNoYearDateTimeLabel(date:Date):String {
			var df:DateFormatter = new DateFormatter();
			df.formatString = "MM-DD";
			return df.format(date);
		}

		public static function omitString(str:String, reservedBit:Number):String {
			var count:Number = 0; 
			// 字符串的位置
			var index:Number = str.length - 1; 
			// 字符索引
			for (var i:int = 0;i < str.length; i++) {
				if (str.charCodeAt(i) < 256) { 
					// ascii字符
					count += 1;
				} else { 
					// 其他字符，包括汉字
					count += 2;
				}
				
				if (count > reservedBit) { 
					// 记录不超过保留位的字符索引
					index = i;
					break ;
				}
			}
			var result:String = str;
			if (count > reservedBit) {
				result = result.substring(0, index);
				result += "...";
			}
			return result;
		}

		public static function isBlank(str:String):Boolean {
			if (str == null) {
				return true;
			}
			str = StringUtil.trim(str);
			return str.length == 0 || StringUtil.isWhitespace(str);
		}
	}
}
