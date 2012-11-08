package mobi.papatong.sabelas
{
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import mobi.papatong.sabelas.utils.Stage3DUtils;
	import starling.core.Starling;
	
	[SWF(width='320', height='240', frameRate='45', backgroundColor='#FFFFFF')]
	public class Main extends Sprite
	{
		private var _starling:Starling;
		private var _stage3dProxy:Stage3DProxy;
		private var _view3D:View3D;
		
		public function Main()
		{
			addEventListener(Event.ENTER_FRAME, init);
		}
		
		private function init(event:Event):void
		{
			if (stage.stageWidth && stage.stageHeight)
			{
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;

				removeEventListener(Event.ENTER_FRAME, init);
				addEventListener(Event.REMOVED_FROM_STAGE, deinit);
				
				// use stage 3d manager to get stage3d proxy
				var stage3dManager:Stage3DManager = Stage3DManager.getInstance(stage);
				_stage3dProxy = stage3dManager.getFreeStage3DProxy();
				_stage3dProxy.antiAlias = 4;
				_stage3dProxy.color = 0xFFFFFF;
				_stage3dProxy.enableDepthAndStencil = false;
				_stage3dProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			}
		}
		
		private function onContextCreated(event:Stage3DEvent):void
		{
			// Drop down to 30 FPS for software render mode
			var driverInfo:String = _stage3dProxy.context3D.driverInfo.toLowerCase();
			var antiAlias:int = 4;
			if (driverInfo.indexOf("software") != -1)
			{
				// low quality
				this.stage.frameRate = 30;
				trace('dropping framerate to 30 due to software rendering');
				
				antiAlias = 0;
			}
			_stage3dProxy.antiAlias = antiAlias;
			
			// init starling
			_starling = new Starling(StarlingRootApplication, stage, _stage3dProxy.viewPort, _stage3dProxy.stage3D);
			_starling.antiAliasing = antiAlias;
			_starling.start();

			// create view3D
			_view3D = new View3D();
			_view3D.stage3DProxy = _stage3dProxy;
			_view3D.shareContext = true;
			_view3D.antiAlias = antiAlias;
			this.addChild(_view3D);
			
			// store at stage3DUtils
			var stage3DUtils:Stage3DUtils = Stage3DUtils.getInstance();
			stage3DUtils.currentView3D = _view3D;
			stage3DUtils.currentStage3DProxy = _stage3dProxy;
			
			// handle render manually
			_stage3dProxy.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Render stage3D context (Away3D and Starling) manually
		 * @param	event
		 */
		private function onEnterFrame(event:Event):void
		{
			_view3D.render();
			_starling.nextFrame();
		}
		
		private function deinit(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, deinit);
			
			if (_starling != null)
			{
				_starling.stop();
			}
			
			if (_view3D != null)
			{
				_view3D.dispose();
			}
			
			if (_stage3dProxy != null)
			{
				_stage3dProxy.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				
				_stage3dProxy.clear();
				_stage3dProxy.dispose();
			}
		}
	}
}
