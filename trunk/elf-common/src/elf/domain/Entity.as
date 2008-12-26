package elf.domain
{	

	[RemoteClass(alias="com.threeti.loof.domain.BaseEntity")]

	[Bindable]

	/**
	 * 实体模型的基类
	 */
	public class Entity 
	{
		public var id:Number;	

		public function equals(item:Object):Boolean {
			if (item == null) return false;
			if (!(item is Entity)) return false;
			var object:Entity = Entity(item);
			if (object.id != this.id) {
				return false;
			}
			return true;
		}
	}
}