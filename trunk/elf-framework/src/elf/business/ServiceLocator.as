package elf.business
{
	import elf.util.Assert;
	
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import mx.core.IMXMLObject;
	import mx.messaging.MessageAgent;
	import mx.rpc.AbstractInvoker;
	import mx.rpc.AbstractService;	

	/**
	 * 远程服务定位器<br>
	 * 
	 * 远程服务定位器，用于配置远程服务 所配置的远程服务必须指定id<br>
	 * 允许在多个地方使用，可以通过getInstance获得首个实例<br>
	 * 
	 * 范例：
	 * Service.mxml<br>
	 * 
	 *  &lt;?xml version="1.0" encoding="utf-8"?&gt;<br>
	 *  &lt;loof:ServiceLocator xmlns:loof="http://loof.3ti.us/2008/mxml"<br>
	 *	&nbsp;&nbsp;&nbsp;&nbsp;xmlns:mx="http://www.adobe.com/2006/mxml"&gt;<br>
	 *  &nbsp;&nbsp;&nbsp;&nbsp;&lt;mx:RemoteObject id="user" destination="userdestination" /&gt;<br>
	 *  &nbsp;&nbsp;&nbsp;&nbsp;&lt;mx:RemoteObject id="product" destination="productdestination" /&gt;<br>
	 *  &nbsp;&nbsp;&nbsp;&nbsp;&lt;mx:DataService id="dataService"/&gt;<br>
	 *  &nbsp;&nbsp;&nbsp;&nbsp;// other remote service here ...<br>
	 *  &lt;/loof:ServiceList&gt;<br>
	 *  <br>
	 */
	public class ServiceLocator implements IMXMLObject,IServiceContainer 
	{
		/** 
		 * @private
		 */
		private static var instance:ServiceLocator;

		/**
		 * Constructor
		 */
		public function ServiceLocator() { 
			if(ServiceLocator.instance){
				//如果实例存在，表明从其他地方创建的,ServiceLocator.instance只保存首个ServiceLocator实例;
			}else {
				ServiceLocator.instance = this;
			}
		}

		/**
		 * 得到单例对象
		 * @return ServiceLocator的实例
		 */
		public static function getInstance():ServiceLocator {
			if(!ServiceLocator.instance) {
				new ServiceLocator();
			}
			return ServiceLocator.instance;
		}

		/**
		 * MXML初始化完成后调用此方法
		 * 
		 * @private
		 * @see mx.core.IMXMLObject#initialized
		 */
		public function initialized(document:Object, id:String):void {
			ServiceLocator.getInstance().register(this);
		}

		/**
		 * 远程服务列表
		 * @private
		 */
		private var _services:Dictionary;

		/**
		 * 得到服务列表，如果不存在初始化
		 * @private
		 */
		private function get services():Dictionary {
			if (_services == null) {
				_services = new Dictionary(true);
			}
			return _services;
		}

		/** 
		 * 通过Id得到远程服务对象
		 */
		public function getService(id:String):Object {
			Assert.assertNotBlank(id, "name");
			var service:Object = getRemoteServiceByName(id);
			if (service == null) {
				throw new Error("服务[" + id + "]没有找到!");
			}
			return service;
		}

		/**
		 * 添加一个远程服务对象
		 */
		public function addService(id:String, service:Object):void {
			Assert.assertNotBlank(id, "name");
			Assert.assertNotNull(service, "service");
			var tmp:Object = getRemoteServiceByName(id);
			if (tmp != null) {
				throw new Error("服务[" + id + "]已经存在!");
			}
			if (!isRemoteService(service)) {
				throw new Error("[" + id + "]不是一个远程服务对象!");
			}
			services[service] = id;
		}

		/**
		 * 移除一个远程服务对象<br>
		 *  -暂时不要使用！
		 */
		public function removeService(name:String):void {
			Assert.assertNotBlank(name, "name");
			var service:Object = getRemoteServiceByName(name);
			if (service == null) {
				throw new Error("服务[" + name + "]没有找到!");
			}
			if(service is AbstractService) {
				AbstractService(service).logout();
			}else if(service is MessageAgent) {
				MessageAgent(service).logout();
			}
			
			// 注销服务
			services[service] = null;
			delete services[service]; // 从列表冲移除
		}

		/**
		 * 移除所有远程服务对象<br>
		 *  -暂时不要使用！
		 */
		public function removeAll():void {
			for ( var service:Object in services) {
				if(service is AbstractService) {
					AbstractService(service).logout();
				}else if(service is MessageAgent) {
					MessageAgent(service).logout();
				}
				services[service] = null;
				delete services[service];
			}
		}

		/**
		 * Set the credentials for all registered services.
		 * @param username the username to set.
		 * @param password the password to set.
		 */
		public function setCredentials(username:String, password:String):void {
			for ( var service:Object in services) {
				if(service is AbstractService) {
					AbstractService(service).logout();
					AbstractService(service).setCredentials(username, password);
				}else if(service is MessageAgent) {
					MessageAgent(service).logout();
					MessageAgent(service).setCredentials(username, password);
				}
			}
		}

		/**
		 * Set the remote credentials for all registered services.
		 * @param username the username to set.
		 * @param password the password to set.
		 */
		public function setRemoteCredentials(username:String, password:String):void {
			for ( var service:Object in services) {
				if(service is AbstractService) {
					AbstractService(service).logout();
					AbstractService(service).setRemoteCredentials(username, password);
				}else if(service is MessageAgent) {
					MessageAgent(service).logout();
					MessageAgent(service).setRemoteCredentials(username, password);
				}
			}
		}

		
		/**
		 * @private
		 * 注册所有的服务，解析xml文件读取Service对象并保存
		 */
		protected function register(serviceList:IServiceContainer):void {
			var accessors:XMLList = getAccessors(serviceList);
 
			for (var i:int = 0;i < accessors.length(); i++) {
				var name:String = accessors[i];
				var obj:Object = serviceList[name];
				if (isRemoteService(obj) && !services[obj]) {
					services[obj] = name;
				}
			}
		}

		/* ----------私有方法---------- */
		
		/**
		 * @private
		 * 解析对象的xml描述，返回name属性列表
		 */
		private function getAccessors(obj:Object):XMLList {
			var description:XML = describeType(obj);
			var accessors:XMLList = description.accessor.(@access == "readwrite").@name;
			return accessors;
		}

		/**
		 * @private
		 * 判断一个对象是否是远程服务对象
		 */
		private function isRemoteService(obj:Object):Boolean {
			return obj is AbstractService || obj is AbstractInvoker || obj is MessageAgent;
		}

		/**
		 * @private
		 * 得到远程服务
		 */
		private function getRemoteServiceByName(name:String):Object {
			Assert.assertNotBlank(name, "name");
			
			for (var o:Object in services) {
				if( services[o] == name ) {
					return o;
				}
			}
			return null;
		}
	}
}

/**
 * 远程服务容器
 */
interface IServiceContainer 
{
}