package elf.util
{

	[Bindable]

	public class Stack 
	{
		private var items:Array;

		public function Stack(items:Array = null ) {
			this.items = items;
			if ( this.items == null ) {
				this.items = new Array();
			}
			length = this.items.length;
		}

		public function offer(o:Object):Boolean {
			if ( this.items == null ) {
				this.items = new Array();
			}
					
			this.items.push(o);
			length = this.items.length;
			return true;
		}

		public function poll():Object {
			var resultObj:Object = null;
			if (this.items != null && this.items.length > 0) {
				resultObj = this.items[items.length];    		    
				items = items.slice(0, items.length - 1);
			}
			return resultObj;
		}

		/**
		 * 从队列中取出head,但是不移除
		 * 
		 */
		public function peek():Object {
			if (this.items != null && this.items.length > 0) {
				return this.items[this.items.length - 1];	
			}
			return null;
		}

		public function remove(obj:Object):void {
			var tempArray:Array = new Array();
			for each (var item:Object in this.items) {
				if (item != obj) {
					tempArray.push(item);
				}
			}
			items = tempArray;
			length = items.length;
		}

		
		public function nextItem(curObj:Object):Object {
			for(var i:int = items.length - 1;i >= 0;i--) {
				var item:Object = this.items[i];
				if (item == curObj && i > 0) {
					return items[i - 1]; 
				}
			}
			return null;
		}

		public function lastItem(curObj:Object):Object {
			for(var i:int = 0;i < this.items.length;i++) {
				var item:Object = this.items[i];
				if (item == curObj && i != items.length - 1) {
					return items[i + 1];
				}
			}
			return null;    		
		}

		public var length:int;
	}
}