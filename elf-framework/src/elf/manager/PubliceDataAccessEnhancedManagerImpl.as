package elf.manager
{
	import elf.core.IPubliceDataAccessEnhancedManager;
	import elf.helper.IDataUnitDescriptor;
	import elf.util.Assert;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;	

	[ExcludeClass]

	/**
	 * 公共数据访问管理器
	 * @see com.threeti.loof.core.IPubliceDataAccessEnhancedManager
	 */
	public class PubliceDataAccessEnhancedManagerImpl implements IPubliceDataAccessEnhancedManager
	{
		/** 数据单元 Dictionary */
		private var dataUnitDic:Dictionary = new Dictionary(true);

		/** 订阅数据单元 */
		public function subscribeDataUnit(topic:String, subscriber:ArrayCollection, descriptor:IDataUnitDescriptor = null):Boolean {
			Assert.assertNotBlank(topic, "topic");
			Assert.assertNotNull(subscriber, "subscriber");
			
			if(this.hasDataUnit(topic)) {
				//如果有
				var sdu:SubscribableDataUnit = getDataUnitByName(topic);
				sdu.addSubscriber(subscriber);
				return true;
			}else {
				//如果没有
				return false;
			}
		}

		/** 是否存在数据单元 */
		public function hasDataUnit(topic:String):Boolean {
			Assert.assertNotBlank(topic, "topic");
			
			return this.getDataUnitByName(topic) != null;
		}

		/** 添加数据单元(不允许重复) */
		public function addDataUnit(topic:String, host:ArrayCollection):void {
			Assert.assertNotBlank(topic, "topic");
			Assert.assertNotNull(host, "host");
			
			if(this.hasDataUnit(topic)) {
				throw new Error('the topic of DataUnit is exist.');
			}
			
			if( dataUnitDic[host] == null ) {
				var sdu:SubscribableDataUnit = new SubscribableDataUnit(topic);
				sdu.host = host;
				dataUnitDic[host] = sdu;
			}else {
				throw new Error('the ArrayCollection of DataUnit is exist.');
			}
		}

		public function removeDataUnit(topic:String):Boolean {
			Assert.assertNotBlank(topic, "topic");
			
			for ( var o:Object in dataUnitDic ) {
				var sdu:SubscribableDataUnit = SubscribableDataUnit(dataUnitDic[o]);
				if(sdu.name == topic) {
					dataUnitDic[o] = null;
					delete dataUnitDic[o];
					return true;
				}
			}
			return false;
		}

		private function getDataUnitByName(topic:String):SubscribableDataUnit {
			Assert.assertNotBlank(topic, "topic");
			
			for ( var o:Object in dataUnitDic ) {
				var sdu:SubscribableDataUnit = SubscribableDataUnit(dataUnitDic[o]);
				if(sdu.name == topic) {
					return sdu;
				}
			}
			return null;
		}
	}
}

import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.events.CollectionEvent;

class SubscribableDataUnit 
{
	private var _subscribers:Dictionary;

	private var _host:ArrayCollection;

	public function set host(value:ArrayCollection):void {
		if(_host) {
			_host.removeEventListener(CollectionEvent.COLLECTION_CHANGE, updateSubscribers);
		}
		this._host = value;
		this._host.addEventListener(CollectionEvent.COLLECTION_CHANGE, updateSubscribers, false, 0, true);
	}

	private var _name:String;

	public function get name():String {
		return _name;
	}

	public function SubscribableDataUnit(name:String) {
		this._subscribers = new Dictionary(true);
		this._name = name;
	}

	public function addSubscriber(subscriber:ArrayCollection):void {
		if (!this.containsSubscriber(subscriber)) {
			_subscribers[subscriber] = true;
			if(_host) {
				subscriber.source = _host.source;
			}
		}
	}

	public function containsSubscriber(subscriber:ArrayCollection):Boolean {
		for (var obj:Object in _subscribers) {
			if( obj == subscriber ) return true;
		}
		return false;
	}

	private function updateSubscribers(e:CollectionEvent):void {
		for (var obj:Object in _subscribers) {
			ArrayCollection(obj).source = _host.source;
		}
	}
}
