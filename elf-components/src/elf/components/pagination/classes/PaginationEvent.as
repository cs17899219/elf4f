package elf.components.pagination.classes
{
	import flash.events.Event;

	public class PaginationEvent extends Event
	{
		public static const PAGINATION_CHANGED:String = "paginationChanged";
		
		private var _action:String;
		
		public function get action():String{
			return _action;
		}
		private var _entity:Object;
		
		public function get entity():Object{
			return _entity;
		}
		
		public function PaginationEvent(action:String,entity:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this._action = action;
			this._entity = entity;
			super(PAGINATION_CHANGED, bubbles, cancelable);//这里默认了类型
		}
		
	}
}