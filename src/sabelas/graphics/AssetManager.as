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
	import flash.utils.Dictionary;
	
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
		
		[Embed(source="../../../assets/bullet-textures.png")]
		private static const BulletTexture:Class;

		[Embed(source="../../../assets/blocky.obj", mimeType="application/octet-stream")]
		private static const BlockyMesh:Class;

		[Embed(source="../../../assets/bullet01.obj", mimeType="application/octet-stream")]
		private static const BlockyBullet:Class;
		
		/** Dictionary of textures */
		private var _texturesDictionary:Dictionary = new Dictionary();
		
		private var _blockyMesh:Mesh;
		private var _bulletMesh:Mesh;
		
		private var _assetLoader:Loader3D;
		
		private var _arenaTexture:TextureMaterial;
		private var _spawnArenaTexture:TextureMaterial;
		
		[Embed(source="../../../assets/arena_texture.png")]
		private static const ArenaTexture:Class;
		
		public static const ASSET_HERO:int = 10;
		public static const ASSET_CLONE:int = 20;
		public static const ASSET_CLONE_DEPOSIT:int = 21;
		public static const ASSET_ENEMY:int = 30;
		public static const ASSET_BULLET_HERO:int = 40;
		public static const ASSET_BULLET_ENEMY:int = 50;
		
		// keys to access texture dictionay
		public static const TEXTURE_HERO:String = 'hero';
		public static const TEXTURE_CLONE:String = 'clone';
		public static const TEXTURE_CLONE_DEPOSIT:String = 'clone_fly';
		public static const TEXTURE_ENEMY:String = 'enemy';
		public static const TEXTURE_BULLET:String = 'bullet01';
		
		public function AssetManager()
		{
			super();
			Loader3D.enableParser(OBJParser);
		}
		
		/**
		 * List of meshes to be loaded
		 * @see	#loadMesh()
		 */
		private var _meshesToLoad:Array;
		
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
			
			prepareTexture();
			
			// create texture for spawning arena
			var cropCircle:Sprite = new Sprite();
			var g:Graphics = cropCircle.graphics;
			g.beginFill(0xcccccc, 0.6);
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
			
			// prepare list of Meshes
			_meshesToLoad = [
				{ name: 'blocky', data: BlockyMesh },
				{ name: 'bullet', data: BlockyBullet }
			];
			
			loadMesh();
		}
		
		public function destroy():void
		{
			if (_blockyMesh != null)
			{
				_blockyMesh.dispose();
				_blockyMesh = null;
			}
			
			if (_bulletMesh != null)
			{
				_bulletMesh.dispose();
				_bulletMesh = null;
			}
			
			disposeTextures();
			
			// destroy other
			_arenaTexture.dispose();
			_arenaTexture = null;
		}
		
		protected function disposeTextures():void
		{
			for each (var temp:MaterialBase in _texturesDictionary)
			{
				temp.dispose();
			}
		}
		
		/**
		 * Prepare textures
		 */
		protected function prepareTexture():void
		{
			// create bitmap textures for block characters
			var bitmapTexture:BitmapTexture;
			var tempTexture:TextureMaterial;
			
			disposeTextures();
			
			// main hero
			bitmapTexture = new BitmapTexture(Bitmap(new BlockyTexture()).bitmapData);
			tempTexture = new TextureMaterial(bitmapTexture);
			_texturesDictionary[TEXTURE_HERO] = tempTexture;
			
			// hero's clone
			tempTexture = new TextureMaterial(bitmapTexture);
			tempTexture.colorTransform = new ColorTransform(0.5, 0.5, 0.5, 1, 0x80, 0x80, 0x80, 0);
			_texturesDictionary[TEXTURE_CLONE] = tempTexture;
			
			// clone with FX: deposit
			tempTexture = new TextureMaterial(bitmapTexture);
			tempTexture.colorTransform = new ColorTransform(0.5, 0.5, 0.5, 1, 0x80, 0x80, 0x80, 0);
			tempTexture.alpha = 0.6;
			_texturesDictionary[TEXTURE_CLONE_DEPOSIT] = tempTexture;
			
			// enemy texture
			tempTexture = new TextureMaterial(bitmapTexture);
			tempTexture.colorTransform = new ColorTransform(0, 1, 1, 1, 255, 0, 0, 0);
			_texturesDictionary[TEXTURE_ENEMY] = tempTexture;
			
			// bullet
			bitmapTexture = new BitmapTexture(Bitmap(new BulletTexture()).bitmapData);
			tempTexture = new TextureMaterial(bitmapTexture);
			//tempTexture.alphaBlending = true;
			_texturesDictionary[TEXTURE_BULLET] = tempTexture;
		}
		
		/**
		 * Load mesh asynchronously & store it
		 */
		protected function loadMesh():void
		{
			// check the mesh to load
			if (_meshesToLoad.length == 0)
			{
				// no more to load
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				var meshData:Object = _meshesToLoad[0] as Object;
				
				// load
				_assetLoader = new Loader3D();
				_assetLoader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onMeshLoaded, false, 0, true);
				_assetLoader.loadData(meshData.data as Class, new AssetLoaderContext(false));
			}
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
			}
			else
			{
				// TODO error on loading mesh
			}
			
			// store the loaded mesh
			var meshData:Object = (_meshesToLoad.length > 0) ?
				_meshesToLoad.shift() as Object : null;
			switch (meshData.name as String)
			{
			case 'blocky':
				_blockyMesh = mesh;
				break;
				
			case 'bullet':
				_bulletMesh = mesh;
				break;
			}
			
			// process next mesh
			loadMesh();
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
				case ASSET_HERO:
					mesh.material = _texturesDictionary[TEXTURE_HERO] as MaterialBase;
					break;
					
				case ASSET_CLONE:
					mesh.material = _texturesDictionary[TEXTURE_CLONE] as MaterialBase;
					break;
					
				case ASSET_CLONE_DEPOSIT:
					mesh.material = _texturesDictionary[TEXTURE_CLONE_DEPOSIT] as MaterialBase;
					break;
					
				case ASSET_ENEMY:
					mesh.material = _texturesDictionary[TEXTURE_ENEMY] as MaterialBase;
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
				var mesh:Mesh = Mesh(_bulletMesh.clone());
				mesh.scale(2);
				mesh.rotationY = 90;
				mesh.y = 250;
				tempResult.addChild(mesh);
				
				// colorize
				var type:int = int(config.type);
				switch (type )
				{
				case ASSET_BULLET_HERO:
				default:
					mesh.material = _texturesDictionary[TEXTURE_BULLET] as MaterialBase;
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
			var planeGeometry:PlaneGeometry = new PlaneGeometry(planeWidth, planeHeight, 4, 4);
			planeGeometry.scaleUV(10, 10);  // tiling
			var mesh:Mesh = new Mesh(planeGeometry);
			
			// handle material
			if (config.hasOwnProperty('color'))
			{
				var planeColor:uint = config.color;
				mesh.material = new ColorMaterial(planeColor);
			}
			else // no color, assume using arena texture
			{
				mesh.material = _arenaTexture;
			}
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
