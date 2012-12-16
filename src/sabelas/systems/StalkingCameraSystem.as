package sabelas.systems
{
	import ash.tools.ListIteratingSystem;
	import away3d.cameras.Camera3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import sabelas.components.Position;
	import sabelas.components.StalkingCamera;
	import sabelas.nodes.StalkingCameraNode;
	
	/**
	 * System to process stalking camera
	 *
	 * @author Abiyasa
	 */
	public class StalkingCameraSystem extends ListIteratingSystem
	{
		protected var _camera:Camera3D;
		protected var _targetPosition:Vector3D = new Vector3D();
		
		protected var CAMERA_DISTANCE_Z:int = 1000;
		
		public function StalkingCameraSystem(camera3D:Camera3D)
		{
			super(StalkingCameraNode, updateNode);
			_camera = camera3D;
		}
		
		private function updateNode(node:StalkingCameraNode, time:Number):void
		{
			// update camera node based on target position
			// TODO should have speed & camera acceleration
			var cameraPosition:Vector3D = node.camera.position;
			var targetPosition:Point = node.camera.targetPosition.position;
			cameraPosition.x = targetPosition.x;
			cameraPosition.z = targetPosition.y - CAMERA_DISTANCE_Z;
			
			// update the view's camera based on camera node
			_camera.position = cameraPosition;
			_targetPosition.setTo(targetPosition.x, targetPosition.y, 0)
			_camera.lookAt(_targetPosition);
		}
		
	}

}