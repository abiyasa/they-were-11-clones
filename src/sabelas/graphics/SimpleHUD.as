package sabelas.graphics
{
	import sabelas.components.GameState;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * A simple HUD displaying necessary game info from
	 * the given game state
	 *
	 * @author Abiyasa
	 */
	public class SimpleHUD extends Sprite
	{
		private var _background:Quad;

		private var _labelScore:TextField;
		private var _labelClone:TextField;
		
		private var _gameState:GameState;
		private var _textureAtlas:TextureAtlas;
		
		private var _iconClone:Image;
		
		/** Map display for enemies & deposit points */
		private var _mapDisplay:Sprite;
		public function get mapDisplay():Sprite { return _mapDisplay; }
		
		/**
		 * Create a simple HUD
		 *
		 * @param	gameState The gamestate which will be displayed
		 * @param	textureAtlas Shared texture atlas which contains additional icon
		 */
		public function SimpleHUD(gameState:GameState, textureAtlas:TextureAtlas)
		{
			super();
			
			_gameState = gameState;
			
			_background = new Quad(100, 30, 0xffffff);
			_background.alpha = 0.4;
			addChild(_background);
			
			// label for score
			_labelScore = new TextField(400, 100, '', 'Ubuntu', 36, 0x009eef, true);
			_labelScore.hAlign = HAlign.LEFT;
			_labelScore.vAlign = VAlign.TOP;
			_labelScore.x = 110;
			_labelScore.y = 5;
			addChild(_labelScore);
			
			// init map
			_mapDisplay = new Sprite();
			_mapDisplay.x = 5;
			_mapDisplay.y = 5;
			addChild(_mapDisplay);
			
			// get icon from the texture atlas
			_textureAtlas = textureAtlas;
			if (_textureAtlas != null)
			{
				var texture:Texture = _textureAtlas.getTexture('icon_clone');
				if (texture != null)
				{
					_iconClone = new Image(texture);
					_iconClone.x = 400;
					_iconClone.y = 5;
					
					addChild(_iconClone);
				}
			}
			
			// show label for clone
			_labelClone = new TextField(100, 100, 'Clone', 'Ubuntu', 36, 0x009eef, true);
			_labelClone.hAlign = HAlign.LEFT;
			_labelClone.vAlign = VAlign.TOP;
			_labelClone.x = 425;
			_labelClone.y = 5;
			addChild(_labelClone);
			
			updateLabels();
		}
		
		private function updateLabels():void
		{
			var scoreString:String = _gameState.score.toString();
			while (scoreString.length < 6)
			{
				scoreString = '0' + scoreString;
			}
			_labelScore.text = scoreString;
			
			_labelClone.text = 'x' + _gameState.numOfClones;
		}
		
		public function update(time:Number):void
		{
			updateLabels();
		}
	}

}
