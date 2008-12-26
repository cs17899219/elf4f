package elf.core
{
	import elf.events.ElfModuleEvent;
	import elf.manager.*;
	import elf.util.Assert;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;	

	[Event(name="setup", type="com.threeti.loof.events.LoofModuleEvent")]

	[Event(name="ready", type="com.threeti.loof.events.LoofModuleEvent")]

	[Event(name="error", type="com.threeti.loof.events.LoofModuleEvent")]

	[Event(name="progress", type="com.threeti.loof.events.LoofModuleEvent")]

	[Event(name="unload", type="com.threeti.loof.events.LoofModuleEvent")]

	/**
	 * Loof-Framework 基础应用支持入口<br>
	 * 
	 * 通过 Framework.getInstance();来得到实例<br>
	 * 可以在Framework的实例上监听Framework的事件.<br>
	 * 
	 * @see com.threeti.loof.core.IPubliceDataAccessEnhancedManager
	 * @see com.threeti.loof.core.IModuleEnhancedManager
	 * @see com.threeti.loof.core.IScheduleEnhancedManager
	 * @see com.threeti.loof.core.IPopUpEnhancedManager
	 */
	public class Framework 
	{
		/** 
		 * @private
		 */
		private static var instance:Framework;

		/** 
		 * @private
		 */
		private var eventDispatcher:IEventDispatcher = new EventDispatcher(null);

		/**
		 * Constructor
		 */
		public function Framework() {
			if(Framework.instance) {
				throw new Error('Loof singleton error!');
			}else {
				Framework.instance = this;
				this.addEventListener(ElfModuleEvent.UNLOAD, moduleUnloadHandler); //监听模块移除
			}
		}

		/** 得到单例对象 */
		public static function getInstance():Framework {
			if(!Framework.instance) {
				new Framework();
			}
			return Framework.instance;
		}

		/** 
		 * @private 
		 */
		protected function moduleUnloadHandler(event:ElfModuleEvent):void {
			//TODO 得到scope 
			var scope:String = event.module.url;
			
			if(schedulerEnhancedManagerDic[scope]) {
				//关闭为这个模块准备的调度器
				ScheduleEnhancedManagerImpl(schedulerEnhancedManagerDic[scope]).removeAllSchedulers();
				schedulerEnhancedManagerDic[scope] = null;
				delete schedulerEnhancedManagerDic[scope];
			}
		}

		/* ************************************************
		 *  事件派发者
		 ************************************************** */
		
		/**
		 * Adds an event listener.
		 * @see flash.events.IEventDispatcher#addEventListener
		 */
		public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void {
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * Removes an event listener.
		 * @see flash.events.IEventDispatcher#removeEventListener
		 */
		public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void {
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		/**
		 * Returns whether an event listener exists.
		 * @see flash.events.IEventDispatcher#hasEventListener
		 */
		public function hasEventListener( type:String ):Boolean {
			return eventDispatcher.hasEventListener(type);
		}

		/**
		 * Returns whether an event will trigger.
		 * @see flash.events.IEventDispatcher#willTrigger
		 */
		public function willTrigger(type:String):Boolean {
			return eventDispatcher.willTrigger(type);
		}

		/* ************************************************
		 *  管理器入口                                           *
		 ************************************************ */
 		 
		/* 模块管理器 */
		private var memi:ModuleEnhancedManagerImpl = new ModuleEnhancedManagerImpl(eventDispatcher);

		/**
		 * 得到模块管理器<br>
		 */
		public function getModuleManager():IModuleEnhancedManager {
			return memi;
		}

		/* 公共数据访问管理器 */
		private var pdaemi:PubliceDataAccessEnhancedManagerImpl = new PubliceDataAccessEnhancedManagerImpl;

		/**
		 * 得到公共数据访问管理器<br>
		 */
		public function getPubliceDataAccessManager():IPubliceDataAccessEnhancedManager {
			return pdaemi;
		}

		/* 弹出窗口管理器 */
		private var ppupmDic:Dictionary = new Dictionary(true);
		private var ppupm:PopUpEnhancedManagerImpl = new PopUpEnhancedManagerImpl;

		/**
		 * 得到弹出窗口管理器<br>
		 */
		public function getPopUpManager(thisUI:UIComponent):IPopUpEnhancedManager {
			Assert.assertNotNull(thisUI);
			if(ppupmDic[thisUI] == null) {
				ppupmDic[thisUI] = new PopUpEnhancedManagerProxy(thisUI, ppupm);
			}
			return ppupmDic[thisUI];
		}

		/* 调度管理器 */
		private var schedulerEnhancedManagerDic:Dictionary = new Dictionary;
		private var sem:ScheduleEnhancedManagerImpl = new ScheduleEnhancedManagerImpl;

		/**
		 * 得到调度管理器<br>
		 */
		public function getScheduleManager(scope:String = null):IScheduleEnhancedManager {
			if(scope == null) {
				return sem;
			}else {
				if(schedulerEnhancedManagerDic[scope] == null) {
					schedulerEnhancedManagerDic[scope] = new ScheduleEnhancedManagerImpl;
				}
				return schedulerEnhancedManagerDic[scope];
			}
		}
	}
}

import flash.display.DisplayObject;

import mx.core.IFlexDisplayObject;
import mx.core.UIComponent;

import elf.core.IPopUpEnhancedManager;
import elf.manager.PopUpEnhancedManagerImpl;
import elf.core.IPopUpEnhancedManager;

/**
 * PopUpEnhancedManagerProxy
 */
class PopUpEnhancedManagerProxy implements IPopUpEnhancedManager
{
	private var _manager:PopUpEnhancedManagerImpl;
	private var _uid:String;

	public function PopUpEnhancedManagerProxy(parentUI:UIComponent, manager:PopUpEnhancedManagerImpl) {
		this._uid = parentUI.uid;
		this._manager = manager;
		this._manager.register(parentUI);//注册这个UI组件
	}

	public function showSingletonPopUp(parent:DisplayObject,
                                   className:Class,
                                   modal:Boolean = false,
                                   childList:String = null):IFlexDisplayObject {
		return _manager.showSingletonPopUp(_uid, parent, className, modal, childList);                	
	}

	
	public function removeSingletonPopUp(className:Class):void {
		_manager.removeSingletonPopUp(className);
	}

	public function getSingletonPopUp(className:Class):IFlexDisplayObject {
		return _manager.getSingletonPopUp(className);          
	}

	public function removeAllPopUp():void {
		_manager.removeAllPopUp();
	}
}