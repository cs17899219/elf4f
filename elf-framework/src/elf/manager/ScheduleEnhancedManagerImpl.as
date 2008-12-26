package elf.manager
{
	import elf.core.IScheduleEnhancedManager;
	import elf.util.Assert;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;	

	[ExcludeClass]

	/**
	 * @see com.threeti.loof.core.IScheduleEnhancedManager
	 */
	public class ScheduleEnhancedManagerImpl implements IScheduleEnhancedManager 
	{

		private var _schedulers:Dictionary;

		private function get schedulers():Dictionary {
			if (_schedulers == null) {
				_schedulers = new Dictionary();
			}
			return _schedulers;
		}

		public function addScheduler(key:String, delay:Number, repeatCount:int, listener:Function):void {
			Assert.assertNotBlank(key, "key");
			// 检查是否存在key
			var scheduler:Timer = schedulers[key];
			if (scheduler != null) {
				throw new Error("任务[" + key + "]已经存在!");
			}
			
			// 创建Timer
			scheduler = new Timer(delay, repeatCount);
			scheduler.addEventListener(TimerEvent.TIMER, listener);
			scheduler.start();
			
			// 添加到Map
			schedulers[key] = scheduler;
		}

		public function startScheduler(key:String):void {
			Assert.assertNotBlank(key, "key");
			// 检查是否存在key
			var scheduler:Timer = schedulers[key];
			if (scheduler == null) {
				throw new Error("任务[" + key + "]没有找到!");
			}
			
			// 启动
			scheduler.start();
		}

		public function resetScheduler(key:String, delay:Number = NaN, repeatCount:int = 0):void {
			Assert.assertNotBlank(key, "key");
			// 检查是否存在key
			var scheduler:Timer = schedulers[key];
			if (scheduler == null) {
				throw new Error("任务[" + key + "]没有找到!");
			}
			
			if (!isNaN(delay)) {
				scheduler.delay = delay;
			}
			if (repeatCount != 0) {
				scheduler.repeatCount = repeatCount;
			}
			scheduler.reset();
		}

		public function stopScheduler(key:String):void {
			Assert.assertNotBlank(key, "key");
			// 检查是否存在key
			var scheduler:Timer = schedulers[key];
			if (scheduler == null) {
				throw new Error("任务[" + key + "]没有找到!");
			}
			
			// 停止
			scheduler.stop();
		}

		public function removeScheduler(key:String):void {
			Assert.assertNotBlank(key, "key");
			// 检查是否存在key
			var scheduler:Timer = schedulers[key];
			if (scheduler == null) {
				throw new Error("任务[" + key + "]没有找到!");
			}
			
			// 移除
			scheduler.stop();
			delete schedulers[key];
		}

		public function removeAllSchedulers():void {
			// 移除所有
			for (var key:String in schedulers) {
				removeScheduler(key);
			}
		}
	}
}