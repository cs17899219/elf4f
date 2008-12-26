package elf.core
{

	/**
	 * 任务调度管理<br>
	 * 定时执行指定的操作
	 */
	public interface IScheduleEnhancedManager 
	{

		/**
		 * 创建一个调度器
		 * 
		 * @param key 键值
		 * @param delay 延迟
		 * @param repeatCount 重复次数
		 * @param listener 监听方法接受一个TimerEvent作为参数
		 */
		function addScheduler(key:String, delay:Number, repeatCount:int, listener:Function):void;

		/**
		 * 启动一个调度器
		 * 
		 * @param key 调度器键值
		 */
		function startScheduler(key:String):void;

		/**
		 * 重置一个调度器，可以重新设置调度时间
		 * 
		 * @param key 键值
		 * @param delay 延迟
		 * @param repeatCount 重复次数
		 */
		function resetScheduler(key:String, delay:Number = NaN, repeatCount:int = 0):void;

		/**
		 * 停止一个调度器
		 * 
		 * @param key 键值
		 */
		function stopScheduler(key:String):void;

		/**
		 * 移除一个调度器
		 * 
		 * @param key 键值
		 */
		function removeScheduler(key:String):void;
	}
}