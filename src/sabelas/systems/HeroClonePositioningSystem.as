package mobi.papatong.sabelas.systems
{
	import flash.geom.Point;
	import mobi.papatong.sabelas.components.HeroClone;
	import mobi.papatong.sabelas.core.EntityCreator;
	import mobi.papatong.sabelas.nodes.HeroClonesNode;
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	
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

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			_clones = engine.getNodeList(HeroClonesNode);
		}
		
		override public function update(time:Number):void
		{
			var sourceClone:HeroClonesNode;
			var targetClone:HeroClonesNode;
			var sourceHeroClone:HeroClone;
			var leaderNode:HeroClonesNode;
			var sourceIsLeader:Boolean;
			var sourcePosition:Point, targetPosition:Point;
			var distance:Number, dx:Number, dy:Number, tempX:Number, tempY:Number;
			var sourceRadius:Number;
			
			// handle repulsive force between clones
			var repulsiveForce:Number;
			for (sourceClone = _clones.head; sourceClone; sourceClone = sourceClone.next)
			{
				// check if this is a leader
				if (sourceClone.heroClone.isLeader)
				{
					sourceIsLeader = true;
					leaderNode = sourceClone;
				}
				else
				{
					sourceIsLeader = false;
				}
				
				sourceHeroClone = sourceClone.heroClone;
				
				// calculate repulsive force
				sourcePosition = sourceClone.position.position;
				sourceRadius = sourceClone.collision.radius;
				targetClone = sourceClone.next;
				while (targetClone != null)
				{
					// calculate distance between source and target clones
					targetPosition = targetClone.position.position;
					dx = targetPosition.x - sourcePosition.x;
					dy = targetPosition.y - sourcePosition.y;
					distance = Math.sqrt((dx * dx) + (dy * dy));
					
					// calculate the repulsive force between clones
					if (distance < IDEAL_DISTANCE)
					{
						// consider radius
						distance -= (sourceRadius + targetClone.collision.radius);
						if (distance <= 0)
						{
							// nodes are colliding, repluse at full power
							repulsiveForce = MAX_REPULSIVE_ENERGY;
							distance = 0.01;
						}
						else  // nodes are not colliding
						{
							repulsiveForce = calculateForceReplusive(distance);
						}
						
						// modify the source and the target cloneForce vector, unless it's the leader
						repulsiveForce *= 0.001;
						// TODO there should be minimum repulsive energy
						tempX = (dx / distance) * repulsiveForce;
						tempY = (dy / distance) * repulsiveForce;
						if (!sourceIsLeader)
						{
							sourceHeroClone.addForce(-tempX, -tempY);
						}
						targetClone.heroClone.addForce(tempX, tempY);
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
					
					// calculate distance
					targetPosition = targetClone.position.position;
					dx = targetPosition.x - sourcePosition.x;
					dy = targetPosition.y - sourcePosition.y;
					distance = Math.sqrt((dx * dx) + (dy * dy));
					
					// consider radius
					distance -= (sourceRadius + targetClone.collision.radius);
					attractiveForce = calculateForceAttractive(distance);
					// TODO there should be minimum attractive energy!
					
					// modify the target cloneForce vector using attractiveForce
					attractiveForce *= 0.1;
					tempX = dx / distance * attractiveForce;
					tempY = dy / distance * attractiveForce;
					targetClone.heroClone.addForce(-tempX, -tempY);
				}
			}
			
			// apply cloneForce
			for (sourceClone = _clones.head; sourceClone; sourceClone = sourceClone.next)
			{
				sourceHeroClone = sourceClone.heroClone;
				if (sourceHeroClone.cloneForceChanged)
				{
					sourceClone.motion.forceX += sourceHeroClone.cloneForceX;
					sourceClone.motion.forceY += sourceHeroClone.cloneForceY;
					
					//trace('original force for clone x=' + sourceHeroClone.cloneForceX + ', y=' + sourceHeroClone.cloneForceY);
					//trace('total force for clone x=' + sourceClone.motion.forceX + ', y=' + sourceClone.motion.forceY);
					
					sourceHeroClone.resetCloneForce();
				}
			}
		}

		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
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
