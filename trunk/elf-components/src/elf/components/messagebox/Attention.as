package elf.components.messagebox
{
	import flash.display.Sprite;
	
	import mx.controls.Alert;
	
	public class Attention
	{

		[Bindable]
        [Embed(source="image/error.png")]
        public static var errorIcon:Class;
        
        [Bindable]
        [Embed(source="image/warning.png")]
        public static var warnIcon:Class;
        
        [Bindable]
        [Embed(source="image/hint.png")]
        public static var  messageIcon:Class;
        
		public static function error(text:String = "", title:String = "",
                                flags:uint = 0x4 /* Alert.OK */, 
                                parent:Sprite = null, 
                                closeHandler:Function = null, 
                                iconClass:Class = null, 
                                defaultButtonFlag:uint = 0x4 /* Alert.OK */):void{
            Alert.okLabel="确定";
            Alert.yesLabel="确定";
            Alert.noLabel="取消";
            Alert.cancelLabel="取消";                    	
			Alert.show(text,"错误",flags,parent,closeHandler,errorIcon,defaultButtonFlag);
		}
		public static function warn(text:String = "", title:String = "",
                                flags:uint = 0x4 /* Alert.OK */, 
                                parent:Sprite = null, 
                                closeHandler:Function = null, 
                                iconClass:Class = null, 
                                defaultButtonFlag:uint = 0x4 /* Alert.OK */):void{
            Alert.okLabel="确定";
            Alert.yesLabel="确定";
            Alert.noLabel="取消";
            Alert.cancelLabel="取消";                     	
			Alert.show(text,"警告",flags,parent,closeHandler,warnIcon,defaultButtonFlag);
		}
		
		
		public static function message(text:String = "", title:String = "",
                                flags:uint = 0x4 /* Alert.OK */, 
                                parent:Sprite = null, 
                                closeHandler:Function = null, 
                                iconClass:Class = null, 
                                defaultButtonFlag:uint = 0x4 /* Alert.OK */):void{
            Alert.okLabel="确定";
            Alert.yesLabel="确定";
            Alert.noLabel="取消";
            Alert.cancelLabel="取消";                      	
			Alert.show(text,"消息",flags,parent,closeHandler,messageIcon,defaultButtonFlag);
		}
	}
}