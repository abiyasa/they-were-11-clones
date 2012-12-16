package sabelas.components
{
	import ash.core.Entity;
	import flash.geom.Vector3D;
	
	/**
	 * Component for camera stalking on a target
	 *
	 * @author Abiyasa
	 */
	public class StalkingCamera
	{
		public var position:Vector3D;
		public var target:Entity;
		
		protected var _targetPosition:Position;
		public function get targetPosition():Position { return _targetPosition; }
		
		public function StalkingCamera(posX:Number, posY:Number, posZ:Number, target:Entity)
		{
			this.position = new Vector3D(posX, posY, posZ);
			this.target = target;
			
			_targetPosition = target.get(Position);
		}
		
	}

}
