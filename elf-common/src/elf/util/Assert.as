package elf.util
{
	import mx.utils.StringUtil;

	/**
	 * 断言类
	 */
	public class Assert 
	{
		/** 
		 * 判断对象不是Null，如果为Null,显示错误消息
		 * 
		 * @param obj 需要判断的对象
		 * @param msg 错误消息的对象名
		 */
		public static function assertNotNull(obj:*, msg:String = null):void {
			if (obj == null)
				throw new Error(msg ? msg + " can not be Null." : "Error occur on Assert notNull()");
		}

		/** 
		 * 判断对象是Null，如果为不是Null,显示错误消息
		 * 
		 * @param obj 需要判断的对象
		 * @param msg 错误消息的对象名
		 */
		public static function assertNull(obj:*, msg:String = null):void {
			if (obj != null)
				throw new Error(msg ? msg + " must be Null." : "Error occur on Assert notNull()");
		}

		
		/** 
		 * 判断String是否为空白，空白包括 Null、没有输入、Whitespace
		 * 
		 * @param str 需要判断的字符串
		 * @param msg 错误消息的对象名
		 */
		public static function assertNotBlank(str:String, msg:String = null):void {
			if (str == null) {
				throw new Error(msg ? msg + " can not be Blank." : "Error occur on Assert notBlank()");
			}
			str = StringUtil.trim(str);
			if( str.length == 0 || StringUtil.isWhitespace(str)) {
				throw new Error(msg ? msg + " can not be Blank." : "Error occur on Assert notBlank()");
			}
		}

		/** 
		 * 判断Boolean<br>
		 * 如果false，显示错误消息
		 * 
		 * @param obj 需要判断的Boolean
		 * @param msg 错误消息的对象名
		 */
		public static function assertTrue(obj:Boolean, msg:String = null):void {
			if (!obj)
				throw new Error(msg ? msg + " can not be False." : "Error occur on Assert notFalse()");
		}
	}
}