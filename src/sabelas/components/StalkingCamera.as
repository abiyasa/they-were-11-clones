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
		public var targetPosition:Position;
		
		public function StalkingCamera(posX:Number, posY:Number, posZ:Number, targetPosition:Position)
		{
			this.position = new Vector3D(posX, posY, posZ);
			this.targetPosition = targetPosition;
		}
		
	}

}
