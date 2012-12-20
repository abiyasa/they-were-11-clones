package sabelas.graphics
{
	import sabelas.components.GameState;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.BitmapFont;
	import starling.text.TextField;
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
		private var _textField:TextField;
		
		private var _gameState:GameState;
		
		public function SimpleHUD(gameState:GameState)
		{
			super();
			
			_gameState = gameState;
			
			_background = new Quad(100, 30, 0xffffff);
			_background.alpha = 0.4;
			_textField = new TextField(96, 26, '', BitmapFont.MINI, 12, 0x009eef);
			_textField.x = 2;
			_textField.y = 2;
			_textField.hAlign = HAlign.LEFT;
			_textField.vAlign = VAlign.TOP;
			
			addChild(_background);
			addChild(_textField);
			
			updateText();
		}
		
		private function updateText():void
		{
			var displayString:String = "clones=" + _gameState.numOfClones +
				" Energy=" + _gameState.energy +
				" Score=" + _gameState.score;
			_textField.text = displayString;
		}
		
		public function update(time:Number):void
		{
			updateText();
		}
	}

}
