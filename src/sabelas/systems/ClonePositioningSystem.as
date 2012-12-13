package sabelas.systems
{
	import ash.core.Entity;
	import flash.geom.Point;
	import sabelas.components.CloneMember;
	import sabelas.components.Collision;
	import sabelas.components.Position;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.ClonesNode;
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	
	/**
	 * System for managing clones. This system will handle the positioning of the clones,
	 * make sure it pushes among clones and sorrounds the clone leader
	 *
	 * @author Abiyasa
	 */
	public class ClonePositioningSystem extends System
	{
		private var _creator:EntityCreator;
		private var _clones:NodeList;
		
		private static const IDEAL_DISTANCE:Number = 500.0;
		private static const IDEAL_DISTANCE_SQUARE:Number = IDEAL_DISTANCE * IDEAL_DISTANCE;
		
		private static const MINIMUM_DISTANCE:Number = 10.0;
		
		/** Maximum repulsive energy */
		public static const MAX_REPULSIVE_ENERGY:Number = 5000.0;
		public static const MAX_REPULSIVE_ENERGY_SQUARE:Number = MAX_REPULSIVE_ENERGY * MAX_REPULSIVE_ENERGY;
		
		/** Minimum repulsive energy */
		public static const MIN_REPULSIVE_ENERGY:Number = -MAX_REPULSIVE_ENERGY;
		public static const MIN_REPULSIVE_ENERGY_SQUARE:Number = MAX_REPULSIVE_ENERGY_SQUARE;
		
		public function ClonePositioningSystem(creator:EntityCreator)
		{
			_creator = creator;
		}

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			_clones = engine.getNodeList(ClonesNode);
		}
		
		override public function update(time:Number):void
		{
			var sourceCloneNode:ClonesNode;
			var targetCloneNode:ClonesNode;
			var sourceClone:CloneMember;
			var sourcePosition:Point, targetPosition:Point;
			var distance:Number, dx:Number, dy:Number, tempX:Number, tempY:Number;
			var sourceRadius:Number;
			
			// calculate repulsive force among clones
			var repulsiveForce:Number;
			for (sourceCloneNode = _clones.head; sourceCloneNode; sourceCloneNode = sourceCloneNode.next)
			{
				sourceClone = sourceCloneNode.cloneMember;
				sourcePosition = sourceCloneNode.position.position;
				sourceRadius = sourceCloneNode.collision.radius;
				
				targetCloneNode = sourceCloneNode.next;
				while (targetCloneNode != null)
				{
					processRepulsiveForceBetweenNodes(sourcePosition, sourceRadius, sourceClone,
						targetCloneNode.position.position, targetCloneNode.collision.radius, targetCloneNode.cloneMember);
					
					// next to compare
					targetCloneNode = targetCloneNode.next;
				}
			}
			
			// get the clone leader
			var leaderEntity:Entity;
			sourceCloneNode = _clones.head;
			if (sourceCloneNode != null)
			{
				leaderEntity = sourceCloneNode.cloneMember.cloneLeader;
			}
			if (leaderEntity != null)
			{
				var leaderPostion:Position = leaderEntity.get(Position);
				var leaderRotation:Number = leaderPostion.rotation;
				sourcePosition = leaderPostion.position;
				sourceRadius = leaderEntity.get(Collision).radius;
				
				// also calculate repulsive force between clones and the leader
				for (targetCloneNode = _clones.head; targetCloneNode; targetCloneNode = targetCloneNode.next)
				{
					processRepulsiveForceBetweenNodes(sourcePosition, sourceRadius, null,
						targetCloneNode.position.position, targetCloneNode.collision.radius, targetCloneNode.cloneMember);
				}

				// calculate the attractive forces between the clones and its leader.
				var attractiveForce:Number;
				for (targetCloneNode = _clones.head; targetCloneNode; targetCloneNode = targetCloneNode.next)
				{
					// calculate distance
					targetPosition = targetCloneNode.position.position;
					dx = targetPosition.x - sourcePosition.x;
					dy = targetPosition.y - sourcePosition.y;
					distance = Math.sqrt((dx * dx) + (dy * dy));
					
					// consider radius
					distance -= (sourceRadius + targetCloneNode.collision.radius);
					if (distance > 0)
					{
						attractiveForce = calculateForceAttractive(distance);
						tempX = dx / distance * attractiveForce;
						tempY = dy / distance * attractiveForce;
						
						// TODO there should be minimum attractive energy!
						
						// modify the target cloneForce vector using attractiveForce
						targetCloneNode.cloneMember.addForce(-tempX, -tempY);
					}
					
					// also rotates clone the same as leader
					targetCloneNode.position.rotation = leaderRotation;
				}
			}
			
			// apply cloneForce
			for (sourceCloneNode = _clones.head; sourceCloneNode; sourceCloneNode = sourceCloneNode.next)
			{
				sourceClone = sourceCloneNode.cloneMember;
				if (sourceClone.cloneForceChanged)
				{
					// TODO limit the maximum cloneForce power.
					// TODO should we do this?
					var forceX:Number = sourceCloneNode.motion.forceX + sourceClone.cloneForceX;
					var forceY:Number = sourceCloneNode.motion.forceY + sourceClone.cloneForceY;
					var cloneForce:Number = (forceX * forceX) + (forceY * forceY);
					if (cloneForce > MAX_REPULSIVE_ENERGY_SQUARE)
					{
						cloneForce = Math.sqrt(cloneForce);
						
						trace('clone force is overloaded=' + cloneForce);
						
						forceX = (forceX / cloneForce) * MAX_REPULSIVE_ENERGY;
						forceY = (forceY / cloneForce) * MAX_REPULSIVE_ENERGY;
					}
					sourceCloneNode.motion.forceX = forceX;
					sourceCloneNode.motion.forceY = forceY;
					
					//trace('total force for clone x=' + sourceClone.motion.forceX + ', y=' + sourceClone.motion.forceY);
					
					sourceClone.resetCloneForce();
				}
			}
		}

		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			_clones = null;
		}
		
		/**
		 * Internal function to calculate and update repulsive forces between nodes.
		 * Both nodes (except if the node is the leader)
		 *
		 * @param	sourcePosition
		 * @param	sourceRadius
		 * @param	sourceClone Might be null (for leader)
		 * @param	targetPosition
		 * @param	targetRadius
		 * @param	targetClone Must not null
		 */
		private function processRepulsiveForceBetweenNodes(sourcePosition:Point, sourceRadius:Number,
			sourceClone:CloneMember, targetPosition:Point, targetRadius:Number,
			targetClone:CloneMember):void
		{
			// calculate distance between source and target clones
			var dx:Number = targetPosition.x - sourcePosition.x;
			var dy:Number = targetPosition.y - sourcePosition.y;
			var distance:Number = Math.sqrt((dx * dx) + (dy * dy));
			
			// calculate the repulsive force between clones
			if (distance < IDEAL_DISTANCE)
			{
				// consider radius
				distance -= (sourceRadius + targetRadius);
				if (distance <= MINIMUM_DISTANCE)
				{
					distance = MINIMUM_DISTANCE;
				}
				var repulsiveForce:Number = calculateForceReplusive(distance);
				
				// modify the source and the target cloneForce vector
				// TODO there should be minimum repulsive energy
				repulsiveForce = repulsiveForce / distance;
				var tempX:Number = dx * repulsiveForce;
				var tempY:Number = dy * repulsiveForce;
				if (sourceClone != null)
				{
					sourceClone.addForce(-tempX, -tempY);
				}
				targetClone.addForce(tempX, tempY);
			}
		}
		
		/**
		 * Calculates the repulsive forces between two clones
		 *
		 * @param distance distance between the two vertices. MUST NOT 0
		 *
		 * @return the repulsive force, with minimum and maximum define in
		 * MAX_REPULSIVE_ENERGY
		 * @see #MAX_REPULSIVE_ENERGY
		 */
		private static function calculateForceReplusive(distance:Number):Number
		{
			var temp:Number = IDEAL_DISTANCE_SQUARE / distance;
			if (temp > MAX_REPULSIVE_ENERGY)
			{
				temp = MAX_REPULSIVE_ENERGY;
			}
			else if (temp < MIN_REPULSIVE_ENERGY)
			{
				temp = MIN_REPULSIVE_ENERGY;
			}
			return temp * 0.001;
		}
		
		/**
		 * Calculates the attractive forces between two clones
		 *
		 * @param distance distance between the two clones
		 * @return the attractive force
		 */
		private static function calculateForceAttractive(distance:Number):Number
		{
			return (distance * distance) / IDEAL_DISTANCE * 0.1;
		}
		
	}

}
