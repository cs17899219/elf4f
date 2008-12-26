package elf.core
{
	import flash.display.DisplayObject;

	import mx.core.IFlexDisplayObject;	

	/**
	 * 显示/关闭单例窗口
	 */
	public interface IPopUpEnhancedManager 
	{
		/** 显示单例窗口 */
		function showSingletonPopUp(parent:DisplayObject,
									className:Class,
									modal:Boolean = false,
									childList:String = null):IFlexDisplayObject;

		/** 关闭单例窗口 */
		function removeSingletonPopUp(className:Class):void;

		/** 得到单例窗口的引用 */
		function getSingletonPopUp(className:Class):IFlexDisplayObject;

		/** 关闭所有通过该管理器打开的窗口 */
		function removeAllPopUp():void;
	}
}