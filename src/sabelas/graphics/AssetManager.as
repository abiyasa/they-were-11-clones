package sabelas.graphics
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.loaders.parsers.OBJParser;
	import away3d.events.LoaderEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	
	/**
	 * Factory and manager 3D assets.
	 * Creating 3D characters and objects
	 *
	 * @author Abiyasa
	 */
	public class AssetManager extends EventDispatcher
	{
		public static const DEBUG_TAG:String = "AssetManager";
		
		[Embed(source="../../../assets/blocky_texture.png")]
		private static const BlockyTexture:Class;

		[Embed(source="../../../assets/blocky.obj", mimeType="application/octet-stream")]
		private static const BlockyMesh:Class;
		
		private var _blockyTextures:Array = [];
		
		private var _blockyMesh:Mesh;
		
		private var _assetLoader:Loader3D;
		
		[Embed(source="../../../assets/arena_texture.png")]
		private static const ArenaTexture:Class;
		
		public function AssetManager()
		{
			super();
			Loader3D.enableParser(OBJParser);
		}
		
		/**
		 * Inits the textures and other assets.
		 * Will dispatch event Event.COMPLETE when done
		 */
		public function init(options:Object = null):void
		{
			// create bitmap texture
			var textureBitmapData:BitmapData = Bitmap(new BlockyTexture()).bitmapData;
			var bitmapTexture:BitmapTexture = new BitmapTexture(textureBitmapData);
			
			// create textures
			_blockyTextures = [];
			var tempTexture:TextureMaterial;
			tempTexture = new TextureMaterial(bitmapTexture);
			_blockyTextures[0] = tempTexture;
			
			tempTexture = new TextureMaterial(bitmapTexture);
			tempTexture.colorTransform = new ColorTransform(0.5, 0.5, 0.5, 1, 0x80, 0x80, 0x80, 0);
			_blockyTextures[1] = tempTexture;
			
			tempTexture = new TextureMaterial(bitmapTexture);
			tempTexture.colorTransform = new ColorTransform(0, 1, 1, 1, 255, 0, 0, 0);
			_blockyTextures[2] = tempTexture;
			
			loadMesh();
		}
		
		public function destroy():void
		{
			if (_blockyMesh != null)
			{
				_blockyMesh.dispose();
				_blockyMesh = null;
			}
			
			var temp:MaterialBase;
			while (_blockyTextures.length > 0)
			{
				temp = _blockyTextures.pop() as MaterialBase;
				temp.dispose();
			}
		}
		
		/**
		 * Load mesh asynchronously & store it
		 */
		protected function loadMesh():void
		{
			_assetLoader = new Loader3D();
			_assetLoader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onMeshLoaded, false, 0, true);
			_assetLoader.loadData(BlockyMesh, new AssetLoaderContext(false));
		}
		
		/**
		 * Done loading mesh
		 * @param	event
		 */
		protected function onMeshLoaded(event:LoaderEvent):void
		{
			_assetLoader.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onMeshLoaded);
			
			// get only the first mesh
			var loadedGroup:ObjectContainer3D = ObjectContainer3D(_assetLoader);
			var numOfMeshes:int = loadedGroup.numChildren;
			var mesh:Mesh;
			if (numOfMeshes > 0)
			{
				mesh = Mesh(loadedGroup.getChildAt(0));
				mesh.material = _blockyTextures[0] as MaterialBase;
			}
			else
			{
				// TODO error on loading mesh
			}
			_blockyMesh = mesh;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Creates 3D blocky people.
		 *
		 * @param	config
		 * @return
		 */
		public function createBlockyPeople(config:Object = null):ObjectContainer3D
		{
			config = (config == null) ? {} : config;
			
			var tempResult:ObjectContainer3D = new ObjectContainer3D();
			if (_blockyMesh != null)
			{
				var mesh:Mesh = Mesh(_blockyMesh.clone());
				tempResult.addChild(mesh);
				
				// colorize
				var type:int = int(config.type);
				switch (type )
				{
				case 1:
					// colorize enemy
					mesh.material = _blockyTextures[1] as MaterialBase;
					break;
					
				case 2:
					// colorize enemy
					mesh.material = _blockyTextures[2] as MaterialBase;
					break;
				}
			}
			return tempResult;
		}

		/**
		 * Creates simple 3D bullet
		 *
		 * @param	config
		 * @return
		 */
		public function createBullet(config:Object = null):ObjectContainer3D
		{
			config = (config == null) ? { } : config;

			var tempResult:ObjectContainer3D = new ObjectContainer3D();
			if (_blockyMesh != null)
			{
				var mesh:Mesh = Mesh(_blockyMesh.clone());
				mesh.scale(0.20);
				mesh.rotationX = 90;
				mesh.y = 250;
				tempResult.addChild(mesh);
				
				// colorize
				var type:int = int(config.type);
				switch (type )
				{
				case 1:
					// colorize bullet
					mesh.material = _blockyTextures[1] as MaterialBase;
					break;
					
				case 2:
					// colorize bullet
					mesh.material = _blockyTextures[2] as MaterialBase;
					break;
				}
			}
			return tempResult;
		}
		
		/**
		 * Creates a flat plane for the arena
		 *
		 * @param	config
		 * @return
		 */
		public function createArenaPlane(config:Object = null):ObjectContainer3D
		{
			config = (config == null) ? { } : config;
			
			var tempResult:ObjectContainer3D = new ObjectContainer3D();
			
			// create plane
			var planeWidth:int = config.hasOwnProperty('width') ? config.width : 10000;
			var planeHeight:int = config.hasOwnProperty('height') ? config.height : 10000;
			var mesh:Mesh = new Mesh(new PlaneGeometry(planeWidth, planeHeight, 4, 4));
			
			// create bitmap texture
			var textureBitmapData:BitmapData = Bitmap(new ArenaTexture()).bitmapData;
			var bitmapTexture:BitmapTexture = new BitmapTexture(textureBitmapData);
			var tempTexture:TextureMaterial = new TextureMaterial(bitmapTexture, true, true, false);
			
			var planeColor:uint = config.hasOwnProperty('color') ? config.color : 0xcccccc;
			mesh.material = tempTexture;
			tempResult.addChild(mesh);

			trace(DEBUG_TAG, 'made a plane with width=' + planeWidth +
				' height=' + planeHeight + ' color=' + planeColor);
			
			return tempResult;
		}
	}

}
