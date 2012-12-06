package sabelas.input
{
	/**
	 * KeyPoll which stores the last keyboard key states.
	 * Works with Starling
	 *
	 * Original code from Richard Lord's Ash framework with
	 * a little modification from me.
	 *
	 * @author Abiyasa
	 */
	public class KeyPoll
	{
		import flash.utils.ByteArray;
		import starling.display.DisplayObject;
		import starling.events.KeyboardEvent;

		private var _keyStates:ByteArray;
		private var _displayObject:DisplayObject;
		
		public function KeyPoll(displayObject:DisplayObject)
		{
			_keyStates = new ByteArray();
			_keyStates.writeUnsignedInt(0);
			_keyStates.writeUnsignedInt(0);
			_keyStates.writeUnsignedInt(0);
			_keyStates.writeUnsignedInt(0);
			_keyStates.writeUnsignedInt(0);
			_keyStates.writeUnsignedInt(0);
			_keyStates.writeUnsignedInt(0);
			_keyStates.writeUnsignedInt(0);
			
			_displayObject = displayObject;
			_displayObject.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			_displayObject.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		}
		
		public function destroy():void
		{
			_displayObject.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			_displayObject.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		}
		
		private function keyDownListener(ev:KeyboardEvent):void
		{
			_keyStates[ev.keyCode >>> 3] |= 1 << (ev.keyCode & 7);
		}
		
		private function keyUpListener(ev:KeyboardEvent):void
		{
			_keyStates[ev.keyCode >>> 3] &= ~(1 << (ev.keyCode & 7));
		}
		
		public function reset():void
		{
			for(var i:int = 0; i < 8; ++i)
			{
				_keyStates[i] = 0;
			}
		}
		
		/**
		 * To test whether a key is down.
		 *
		 * @param keyCode code for the key to test.
		 *
		 * @return true if the key is down, false otherwise.
		 *
		 * @see isUp
		 */
		public function isDown(keyCode:uint):Boolean
		{
			return (_keyStates[keyCode >>> 3] & (1 << (keyCode & 7))) != 0;
		}
		
		/**
		 * To test whetrher a key is up.
		 *
		 * @param keyCode code for the key to test.
		 *
		 * @return true if the key is up, false otherwise.
		 *
		 * @see isDown
		 */
		public function isUp(keyCode:uint):Boolean
		{
			return (_keyStates[keyCode >>> 3] & (1 << (keyCode & 7))) == 0;
		}
		
	}

}