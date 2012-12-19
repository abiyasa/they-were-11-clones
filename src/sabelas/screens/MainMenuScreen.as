package sabelas.screens
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import sabelas.configs.ScreenConfig;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	/**
	 * The main menu screen/View/Scene
	 * @author Abiyasa
	 */
	public class MainMenuScreen extends ScreenWithButtonBase
	{
		public static const DEBUG_TAG:String = 'MainMenuScreen';
		
		private var _bgScreen:Sprite;
		
		public function MainMenuScreen()
		{
			super();
			
			// bg image
			_bgScreen = new Sprite();
			var bgImage:Quad = new Quad(640, 480);
			_bgScreen.addChild(bgImage);
			
			// logo
			var logo:Image = new Image(_textureAtlas.getTexture('title'));
			logo.readjustSize();
			logo.x = (640 - 512) / 2;
			logo.y = 10;
			_bgScreen.addChild(logo);
			
			//_bgScreen.flatten();
			this.addChild(_bgScreen);
			
			this.createButtons([
				{
					name: 'start',
					textureName: 'button_start',
					x: (640 - 171 - 5) / 2,
					y: 10 + 373 + 5,
					screenEvent: ScreenConfig.SCREEN_PLAY_GAME
				},
				{
					name: 'config',
					textureName: 'button_about_small',
					x: 640 - 41 - 5,
					y: 480 - 41 - 5,
					screenEvent: ScreenConfig.SCREEN_CONFIG
				}
			]);
		}
		
		override protected function init(e:Event):void
		{
			super.init(e);
			
			// add keyboard shortcut
			this.stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyboard);
		}
		
		override protected function destroy(e:Event):void
		{
			trace(DEBUG_TAG, 'destroy()');
			
			this.removeChild(_bgScreen, true);
			_textureAtlas.dispose();
			
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyboard);
			
			super.destroy(e);
		}
		
		// Handles keyboard shortcut
		protected function handleKeyboard(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
			case Keyboard.ENTER:
				triggerButton('start');
				break;
			}
		}
	}
}
