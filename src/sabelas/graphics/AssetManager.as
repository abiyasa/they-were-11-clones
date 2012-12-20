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
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
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
		
		private var _arenaTexture:TextureMaterial;
		private var _spawnArenaTexture:TextureMaterial;
		
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
			// create texture for the whole arena
			var textureBitmapData:BitmapData = Bitmap(new ArenaTexture()).bitmapData;
			var bitmapTexture:BitmapTexture = new BitmapTexture(textureBitmapData);
			_arenaTexture = new TextureMaterial(bitmapTexture, true, true, false);
			
			// create bitmap textures for block characters
			textureBitmapData = Bitmap(new BlockyTexture()).bitmapData;
			bitmapTexture = new BitmapTexture(textureBitmapData);
			
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
			
			// create texture for spawning arena
			var cropCircle:Sprite = new Sprite();
			var g:Graphics = cropCircle.graphics;
			g.beginFill(0xcccccc, 0.1);
			/*
			var m:Matrix = new Matrix();
			m.createGradientBox(128, 128, 0, 0, 0);
			g.beginGradientFill("radial", [0xCCCCCC, 0xFFFFFF], [ 0.6, 0.0 ], [ 0, 255 ], m);
			*/
			g.drawCircle(64, 64, 60);
			g.endFill();
			textureBitmapData = new BitmapData(128, 128, true, 0x00FFFFFF);
			textureBitmapData.draw(cropCircle);
			bitmapTexture = new BitmapTexture(textureBitmapData);
			_spawnArenaTexture = new TextureMaterial(bitmapTexture);
			_spawnArenaTexture.alphaBlending = true;
			
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
			
			// destroy other
			_arenaTexture.dispose();
			_arenaTexture = null;
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
			
			mesh.material = _arenaTexture;
			tempResult.addChild(mesh);
			
			return tempResult;
		}
		
		/**
		 * Creates a flat plane for the spawning arena
		 *
		 * @param	config
		 * @return
		 */
		public function createSpawnPlane(config:Object = null):ObjectContainer3D
		{
			config = (config == null) ? { } : config;
			
			var tempResult:ObjectContainer3D = new ObjectContainer3D();
			
			// create plane
			var planeWidth:int = config.hasOwnProperty('width') ? config.width : 200;
			var planeHeight:int = config.hasOwnProperty('height') ? config.height : 200;
			var mesh:Mesh = new Mesh(new PlaneGeometry(planeWidth, planeHeight, 1, 1));
			
			// create plane material
			var planeColor:uint = config.hasOwnProperty('color') ? config.color : 0xcccccc;
			mesh.material = _spawnArenaTexture;
			tempResult.addChild(mesh);
			
			trace(DEBUG_TAG, 'made a plane with width=' + planeWidth +
				' height=' + planeHeight + ' color=' + planeColor);
			
			return tempResult;
		}
	}

}
