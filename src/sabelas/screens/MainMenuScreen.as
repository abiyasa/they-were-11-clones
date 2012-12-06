package mobi.papatong.sabelas.screens
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import mobi.papatong.sabelas.configs.ScreenConfig;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * The main menu screen/View/Scene
	 * @author Abiyasa
	 */
	public class MainMenuScreen extends ScreenWithButtonBase
	{
		public static const DEBUG_TAG:String = 'MainMenuScreen';
		
		[Embed(source="../../../../../assets/menuAtlas.png")]
		private static const AtlasTexture:Class;

		[Embed(source="../../../../../assets/menuAtlas.xml", mimeType="application/octet-stream")]
		private static const AtlasXML:Class;
		
		private var _textureAtlas:TextureAtlas;
		
		private var _bgScreen:Sprite;
		
		public function MainMenuScreen()
		{
			super();
			
			// init texture atlas
			var atlasTexture:Texture = Texture.fromBitmap(new AtlasTexture());
			_textureAtlas = new TextureAtlas(atlasTexture, XML(new AtlasXML()));

			// bg image
			_bgScreen = new Sprite();
			var bgImage:Image = new Image(_textureAtlas.getTexture('bg'));
			_bgScreen.addChild(bgImage);
			
			// logo
			var logo:Image = new Image(_textureAtlas.getTexture('title'));
			logo.readjustSize();
			logo.x = 125;
			logo.y = 106;
			_bgScreen.addChild(logo);
			
			_bgScreen.flatten();
			this.addChild(_bgScreen);
			
			this.createButtons(_textureAtlas, [
				{
					name: 'start',
					textureName: 'button_start',
					x: 175,
					y: 310,
					screenEvent: ScreenConfig.SCREEN_PLAY_GAME
				},
				{
					name: 'config',
					textureName: 'button_about',
					x: 329,
					y: 310,
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
