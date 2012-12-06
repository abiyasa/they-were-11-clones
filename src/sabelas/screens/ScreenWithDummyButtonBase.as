package mobi.papatong.sabelas.screens
{
	import flash.utils.Dictionary;
	import mobi.papatong.sabelas.events.ShowScreenEvent;
	import mobi.papatong.sabelas.screens.ScreenUtils;
	import starling.display.Button;
	import starling.events.Event;
	
	/**
	 * Screens with dummy buttons.
	 * Handle button click and dummy button creations
	 *
	 * @author Abiyasa
	 */
	public class ScreenWithDummyButtonBase extends ScreenBase
	{
		public static const DEBUG_TAG:String = 'ScreenWithDummyButtonBase';
		
		protected var _dummyButtons:Array = [];
		
		/** Mapping between button name and event name */
		protected var _buttonEventMap:Dictionary = new Dictionary();
		
		override protected function destroy(e:Event):void
		{
			_buttonEventMap = null;
			super.destroy(e);
		}
		
		/**
		 * Creates and add dummy buttons
		 *
		 * @param	buttonConfigs Array of button config. Each config is an
		 * Object literal with name, label, and screenEvent
		 */
		protected function createDummyButtons(buttonConfigs:Array):void
		{
			// add dummy buttons
			for each (var buttonData:Object in buttonConfigs)
			{
				var dummyButton:Button = ScreenUtils.createDummyButton(buttonData.name, buttonData.label);
				this.addChild(dummyButton);
				_dummyButtons.push(dummyButton);
				dummyButton.addEventListener(Event.TRIGGERED, onClickDummyButton);
				
				// map button event to screen changed event
				if (buttonData.hasOwnProperty('screenEvent'))
				{
					_buttonEventMap[buttonData.name] = buttonData.screenEvent;
				}
			}
		}
		
		/**
		 * Handle dummy button click
		 * @param	e
		 */
		protected function onClickDummyButton(e:Event):void
		{
			var clickedButton:Button = e.currentTarget as Button;
			if (clickedButton == null)
			{
				trace(DEBUG_TAG, 'Cannot handle non-button event', e.currentTarget);
				
				return;
			}
			
			var buttonName:String = clickedButton.name;
			trace('click button ' + buttonName);
			
			// mapping between button name and event name
			var eventName:String;
			if (_buttonEventMap.hasOwnProperty(buttonName))
			{
				eventName = _buttonEventMap[buttonName];
				
				trace(DEBUG_TAG, 'will generate event', eventName);
				
				dispatchEvent(new ShowScreenEvent(ShowScreenEvent.SHOW_SCREEN, eventName));
			}
			else  // unknown or unmapped button
			{
				trace(DEBUG_TAG, 'button is unmapped, cannot generate event');
			}
		}
	}

}
