package sabelas.systems
{
	import ash.core.Entity;
	import flash.geom.Point;
	import sabelas.components.CloneMember;
	import sabelas.components.Gun;
	import sabelas.nodes.CloneWithGunNode;
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
		private var _clonesWithGun:NodeList;
		private var _leaderGun:Gun = null;
		
		public function CloneFireSystem()
		{
		}

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			_clonesWithGun = engine.getNodeList(CloneWithGunNode);
			_clonesWithGun.nodeAdded.add(onCloneAdded);
			_clonesWithGun.nodeRemoved.add(onCloneRemoved);
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
				var cloneNode:CloneWithGunNode = _clonesWithGun.head;
				if (cloneNode != null)
				{
					leaderEntity = cloneNode.cloneMember.cloneLeader;
					
					// get the gun
					_leaderGun = leaderEntity.get(Gun);
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
			if (_clonesWithGun.head == null)
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
			var isLeaderShoots:Boolean = _leaderGun.isAllowedToShootBullet();
				
			// update clone with gun
			for (var cloneNode:CloneWithGunNode = _clonesWithGun.head; cloneNode; cloneNode = cloneNode.next)
			{
				cloneNode.gun.triggerShoot(isLeaderShoots, time);
			}
		}

		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			_clonesWithGun.nodeAdded.remove(onCloneAdded);
			_clonesWithGun.nodeRemoved.remove(onCloneRemoved);
			_clonesWithGun = null;
		}
		
	}

}
