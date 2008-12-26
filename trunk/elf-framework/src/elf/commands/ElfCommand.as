package elf.commands
{
	import elf.events.ElfEvent;				

	/**
	 * LoofCommand<br>
	 * 
	 * 这个类是线程安全的，会为每次请求建立一个实例<br>
	 * 
	 */
	public class ElfCommand implements IRemoteCommand 
	{
		/**
		 * @private
		 */
		private var _faultFunction:Function;

		/**
		 * @private
		 */
		public function set faultFunction(value:Function):void {
			_faultFunction = value;
		}

		/**
		 * @private
		 */
		private var _resultFunction:Function;

		/**
		 * @private
		 */
		public function set resultFunction(value:Function):void {
			_resultFunction = value;
		}

		/**
		 * @private
		 */
		private var _nextEvent:ElfEvent;

		/**
		 * @private
		 */
		public function set nextEvent(value:ElfEvent):void {
			_nextEvent = value;
		}

		/**
		 * @private
		 */
		private var _stopTransferOnFault:Boolean;

		/**
		 * @private
		 */
		public function set stopTransferOnFault(value:Boolean):void {
			_stopTransferOnFault = value;
		}

		/**
		 * @private
		 */
		public function execute(event:ElfEvent):void {
			executeCommand(event);
		}

		/**
		 * @private
		 */
		public function executeCommand(event:ElfEvent):void {
			throw new Error('this method must be override.');
		}

		/**
		 * @private
		 */
		public function result(data:Object):void {
			this.onResult(data);
			if(_resultFunction != null)
				_resultFunction(data);
			if(_nextEvent)
				_nextEvent.dispatch();
		}

		/**
		 * 远程调用成功时候的处理
		 */
		public function onResult(data:Object):void {
			throw new Error('this method must be override.');
		}

		/**
		 * @private
		 */
		public function fault(info:Object):void {
			this.onFault(info);
			if(_faultFunction != null)
				_faultFunction(info);
			//TODO这里需要处理下失败消息
			if(!_stopTransferOnFault && _nextEvent)
				_nextEvent.dispatch();
		}

		/**
		 * 远程调用失败时候的处理
		 */
		public function onFault(info:Object):void {
			throw new Error('this method must be override.');
		}
	}
}