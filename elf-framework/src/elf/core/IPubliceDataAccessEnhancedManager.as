package elf.core
{
	import elf.helper.IDataUnitDescriptor;
	
	import mx.collections.ArrayCollection;	

	/**
	 *  公共数据访问管理器
	 */
	public interface IPubliceDataAccessEnhancedManager 
	{
		/** 订阅数据单元(如果不存在返回false) */
		function subscribeDataUnit(topic:String, subscriber:ArrayCollection, descriptor:IDataUnitDescriptor = null):Boolean;

		/** 是否存在数据单元 */
		function hasDataUnit(topic:String):Boolean;

		/** 添加数据单元(不允许重复) */
		function addDataUnit(topic:String, dataunit:ArrayCollection):void;

		/** 移除数据单元(如果成功移除返回true,如果不存在该数据单元返回false) */
		function removeDataUnit(topic:String):Boolean;
	}
}