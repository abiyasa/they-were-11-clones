package sabelas.systems
{
	import flash.geom.Point;
	import sabelas.components.MapPoint;
	import sabelas.components.Position;
	import sabelas.nodes.CloneLeaderNode;
	import sabelas.nodes.MapPointNode;
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;

	/**
	 * Map system showing sorrounding map point
	 *
	 * @author Abiyasa
	 */
	public class MapDisplaySystem extends System
	{
		public static const DEBUG_TAG:String = '[MapDisplaySystem]';
		
		public static const MAP_PADDING:int = 4;
		public static const MAP_DISPLAY_WIDTH:int = 100;
		public static const MAP_DISPLAY_HEIGHT:int = 80;
		public static const MAP_DISPLAY_CENTER_X:int = MAP_DISPLAY_WIDTH / 2;
		public static const MAP_DISPLAY_CENTER_Y:int = MAP_DISPLAY_HEIGHT / 2;
		public static const MAP_DISPLAY_USABLE_WIDTH:int = MAP_DISPLAY_WIDTH - MAP_PADDING;
		public static const MAP_DISPLAY_USABLE_HEIGHT:int = MAP_DISPLAY_HEIGHT - MAP_PADDING;
		
		public static const MAP_SCALE:Number = 0.01;
		
		private var _container:DisplayObjectContainer;
		private var _mapPoints:NodeList;
		private var _heroes:NodeList;
		private var _hero:CloneLeaderNode;
		private var _heroPosition:Position;
		private var _heroPin:DisplayObject;
		
		public function MapDisplaySystem(container:DisplayObjectContainer)
		{
			_container = container;
			
			// prepare container
			container.removeChildren();
			var background:Quad = new Quad(MAP_DISPLAY_WIDTH, MAP_DISPLAY_HEIGHT, 0x000000);
			background.alpha = 0.4;
			container.addChild(background);
		}
		
		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			
			_mapPoints = engine.getNodeList(MapPointNode);
			_mapPoints.nodeAdded.add(onMapPointAdded);
			_mapPoints.nodeRemoved.add(onMapPointRemoved);
			
			_heroes = engine.getNodeList(CloneLeaderNode);
			_heroes.nodeAdded.add(onHeroAdded);
			_heroes.nodeRemoved.add(onHeroRemoved);
		}

		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			
			_container.removeChildren();
			if (_heroPin != null)
			{
				_heroPin.dispose();
				_heroPin = null;
			}
			
			_mapPoints.nodeAdded.remove(onMapPointAdded);
			_mapPoints.nodeRemoved.remove(onMapPointRemoved);
			_mapPoints = null;
			
			_heroes.nodeAdded.remove(onHeroAdded);
			_heroes.nodeRemoved.remove(onHeroRemoved);
			_heroes = null;
			
			_mapPoints = null;
		}
		
		private function onHeroAdded(node:CloneLeaderNode):void
		{
			_hero = node;
			_heroPosition = _hero.position;
			
			// create hero pin
			if (_heroPin == null)
			{
				_heroPin = generateSimpleMapPoint(999);
				_heroPin.x = MAP_DISPLAY_CENTER_X;
				_heroPin.y = MAP_DISPLAY_CENTER_Y;
			}
			_container.addChild(_heroPin);
		}
		
		private function onHeroRemoved(node:CloneLeaderNode):void
		{
			_hero = null;
			_heroPosition = null;
			_container.removeChild(_heroPin);
		}
		
		private function onMapPointAdded(node:MapPointNode):void
		{
			// create QUAD color based on map point type
			var mapPoint:MapPoint = node.mapPoint;
			mapPoint.mapPin = generateSimpleMapPoint(mapPoint.type);
			
			_container.addChild(mapPoint.mapPin);
		}
		
		private function onMapPointRemoved(node:MapPointNode):void
		{
			var mapPoint:MapPoint = node.mapPoint;
			_container.removeChild(mapPoint.mapPin);

			// remove QUAD from component
			mapPoint.mapPin.dispose();
			mapPoint.mapPin = null;
		}
		
		/**
		 * Generates simple map point
		 * @param	type
		 * @return
		 */
		private function generateSimpleMapPoint(type:int):DisplayObject
		{
			// pick color
			var theColor:int;
			switch (type)
			{
			case MapPoint.TYPE_CLONE_DEPOSIT:
				theColor = 0x009EEF;
				break;
			
			// main hero
			case 999:
				theColor = 0x666666;
				break;
				
			default:
				theColor = 0xFF8080;
				break;
			}
			
			var quad:Quad = new Quad(4, 4, theColor);
			return quad as DisplayObject;
		}
		
		override public function update(time:Number):void
		{
			if (_hero == null)
			{
				return;
			}
			
			// get hero position
			var heroPos:Point = _heroPosition.position;
			
			// loop through the map points
			var mapPointPosition:Point;
			var mapPosX:int;
			var mapPosY:int;
			var mapPintObject:DisplayObject;
			for(var node:MapPointNode = _mapPoints.head; node; node = node.next)
			{
				mapPintObject = node.mapPoint.mapPin;
				if (mapPintObject != null)
				{
					mapPointPosition = node.position.position;
					mapPosX = mapPointPosition.x;
					mapPosY = mapPointPosition.y;
					
					// compare to hero's position
					mapPosX = MAP_DISPLAY_CENTER_X + (mapPosX - heroPos.x) * MAP_SCALE;
					mapPosY = MAP_DISPLAY_CENTER_Y - (mapPosY - heroPos.y) * MAP_SCALE;
					
					// hide or show pin if it's outside the map area
					if ((mapPosX < 0) || (mapPosX > MAP_DISPLAY_USABLE_WIDTH) || (mapPosY < 0)
						|| (mapPosY > MAP_DISPLAY_USABLE_HEIGHT))
					{
						// map point outside the map area
						mapPintObject.visible = false;
					}
					else
					{
						// map point inside the area
						mapPintObject.visible = true;
						mapPintObject.x = mapPosX;
						mapPintObject.y = mapPosY;
						//mapPintObject.rotation = mapPointPosition.rotation;
					}
				}
			}
		}
	}
}
