package elf.events
{
	import flash.events.Event;

	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleLoader;	

	[ExcludeClass]

	/**
	 * LoofModuleEvent
	 */
	public class ElfModuleEvent extends Event 
	{
		/** 模块加载错误 */
		public static const ERROR:String = "loof_" + ModuleEvent.ERROR;
		/** 模块加载中 */
		public static const PROGRESS:String = "loof_" + ModuleEvent.PROGRESS;
		/** 模块加载 */
		public static const READY:String = "loof_" + ModuleEvent.READY;
		/** 模块信息部分完成 */
		public static const SETUP:String = "loof_" + ModuleEvent.SETUP;
		/** 模块卸载 */
		public static const UNLOAD:String = "loof_" + ModuleEvent.UNLOAD;

		private var _bytesLoaded:uint;

		private var _bytesTotal:uint;

		private var _errorText:String;

		private var _module:IModuleInfo;

		private var _targetModuleLoader:ModuleLoader;

		public function get bytesLoaded():uint {
			return _bytesLoaded;
		}

		public function get bytesTotal():uint {
			return _bytesTotal;
		}

		public function get errorText():String {
			return _errorText;
		}

		public function get module():IModuleInfo {
			return _module;
		}

		public function get targetModuleLoader():ModuleLoader {
			return _targetModuleLoader;
		}

		public function ElfModuleEvent(type:String, targetModuleLoader:ModuleLoader,
											bubbles:Boolean = false, cancelable:Boolean = false,
											bytesLoaded:uint = 0, bytesTotal:uint = 0,
											errorText:String = null, module:IModuleInfo = null) {
			this._bytesLoaded = bytesLoaded;
			this._bytesTotal = bytesTotal;
			this._errorText = errorText;
			this._module = module;
			this._targetModuleLoader = targetModuleLoader;
			super(type, bubbles, cancelable);
		}

		public static function convertModuleEvent(event:ModuleEvent):ElfModuleEvent {
			return new ElfModuleEvent("loof_" + event.type, ModuleLoader(event.target), event.bubbles, event.cancelable, event.bytesLoaded, event.bytesTotal, event.errorText, event.module);
		}
	}
}