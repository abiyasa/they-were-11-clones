package sabelas.systems
{
	import ash.core.Entity;
	import flash.geom.Point;
	import sabelas.components.Position;
	import sabelas.nodes.CloneLeaderNode;
	import sabelas.nodes.MapPointNode;
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	
	/**
	 * System for showing direction of several map points based on hero position
	 *
	 * @author Abiyasa
	 */
	public class HeroCompassSystem extends System
	{
		private var _mapPoints:NodeList;
		private var _heroes:NodeList;
		private var _hero:CloneLeaderNode;
		
		public function HeroCompassSystem()
		{
		}

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			
			_mapPoints = engine.getNodeList(MapPointNode);
			
			_heroes = engine.getNodeList(CloneLeaderNode);
			_heroes.nodeAdded.add(onHeroAdded);
			_heroes.nodeRemoved.add(onHeroRemoved);
		}
		
		private function onHeroAdded(node:CloneLeaderNode):void
		{
			_hero = node;
		}
		
		private function onHeroRemoved(node:CloneLeaderNode):void
		{
			_hero = null;
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			
			_mapPoints = null;
			
			_heroes.nodeAdded.remove(onHeroAdded);
			_heroes.nodeRemoved.remove(onHeroRemoved);
			_heroes = null;
		}
		
		override public function update(time:Number):void
		{
			// stop if no hero
			if (_hero == null)
			{
				return;
			}
			
			// TODO get hero's position
			
			// calculate direction between hero & map points
			var mapPointNode:MapPointNode;
			for (mapPointNode = _mapPoints.head; mapPointNode; mapPointNode = mapPointNode.next)
			{
				// TODO get map point position
				
				// TODO compare to hero position
			}
		}

	}

}
