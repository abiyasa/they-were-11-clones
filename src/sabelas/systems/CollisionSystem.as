package sabelas.systems
{
	import flash.geom.Point;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.CollisionNode;
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	
	/**
	 * System for managing collistion between objects.
	 * This will check if a moving object is colliding with other objects
	 * If a collision happens, the moving object will not move.
	 *
	 * @author Abiyasa
	 */
	public class CollisionSystem extends System
	{
		private var _creator:EntityCreator;
		private var _movingObjects:NodeList;
		
		public function CollisionSystem(creator:EntityCreator)
		{
			_creator = creator;
		}

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			_movingObjects = engine.getNodeList(CollisionNode);
		}
		
		override public function update(time:Number):void
		{
			var sourceRadius:Number;
			var sourceSpeed:Number;
			var sourcePosition:Point;
			var movingObjectTarget:CollisionNode;
			var movingObjectSource:CollisionNode;
			for (movingObjectSource = _movingObjects.head; movingObjectSource; movingObjectSource = movingObjectSource.next)
			{
				sourceSpeed = movingObjectSource.motion.speed;
				if ((sourceSpeed < 0.01) && (sourceSpeed > -0.01))
				{
					// skipping none moving object
					continue;
				}

				// caculate next position
				var angle:Number = movingObjectSource.motion.angle;
				sourcePosition = movingObjectSource.position.position.clone();
				sourcePosition.x += movingObjectSource.motion.calculateDeltaX(time);
				sourcePosition.y += movingObjectSource.motion.calculateDeltaY(time);
				
				// check collision with the rest
				sourceRadius = movingObjectSource.collision.radius;
				movingObjectTarget = movingObjectSource.next;
				while (movingObjectTarget != null)
				{
					if (Point.distance(sourcePosition, movingObjectTarget.position.position) <=
						(sourceRadius + movingObjectTarget.collision.radius))
					{
						// collision happens, prevent moving
						movingObjectSource.motion.speed = 0;
						
						// stop checking, skip the rest since the source object will stop to move
						movingObjectTarget = null;
					}
					else  // no collision yet
					{
						// next to compare
						movingObjectTarget = movingObjectTarget.next;
					}
				}
			}
		}

		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			_movingObjects = null;
		}
	}

}
