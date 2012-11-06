package mobi.papatong.sabelas.graphics
{
	import starling.display.Sprite;
	import starling.display.Quad;
	
	/**
	 * A dummy Starling sprite, rendering a quad
	 * @author Abiyasa
	 */
	public class DummyQuadView extends Sprite
	{
		protected var _q:Quad;
		
		/**
		 * Dummy view (a quad)
		 *
		 * @param	size The width of the quad
		 * @param	quadColors Quad colors, array of 4 colors representing the corner's colors
		 * @param	rotation Initial rotation if you want the quad to be tilted (in radian)
		 */
		public function DummyQuadView(size:int = 0, quadColors:Array = null)
		{
			super();
			
			// default size
			if (size <= 0)
			{
				size = 10;
			}
			
			// default colors
			if (quadColors == null)
			{
				quadColors = [ 0x000000, 0xAA0000, 0x00FF00, 0x0000FF ];
			}
			while (quadColors.length < 4)
			{
				// fill it with the first color
				quadColors.push(quadColors[0]);
			}
			
			// create a lovely quad
			_q = new Quad(size, size);
			_q.setVertexColor(0, quadColors[0]);
			_q.setVertexColor(1, quadColors[1]);
			_q.setVertexColor(2, quadColors[2]);
			_q.setVertexColor(3, quadColors[3]);
			addChild(_q);
			
			// adjust rotation pivot to the center
			this.pivotX = size / 2;
			this.pivotY = size / 2;
		}
		
	}
}
