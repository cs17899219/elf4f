package elf.components.pagination
{
	import elf.components.pagination.classes.IPageFindDescriptor;
	import elf.components.pagination.classes.Page;
	import elf.components.pagination.classes.PaginationEvent;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	[Event(name="paginationChanged", type="com.threeti.loof.components.pagination.classes.PaginationEvent")]
	
	public class PaginationModel extends EventDispatcher
	{
		public static const ACTION_ADDENTITY:String = "addEntity";
		public static const ACTION_MODIFYENTITY:String = "modifyEntity";
		public static const ACTION_DELETEENTITY:String = "deleteEntity";
		
		public static const STATUS_PROGRESSING:int = 1;
		public static const STATUS_STAND_BY:int = 2;
		
		public function PaginationModel(pageFindDescriptor:IPageFindDescriptor){
			this._pageFindDescriptor = pageFindDescriptor;
		}
		
		private var _pageFindDescriptor:IPageFindDescriptor;
		
		[Bindable]
		public function get pageFindDescriptor():IPageFindDescriptor{
			return _pageFindDescriptor;
		}
		
		public function set pageFindDescriptor(value:IPageFindDescriptor):void{
			_pageFindDescriptor = value;
		}
		
		private var _dataSource:ArrayCollection = new ArrayCollection;
		
		[Bindable]
		public function get dataSource():ArrayCollection{
			return _dataSource;
		}
		
		private function set dataSource(value:ArrayCollection):void{
			_dataSource = value;
		}
		
		[Bindable]
		/** 表示当前集合的状态 */
		public var status:int = STATUS_STAND_BY;
		
		[Bindable]
		/** 总记录数 */
		public var totalCount:int;
		
		[Bindable]
		/** 当前是第几页 */
		public var currentPageNo:int;
		
		[Bindable]
		/** 每页记录数 */
		public var pieceSize:int = 20;
		
		[Bindable]
		/** 总页数 */
		public var pageCount:int;
		
		/**
		 * 翻到下一页，如果不存在下一页就停留在当前页
		 * @return 否存在下一页返回True
		 */
		public function nextPage():Boolean{
			if(currentPageNo < pageCount){
				currentPageNo++;
				_pageFindDescriptor.findPage(currentPageNo,pieceSize,onDataUpdated);
			}
			return currentPageNo < pageCount;
		}
		
		/**
		 * 翻到上一页，如果不存在上一页就停留在当前页
		 * @return 否存在上一页返回True
		 */
		public function previousPage():Boolean{
			if(currentPageNo > 1){
				currentPageNo--;
				_pageFindDescriptor.findPage(currentPageNo,pieceSize,onDataUpdated);
			}
			return currentPageNo > 1;
		}
		
		public function firstPage():void{
			_pageFindDescriptor.findPage(1,pieceSize,onDataUpdated);
		}
		
		public function lastPage():void{
			_pageFindDescriptor.findPage(pageCount,pieceSize,onDataUpdated);
		}
		
		public function addEntity(item:Object):void{
			_pageFindDescriptor.addEntity(item,onAdd);
		}
		
		public function modifyEntity(item:Object):void{
			_pageFindDescriptor.modifyEntity(item,onModify);
		}
		
		public function deleteEntity(item:Object):void{
			_pageFindDescriptor.deleteEntity(item,onDelete);
		}
		
		public function refresh():void{
			_pageFindDescriptor.findPage(currentPageNo,pieceSize,onDataUpdated);
		}
		
		private function onAdd(item:Object):void{
			_pageFindDescriptor.findPage(currentPageNo,pieceSize,onDataUpdated);
			this.dispatchEvent(new PaginationEvent(ACTION_ADDENTITY,item));
		}
		
		private function onModify(item:Object):void{
			_pageFindDescriptor.findPage(currentPageNo,pieceSize,onDataUpdated);
			this.dispatchEvent(new PaginationEvent(ACTION_MODIFYENTITY,item));
		}
		
		private function onDelete(item:Object):void{
			_pageFindDescriptor.findPage(currentPageNo,pieceSize,onDataUpdated);
			this.dispatchEvent(new PaginationEvent(ACTION_DELETEENTITY,item));
		}
		
		private function onDataUpdated(ps:Page):void{
			this.currentPageNo = (ps.totalCount!=0)?(ps.first/ps.pageSize+1):0;
			this.totalCount = ps.totalCount;
			this.pageCount = this.totalCount/this.pieceSize + (this.totalCount%this.pieceSize==0?0:1);
			this._dataSource.source = ps.data.source;
		}

	}
}