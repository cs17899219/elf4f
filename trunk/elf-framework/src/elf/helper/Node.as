package elf.helper
{

	[ExcludeClass]

	/**
	 * 树形节点
	 */
	public class Node 
	{
		public function Node() {
			_children = new Array;
			_parent = null;
		}

		private var _children:Array;

		private var _parent:Node;

		public function get parent():Node {
			return _parent;
		}

		public function get children():Array {
			return _children;
		}

		public function addChild(node:Node):Node {
			_children.push(node);
			node._parent = this;
			return node;
		}

		public function removeChild(node:Node):Node {
			node._parent = null;
			for (var i:int ;i < _children.length; i++) {
				if(_children[i] == node)
					_children.splice(i, 1);
			}
			return node;
		}
	}
}