package mobi.papatong.sabelas
{
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import starling.core.Starling;
	
	[SWF(width='320', height='240', frameRate='45', backgroundColor='#FFFFFF')]
	public class Main extends Sprite
	{
		private var _starling:Starling;
		private var _stage3dProxy:Stage3DProxy;
		
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
			if (driverInfo.indexOf("software") != -1)
			{
				this.stage.frameRate = 30;
				
				trace('dropping framerate to 30 due to software rendering');
			}
			
			// handle render manually
			_stage3dProxy.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			// init starling
			_starling = new Starling(StarlingRootApplication, stage, _stage3dProxy.viewPort, _stage3dProxy.stage3D);
			_starling.antiAliasing = 0;
			_starling.start();
		}
		
		/**
		 * Render stage3D context manually
		 * @param	event
		 */
		private function onEnterFrame(event:Event):void
		{
			_stage3dProxy.clear();
			_starling.nextFrame();
			_stage3dProxy.present();
		}
		
		private function deinit(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, deinit);
			
			if (_starling != null)
			{
				_starling.stop();
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
