package elf.components.pagination.classes
{
	public interface IPageFindDescriptor
	{
		
		/** 页码数(从1开始) 每页记录数 */
		function findPage(pageNum:int,pieceSize:int,callback:Function):void;
		
		/** 返回过度期间的对象 */
		function getInterimItem(no:int,state:String):Object;
		
		/** 远程添加一个对象 */
		function addEntity(item:Object,callback:Function):void;
		
		/** 远程修改一个对象 */
		function modifyEntity(item:Object,callback:Function):void;
		
		/** 远程删除一个对象 */
		function deleteEntity(item:Object,callback:Function):void;

	}
}