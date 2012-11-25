package mobi.papatong.sabelas.graphics
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.loaders.parsers.OBJParser;
	import away3d.events.LoaderEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Factory and manager 3D assets.
	 * Creating 3D characters and objects
	 *
	 * @author Abiyasa
	 */
	public class AssetManager extends EventDispatcher
	{
		public static const DEBUG_TAG:String = "AssetManager";
		
		[Embed(source="../../../../../assets/blocky_texture.png")]
		private static const BlockyTexture:Class;

		[Embed(source="../../../../../assets/blocky.obj", mimeType="application/octet-stream")]
		private static const BlockyMesh:Class;
		
		private var _blockyTexture:TextureMaterial;
		
		private var _blockyMesh:Mesh;
		
		private var _assetLoader:Loader3D;
		
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
			// create texture
			var theBitmap:Bitmap = Bitmap(new BlockyTexture());
			_blockyTexture = new TextureMaterial(new BitmapTexture(theBitmap.bitmapData));
			
			loadMesh();
		}
		
		public function destroy():void
		{
			if (_blockyMesh != null)
			{
				_blockyMesh.dispose();
				_blockyMesh = null;
			}
			
			if (_blockyTexture != null)
			{
				_blockyTexture.dispose();
				_blockyTexture = null;
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
				mesh.material = _blockyTexture;
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
		 * Will dispatch event when done
		 *
		 * @param	config
		 * @return
		 */
		public function createBlockyPeople(config:Object = null):ObjectContainer3D
		{
			var tempResult:ObjectContainer3D = new ObjectContainer3D();
			if (_blockyMesh != null)
			{
				tempResult.addChild(Mesh(_blockyMesh.clone()));
			}
			return tempResult;
		}
		
	}

}
