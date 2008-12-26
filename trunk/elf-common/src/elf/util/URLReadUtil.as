package elf.util
{
	import mx.core.Application;
	import mx.utils.URLUtil;	

	public class URLReadUtil 
	{
		public static function getRemoteUrl(contentPath:String):String {
			var fullUrl:String = Application(Application.application).url;
			var port:uint = URLUtil.getPort(fullUrl);
			var serverName:String = URLUtil.getServerName(fullUrl);
			var protocol:String = URLUtil.getProtocol(fullUrl);
			var result:String = protocol + "://" + serverName + ":" + port;
			if (contentPath != null) {
				result = result.concat(contentPath);
			}
			result = result.concat("/");
			return result;
		}

		public static function getContextName(url:String):String {
			url = url.substring(url.indexOf("//") + 2);
			url = url.substring(url.indexOf("/") + 1);
			return url.substring(0, url.indexOf("/"));
		}

		/**
		 *  得到远程服务的根路径
		 */
		public static function getAppRemoteRootPath():String {
			var fullUrl:String = Application(Application.application).url;
			var port:uint = URLUtil.getPort(fullUrl);
			var serverName:String = URLUtil.getServerName(fullUrl);
			var protocol:String = URLUtil.getProtocol(fullUrl);
			var result:String = protocol + "://" + serverName ;
			if(port != 0 ) {
				result = result.concat(":", port);
			}
			var contentPath:String = getContextName(fullUrl);
			if (contentPath != null && fullUrl.length > 0) {
				result = result.concat("/");
				result = result.concat(contentPath);
			}
			result = result.concat("/");
			return result;
		}

		public static function getcontentPath():String {
			var fullUrl:String = Application(Application.application).url;
			return getContextName(fullUrl);
		}
	}
}