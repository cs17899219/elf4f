package elf.manager
{
	import flash.display.DisplayObject;
	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.utils.ObjectUtil;	

	[ExcludeClass]

	/**
	 * @see com.threeti.loof.core.IPopUpEnhancedManager
	 */
	public class PopUpEnhancedManagerImpl 
	{
		private var views:Dictionary = new Dictionary();

		public function showSingletonPopUp(uid:String, parent:DisplayObject,
                                       className:Class,
                                       modal:Boolean = false,
                                       childList:String = null):IFlexDisplayObject {   
			var view:IFlexDisplayObject;
			var vu:ViewUnit = views[className];
			if (vu != null) {
				view = vu.view;
				PopUpManager.bringToFront(view);
				trace("bringToFront: " + ObjectUtil.toString(className));
			}else {
				view = PopUpManager.createPopUp(parent, className, modal, childList);
				PopUpManager.centerPopUp(view);
				views[className] = new ViewUnit(uid, view);
				trace("showPopUp: " + ObjectUtil.toString(className));
			}
			return view;
		}

		public function removeSingletonPopUp(className:Class):void {
			if(views[className]) {
				var vu:ViewUnit = views[className];
				PopUpManager.removePopUp(vu.view);
				trace("removePopUp: " + ObjectUtil.toString(className));
				views[className] = null;
				delete views[className];
			}else {
				trace("removePopUp failed: " + ObjectUtil.toString(className));
			}
		}

		public function getSingletonPopUp(className:Class):IFlexDisplayObject {
			var vu:ViewUnit = views[className];
			return vu.view;
		}

		/** 注册监听 */
		public function register(ui:UIComponent):void {
			if(ui is Application){
	    		//TODO 如果是Application
	    	}else {
				ui.addEventListener(FlexEvent.REMOVE, uiRemoveHandler, false, 3);
			}
		}

		/** UI移除时触发 */
		private function uiRemoveHandler(event:FlexEvent):void {
			trace("uiRemoveHandler: event.target=" + event.target);
			var ui:UIComponent = UIComponent(event.target);
			removeByUid(ui.uid);
			//由于字典存在同步问题，这里调用3次，确保一定程度不会有问题
			setTimeout(removeByUid, 500, ui.uid);
			setTimeout(removeByUid, 1000, ui.uid);
			System.gc();
		}

		private function removeByUid(uid:String):void {
			for ( var className:Object in views) {
				var vu:ViewUnit = views[className];
				if(uid.length >= vu.uid.length && uid.slice(0, vu.uid.length) == vu.uid) {
					PopUpManager.removePopUp(vu.view);
					trace("removePopUp: " + ObjectUtil.toString(className));
					views[className] = null;
					delete views[className];
				}
			}
		} 

		public function removeAllPopUp():void {
			for ( var className:Object in views) {
				PopUpManager.removePopUp(views[className].view);
				trace("removePopUp: " + ObjectUtil.toString(className));
				views[className] = null;
				delete views[className];
			}
		}
	}
}

import mx.core.IFlexDisplayObject;

/**
 * 内部的
 */
class ViewUnit 
{
	public function ViewUnit(uid:String,view:IFlexDisplayObject) {
		this.view = view;
		this.uid = uid;
	}

	public var view:IFlexDisplayObject;
	public var uid:String;
}
