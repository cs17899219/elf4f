package events
{
	import elf.events.ElfEvent;

	public class SomeEvent extends ElfEvent
	{
		public static const SOME_EVENT:String = "some_event";
		
		public function SomeEvent(type : String){
			super(type);
		}
	}
}