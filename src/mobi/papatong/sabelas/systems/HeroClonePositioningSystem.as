package mobi.papatong.sabelas.systems
{
	import flash.geom.Point;
	import mobi.papatong.sabelas.core.EntityCreator;
	import mobi.papatong.sabelas.nodes.HeroClonesNode;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;
	
	/**
	 * System for managing hero clones. This system will handle the positioning of the clones,
	 * make sure it pushes among clones and sorrounds the clone leader
	 *
	 * @author Abiyasa
	 */
	public class HeroClonePositioningSystem extends System
	{
		private var _creator:EntityCreator;
		private var _clones:NodeList;
		
		private static const IDEAL_DISTANCE:Number = 250.0;
		private static const IDEAL_DISTANCE_SQUARE:Number = IDEAL_DISTANCE * IDEAL_DISTANCE;
		
		/** Maximum repulsive energy */
		public static const MAX_REPULSIVE_ENERGY:Number = 5000;
		
		/** Minimum repulsive energy */
		public static const MIN_REPULSIVE_ENERGY:Number = -5000;
		
		public function HeroClonePositioningSystem(creator:EntityCreator)
		{
			_creator = creator;
		}

		override public function addToGame(game:Game):void
		{
			_clones = game.getNodeList(HeroClonesNode);
		}
		
		override public function update(time:Number):void
		{
			var sourceClone:HeroClonesNode;
			var targetClone:HeroClonesNode;
			var leaderNode:HeroClonesNode;
			var sourcePosition:Point;
			var distance:Number;
			var sourceRadius:Number;
			var repulsiveForce:Number;
			for (sourceClone = _clones.head; sourceClone; sourceClone = sourceClone.next)
			{
				// check if this is a leader
				if (sourceClone.heroClone.isLeader)
				{
					leaderNode = sourceClone;
				}
				
				// handle repulsive force between clones
				sourcePosition = sourceClone.position.position;
				sourceRadius = sourceClone.collision.radius;
				targetClone = sourceClone.next;
				while (targetClone != null)
				{
					// calculate distance between source and target clones
					distance = Point.distance(sourcePosition, targetClone.position.position)
					
					// calculate the repulsive force between clones
					if (distance < IDEAL_DISTANCE)
					{
						// consider radius
						distance -= (sourceRadius + targetClone.collision.radius);
						if (distance <= 0)
						{
							// nodes are colliding, repluse at full power
							repulsiveForce = MAX_REPULSIVE_ENERGY;
						}
						else  // nodes are not colliding
						{
							repulsiveForce = calculateForceReplusive(distance);
						}
						
						// TODO modify the source and the target cloneForce vector, unless it's the leader
						
					}
					
					// next to compare
					targetClone = targetClone.next;
				}
			}
			
			// calculate the attractive forces between the clones and its leader
			var attractiveForce:Number;
			if (leaderNode != null)
			{
				sourcePosition = leaderNode.position.position;
				sourceRadius = leaderNode.collision.radius;
				for (targetClone = _clones.head; targetClone; targetClone = targetClone.next)
				{
					if (targetClone == leaderNode)
					{
						continue;
					}
					
					// calculate the force
					distance = Point.distance(sourcePosition, targetClone.position.position);
					if (distance < IDEAL_DISTANCE)
					{
						// consider radius
						distance -= (sourceRadius + targetClone.collision.radius);
						if (distance > 0)
						{
							// nodes are not colliding, they can attracted now
							attractiveForce = calculateForceAttractive(distance);
						}
						
						// TODO modify the target cloneForce vector using attractiveForce
					}
				}
			}
			
			// TODO in the end, apply cloneForce to speed
				// TODO set cloneForce to 0
		}

		override public function removeFromGame(game:Game):void
		{
			_clones = null;
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
			return temp;
		}
		
		/**
		 * Calculates the attractive forces between two clones
		 *
		 * @param distance distance between the two clones
		 * @return the attractive force
		 */
		private static function calculateForceAttractive(distance:Number):Number
		{
			return (distance * distance) / IDEAL_DISTANCE;
		}
		
	}

}
