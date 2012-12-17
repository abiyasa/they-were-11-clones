package sabelas.systems
{
	import flash.geom.Point;
	import sabelas.components.Motion;
	import sabelas.core.EntityCreator;
	import sabelas.components.CollidingObject;
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
			var sourceMotion:Motion;
			var sourcePosition:Point;
			var movingObjectTarget:CollisionNode;
			var movingObjectSource:CollisionNode;
			for (movingObjectSource = _movingObjects.head; movingObjectSource; movingObjectSource = movingObjectSource.next)
			{
				// skipping none moving object
				if (movingObjectSource.collidingObject.type == CollidingObject.TYPE_NON_MOVING_OBJECT)
				{
					continue;
				}

				// caculate next position
				sourceMotion = movingObjectSource.motion;
				var angle:Number = sourceMotion.angle;
				sourcePosition = movingObjectSource.position.position.clone();
				sourcePosition.x += sourceMotion.calculateDeltaX(time);
				sourcePosition.y += sourceMotion.calculateDeltaY(time);
				
				// check collision with the rest
				sourceRadius = movingObjectSource.collision.radius;
				movingObjectTarget = movingObjectSource.next;
				while (movingObjectTarget != null)
				{
					if (Point.distance(sourcePosition, movingObjectTarget.position.position) <=
						(sourceRadius + movingObjectTarget.collision.radius))
					{
						trace('collision happens');
						
						// collision happens, prevent moving on both
						movingObjectSource.motion.speed = 0;
						sourceMotion.speed = 0;
						
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
