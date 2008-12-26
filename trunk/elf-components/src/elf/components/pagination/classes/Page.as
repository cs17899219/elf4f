package elf.components.pagination.classes
{
import mx.collections.ArrayCollection;

[RemoteClass(alias="com.threeti.loof.dao.support.Page")]

[Bindable]
public class Page
{
	/** 页码 从1开始 */
	public var first:Number;
	
	/** 实际的总记录数 */
	public var totalCount:Number;
	
	public var pageSize:int;
	
	/** 当前页的数据 */
	public var data:ArrayCollection;

	public static function convertFromPageToStartIndex(pageNo:int, pageSize:int):int {
		return (pageNo-1) * pageSize;
	}
}
}