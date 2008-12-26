package elf.core
{
	import mx.modules.ModuleLoader;				

	/**
	 * 加载模块 卸载模块
	 */
	public interface IModuleEnhancedManager 
	{
		/** 加载模块 */
		function load(url:String):ModuleLoader;

		/** 卸载模块 */
		function unload(url:String):ModuleLoader;
	}
}