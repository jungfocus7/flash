package jhb0b.core
{
	import flash.display.DisplayObject;
	import flash.display.Stage;


	public class CDisplayObjectBase extends CDisplayObjectWrapper implements IStageObserver, IEnabled, INamer
	{
		public function CDisplayObjectBase(tdo:DisplayObject)
		{
			super(tdo);
		}

		protected var _stage:Stage;
		public function get_stage():Stage
		{
			return _stage;
		}		

		protected var _enabled:Boolean = false;
		public function get_enabled():Boolean
		{
			return _enabled;
		}
		public function set_enabled(b:Boolean):void
		{
			_enabled = b;
		}

		protected var _name:String;
		public function get_name():String
		{
			return _name;
		}
		public function set_name(tnm:String):void
		{
			_name = tnm;
		}
	}

}