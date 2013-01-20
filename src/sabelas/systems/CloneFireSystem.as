package sabelas.systems
{
	import ash.core.Entity;
	import flash.geom.Point;
	import sabelas.components.CloneMember;
	import sabelas.components.Gun;
	import sabelas.components.Position;
	import sabelas.nodes.ClonesNode;
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	
	/**
	 * System for making clone shooting when the clone leader shoots.
	 *
	 * @author Abiyasa
	 */
	public class CloneFireSystem extends System
	{
		private var _clones:NodeList;
		private var _leaderGun:Gun = null;
		
		public function CloneFireSystem()
		{
		}

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			_clones = engine.getNodeList(ClonesNode);
			_clones.nodeAdded.add(onCloneAdded);
			_clones.nodeRemoved.add(onCloneRemoved);
		}
		
		/**
		 * Gets the clone leader's gun state,
		 * asuming 1 leader for all clones
		 * @param	node
		 */
		protected function onCloneAdded(node:*):void
		{
			// get the gun of clone leader if ncessary
			if (_leaderGun == null)
			{
				var leaderEntity:Entity;
				var cloneNode:ClonesNode = _clones.head;
				if (cloneNode != null)
				{
					leaderEntity = cloneNode.cloneMember.cloneLeader;
					
					// get the gun
					_leaderGun = leaderEntity.get(Gun);
					trace('got the clone leader');
				}
			}
		}
		
		/**
		 * Remove the clone leader's gun state,
		 * asuming 1 leader for all clones
		 * @param	node
		 */
		protected function onCloneRemoved(node:*):void
		{
			// reset the gun of clone leader if no more clone
			if (_clones.head == null)
			{
				_leaderGun = null
			}
		}
		
		override public function update(time:Number):void
		{
			if (_leaderGun == null)
			{
				return;
			}
			
			// check if the leader shoots!
			if (_leaderGun.isAllowedToShootBullet())
			{
				trace('clone shoots');
				
				// make clone shoots
				var clonePosition:Position;
				var cloneGun:Gun;
				for (var cloneNode:ClonesNode = _clones.head; cloneNode; cloneNode = cloneNode.next)
				{
					// TODO trigger clone's gun to shoot
					/*
					cloneGun = cloneNode.entity.get(Gun);
					if (cloneGun != null)
					{
						cloneGun.triggerShoot(true, time);
					}
					*/
				}
			}
		}

		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			_clones.nodeAdded.remove(onCloneAdded);
			_clones.nodeRemoved.remove(onCloneRemoved);
			_clones = null;
		}
		
	}

}
