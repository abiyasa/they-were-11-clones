package sabelas.graphics
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.WireframeCube;
	import away3d.textures.BitmapTexture;
	import away3d.textures.CubeTextureBase;
	import flash.display.BitmapData;
	
	/**
	 * Blocky game character
	 * @author Abiyasa
	 */
	public class BlockyPeople extends ObjectContainer3D
	{
		private var _width:int;
		private var _height:int;
		private var _depth:int;
		
		/**
		 * Create a blocky people. Currently, only solid color supported.
		 * Textured and multiple parts are planned.
		 *
		 * @param	width width in centimeter (X-axis)
		 * @param	height height in centimeer (Y-axis)
		 * @param	depth depth centimeter (Z-axis)
		 * @param	color block plain color
		 */
		public function BlockyPeople(width:int, height:int, depth:int, color:uint)
		{
			super();

			_width = width;
			_height = height;
			_depth = depth;
			
			// create material
			var cubeBitmapData:BitmapData = new BitmapData(128, 128, false, color);
			cubeBitmapData.noise(443, 80, 128, 7, true);
			var cubeMaterial:TextureMaterial = new TextureMaterial(new BitmapTexture(cubeBitmapData));
			cubeMaterial.gloss = 20;
			cubeMaterial.ambientColor = color;
			cubeMaterial.ambient = 1;
			var cubeMesh:Mesh = new Mesh(new CubeGeometry(_width, _height, _depth), cubeMaterial)
			this.addChild(cubeMesh);
			
			// readjust cube position, origin will be on the center-bottom
			cubeMesh.y = _height;
		}
		
	}

}
