package elf.events
{
	import flash.events.Event;

	import elf.core.ElfEventDispatcher;

	/**
	 * Loof事件<br>
	 * 用于处理同步调用和异步调用,支持事件链功能<br>
	 * 用法：<br>
	 * new LoofEvent('tpye1',arg1)<br>
	 * .addNextEvent(new LoofEvent('tpye2',arg2))<br>
	 * .addNextEvent(new LoofEvent('tpye3',arg3))<br>
	 * .addNextEvent(new LoofEvent('tpye4',arg4))<br>
	 * .dispatch(); <br>
	 * 执行顺序是 tpye1 -> tpye2 -> tpye3 -> tpye4 <br>
	 */	
	public class ElfEvent extends Event 
	{

		/**
		 * @private
		 */
		private var _nextEvent:ElfEvent;

		/**
		 * 得到下一个事件
		 */
		public function get nextEvent():ElfEvent {
			return _nextEvent;
		}

		/**
		 * @private
		 */
		private var _stopTransferOnFault:Boolean = true;

		/**
		 * 在远程调用发生错误的时候停止传递
		 */
		public function get stopTransferOnFault():Boolean {
			return _stopTransferOnFault;
		}

		/**
		 * @private
		 */
		public var arg:Array;

		/**
		 * @private
		 */
		public var resultFunction:Function;

		/**
		 * @private
		 */
		public var falutFunction:Function;

		/**
		 * Constructor
		 * 
		 * @param type 事件类型
		 * @param arg 参数列表
		 * @param resultFunction 成功回调用(这里返回远程对象返回的对象)
		 * @param falutFunction 失败回调用(这里返回FaultEvent)
		 */
		public function ElfEvent(type:String, arg:Array = null, 
			resultFunction:Function = null, falutFunction:Function = null ,
			bubbles:Boolean = false, cancelable:Boolean = false) {
			this.arg = arg;
			this.resultFunction = resultFunction;
			this.falutFunction = falutFunction;
			super(type, bubbles, cancelable);
		}

		/**
		 * 添加下一个派发的事件
		 * 
		 * @param event 下一个事件
		 * @param stopTransferOnFault 远程调用出错是否停止下一个事件的调用，(默认是true)
		 * @return 返回事件自身(注意!不是返回添加的事件)
		 */
		public function addNextEvent(event:ElfEvent,stopTransferOnFault:Boolean = true):ElfEvent {
			if(_nextEvent) {
				_nextEvent.addNextEvent(event, stopTransferOnFault);
			}else {
				_nextEvent = event;
				_stopTransferOnFault = stopTransferOnFault;
			}
			return this;
		}

		
		/**
		 * 派发事件
		 * @return 如果成功返回True
		 */
		public function dispatch():Boolean {
			return ElfEventDispatcher.getInstance().dispatchEvent(this);
		}
	}
}