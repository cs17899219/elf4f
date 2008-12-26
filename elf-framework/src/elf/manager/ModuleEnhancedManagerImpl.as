package elf.manager
{
	import elf.core.IModuleEnhancedManager;
	import elf.events.ElfModuleEvent;
	import elf.util.Assert;
	
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.events.ModuleEvent;
	import mx.modules.ModuleLoader;	

	[ExcludeClass]

	/**
	 * @see com.threeti.loof.core.IModuleEnhancedManager
	 */
	public class ModuleEnhancedManagerImpl implements IModuleEnhancedManager
	{
		private var moduleList:Dictionary = new Dictionary();

		private var eventDispatcher:IEventDispatcher;

		public function ModuleEnhancedManagerImpl(dispatcher:IEventDispatcher) {
			this.eventDispatcher = dispatcher;
		}

		public function load(url:String):ModuleLoader {
			Assert.assertNotBlank(url, "url");
			
			var ml:ModuleLoader;
			if(moduleList[url] == null) {
				ml = new ModuleLoader;
				ml.addEventListener(ModuleEvent.READY, moduleEventHandler, false, 0, true);
				ml.addEventListener(ModuleEvent.ERROR, moduleEventHandler, false, 0, true);
				ml.addEventListener(ModuleEvent.PROGRESS, moduleEventHandler, false, 0, true);
				ml.addEventListener(ModuleEvent.SETUP, moduleEventHandler, false, 0, true);
				ml.addEventListener(ModuleEvent.UNLOAD, moduleEventHandler, false, 0, true);
				
				ml.url = url;
				ml.loadModule();
				
				moduleList[url] = ml ;
			}else {
				ml = moduleList[url];
				ml.loadModule();
			}
			return ml;
		}

		public function unload(url:String):ModuleLoader {
			Assert.assertNotBlank(url, "url");
			
			var moduleLoader:ModuleLoader = null;
			if(moduleList[url] != null) {
				moduleLoader = moduleList[url] as ModuleLoader;
				moduleLoader.unloadModule();
				moduleLoader.removeEventListener(ModuleEvent.ERROR, moduleEventHandler);
				moduleLoader.removeEventListener(ModuleEvent.PROGRESS, moduleEventHandler);
				moduleLoader.removeEventListener(ModuleEvent.READY, moduleEventHandler);
				moduleLoader.removeEventListener(ModuleEvent.SETUP, moduleEventHandler);
				moduleLoader.removeEventListener(ModuleEvent.UNLOAD, moduleEventHandler);
				moduleList[url] = null;
				delete moduleList[url];
			}
			return moduleLoader;
		}

		private function moduleEventHandler(event:ModuleEvent):void {
			eventDispatcher.dispatchEvent(ElfModuleEvent.convertModuleEvent(event));
		}
	}
}
