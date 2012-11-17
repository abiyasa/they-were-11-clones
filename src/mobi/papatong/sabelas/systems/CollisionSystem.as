package mobi.papatong.sabelas.systems
{
	import flash.geom.Point;
	import mobi.papatong.sabelas.core.EntityCreator;
	import mobi.papatong.sabelas.nodes.CollisionNode;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;
	
	/**
	 * System for managing collistion between objects
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

		override public function addToGame(game:Game):void
		{
			_movingObjects = game.getNodeList(CollisionNode);
		}
		
		override public function update( time : Number ) : void
		{
			var sourceRadius:Number;
			var sourcePosition:Point;
			var movingObjectTarget:CollisionNode;
			var movingObjectSource:CollisionNode;
			for (movingObjectSource = _movingObjects.head; movingObjectSource; movingObjectSource = movingObjectSource.next)
			{
				sourceRadius = movingObjectSource.collision.radius;
				sourcePosition = movingObjectSource.position.position;
				
				movingObjectTarget = movingObjectSource.next;
				while (movingObjectTarget != null)
				{
					if (Point.distance(sourcePosition, movingObjectTarget.position.position) <=
						(sourceRadius + movingObjectTarget.collision.radius))
					{
						// TODO handle collision!
						trace('collision happen');
					}
					
					// next to compare
					movingObjectTarget = movingObjectTarget.next;
				}
			}
		}

		override public function removeFromGame( game : Game ) : void
		{
			_movingObjects = null;
		}
	}

}
