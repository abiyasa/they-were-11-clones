package mobi.papatong.sabelas.screens
{
	import flash.utils.Dictionary;
	import mobi.papatong.sabelas.events.ShowScreenEvent;
	import starling.display.Button;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	/**
	 * Screens with buttons.
	 * Handle button click and dummy button creations
	 *
	 * @author Abiyasa
	 */
	public class ScreenWithButtonBase extends ScreenBase
	{
		public static const DEBUG_TAG:String = 'ScreenWithButtonBase';
		
		protected var _buttons:Array = [];
		
		/** Mapping between button name and event name */
		protected var _buttonEventMap:Dictionary = new Dictionary();
		
		override protected function destroy(e:Event):void
		{
			_buttonEventMap = null;
			super.destroy(e);
		}
		
		/**
		 * Creates and add buttons
		 *
		 * @param	textureAtlas
		 * @param	buttonConfigs Array of button config. Each config is an
		 * Object literal with name, texture name, and screenEvent
		 */
		protected function createButtons(textureAtlas:TextureAtlas, buttonConfigs:Array):void
		{
			// add dummy buttons
			var theButton:Button;
			for each (var buttonData:Object in buttonConfigs)
			{
				theButton = new Button(textureAtlas.getTexture(buttonData.textureName));
				theButton.name = buttonData.name;
				theButton.x = buttonData.x;
				theButton.y = buttonData.y;
				this.addChild(theButton);
				_buttons.push(theButton);
				theButton.addEventListener(Event.TRIGGERED, onClickButton);
				
				// map button event to screen changed event
				if (buttonData.hasOwnProperty('screenEvent'))
				{
					_buttonEventMap[buttonData.name] = buttonData.screenEvent;
				}
			}
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
				dummyButton.x = buttonData.x;
				dummyButton.y = buttonData.y;
				this.addChild(dummyButton);
				_buttons.push(dummyButton);
				dummyButton.addEventListener(Event.TRIGGERED, onClickButton);
				
				// map button event to screen changed event
				if (buttonData.hasOwnProperty('screenEvent'))
				{
					_buttonEventMap[buttonData.name] = buttonData.screenEvent;
				}
			}
		}
		
		/**
		 * Handle button click
		 * @param	e
		 */
		protected function onClickButton(e:Event):void
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
		
		/**
		 * Trigger event on a specfied button
		 * @param	buttonName
		 */
		protected function triggerButton(buttonName:String):void
		{
			// find buttons on array
			var willTriggerButtons:Array = [];
			var button:Button;
			for each (button in _buttons)
			{
				if (button.name == buttonName)
				{
					willTriggerButtons.push(button);
					
					trace(DEBUG_TAG, 'found button with name=' + buttonName);
				}
			}
			
			// trigger buttons
			for each (button in willTriggerButtons)
			{
				button.dispatchEvent(new Event(Event.TRIGGERED));
			}
		}
	}

}
