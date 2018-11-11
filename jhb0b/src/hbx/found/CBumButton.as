package hbx.found
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    import hbx.core.CEventCore;
    import hbx.core.CMovieClipWrapper;
    import hbx.core.ISelected;



    public class CBumButton extends CMovieClipWrapper implements ISelected
    {

		public static const ET_ROLL_OUT:String = MouseEvent.ROLL_OUT;
		public static const ET_ROLL_OVER:String = MouseEvent.ROLL_OVER;
		public static const ET_MOUSE_UP:String = MouseEvent.MOUSE_UP;
		public static const ET_MOUSE_DOWN:String = MouseEvent.MOUSE_DOWN;
		public static const ET_CLICK:String = MouseEvent.CLICK;


        public function CBumButton(tmvc:MovieClip, frameArr:Array = null,
							isToggleMode:Boolean = false, isListMode:Boolean = false)
        {
            super(tmvc);
            _mvc.gotoAndStop(1);
			_frameArr = (frameArr == null) ? _DefaultFrameArr : frameArr;
			_isToggleMode = isToggleMode;
			_isListMode = isListMode;
			set_enabled(true);
        }


		private static const _DefaultFrameArr:Array = ['#01', '#02', '#03', '#04', '#05', '#06'];
		private var _frameArr:Array;
		private var _isToggleMode:Boolean;
		private var _isListMode:Boolean;

		private var _originIdx:uint = 0;
		private static const _MOutIdx:uint = 0;
		private static const _MOverIdx:uint = 1;
		private static const _MDownIdx:uint = 2;
		private var _nowIdx:uint = _MOutIdx;
		private var _isMouseDown:Boolean = false;
		private var _selected:Boolean = false;


		public override function set_enabled(b:Boolean):void
		{
			if (b != _enabled)
			{
				_enabled = b;
				if (_enabled)
				{
					_mvc.mouseChildren = false;
					_mvc.buttonMode = true;
					_mvc.addEventListener(MouseEvent.ROLL_OVER, p_moodc);
					_mvc.addEventListener(MouseEvent.ROLL_OUT, p_moodc);
					_mvc.addEventListener(MouseEvent.MOUSE_DOWN, p_moodc);
					_mvc.addEventListener(MouseEvent.MOUSE_UP, p_moodc);
					_mvc.addEventListener(MouseEvent.CLICK, p_moodc);
				}
				else
				{
					_mvc.mouseChildren = true;
					_mvc.buttonMode = false;
					_mvc.removeEventListener(MouseEvent.ROLL_OVER, p_moodc);
					_mvc.removeEventListener(MouseEvent.ROLL_OUT, p_moodc);
					_mvc.removeEventListener(MouseEvent.MOUSE_DOWN, p_moodc);
					_mvc.removeEventListener(MouseEvent.MOUSE_UP, p_moodc);
					_mvc.removeEventListener(MouseEvent.CLICK, p_moodc);
				}
			}
		}

		private function p_moodc(evt:MouseEvent):void
		{
			switch (evt.type)
			{
				case MouseEvent.ROLL_OUT:
					_nowIdx = _MOutIdx;
					p_frameUpdate();
					break;

				case MouseEvent.ROLL_OVER:
					if (_isMouseDown)
						_nowIdx = _MDownIdx;
					else
						_nowIdx = _MOverIdx;
					p_frameUpdate();
					break;

				case MouseEvent.MOUSE_DOWN:
					_nowIdx = _MDownIdx;
					p_frameUpdate();
					_isMouseDown = true;
					_stage.addEventListener(MouseEvent.MOUSE_UP, p_stage_mu);
					break;

				case MouseEvent.CLICK:
					_nowIdx = _MOverIdx;
					if (_isListMode)
						p_frameUpdate();
					else
					{
						if (_isToggleMode)
							p_set_selected(!_selected);
						else
							p_frameUpdate();
					}
					break;
			}
			evt.updateAfterEvent();

			this.dispatchEvent(new CEventCore(evt.type));
		}

		private function p_frameUpdate():void
		{
			var t_idx:uint = _originIdx + _nowIdx;
			var t_fl:String = _frameArr[t_idx];
			try
			{
				_mvc.gotoAndStop(t_fl);
			}
			catch (e:Error) {}
		}

		private function p_stage_mu(evt:MouseEvent):void
		{
			if (_isMouseDown)
			{
				_isMouseDown = false;
				_stage.removeEventListener(MouseEvent.MOUSE_UP, p_stage_mu);
			}
		}

		private function p_set_selected(b:Boolean, be:Boolean = false):void
		{
			if (_isToggleMode)
			{
				if (b != _selected)
				{
					_selected = b;
					if (_selected)
						_originIdx = 3;
					else
						_originIdx = 0;
					p_frameUpdate();

					if (be)
						this.dispatchEvent(new CEventCore(ET_CLICK));
				}
			}
		}


		public function get_selected():Boolean
		{
			if (_isToggleMode)
				return _selected;
			else
				return false;
		}

		public function set_selected(b:Boolean):void
		{
			p_set_selected(b);
		}

		public function set_selectedDispatch(b:Boolean):void
		{
			p_set_selected(b, true);
		}


    }
}