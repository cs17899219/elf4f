package elf.commands
{
	import elf.events.ElfEvent;
	
	import mx.rpc.IResponder;	

	[ExcludeClass]

	public interface IRemoteCommand extends ICommand,IResponder 
	{
		function set resultFunction(value:Function):void;

		function set faultFunction(value:Function):void;

		function set nextEvent(value:ElfEvent):void;

		function set stopTransferOnFault(value:Boolean):void;

		/**
		 *  This method is called by a service when the return value
		 *  has been received. 
		 *  While <code>data</code> is typed as Object, it is often
		 *  (but not always) an mx.rpc.events.ResultEvent.
		 */
		function onResult(data:Object):void;

		/**
		 *  This method is called by a service when an error has been received.
		 *  While <code>info</code> is typed as Object it is often
		 *  (but not always) an mx.rpc.events.FaultEvent.
		 */
		function onFault(info:Object):void;
	}
}