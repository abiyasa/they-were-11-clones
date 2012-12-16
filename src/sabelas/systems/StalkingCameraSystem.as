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
		
		public function StalkingCameraSystem(camera3D:Camera3D)
		{
			super(StalkingCameraNode, updateNode);
			_camera = camera3D;
		}
		
		private function updateNode(node:StalkingCameraNode, time:Number):void
		{
			// TODO update camera node based on target position
			
			// update the view's camera based on camera node
			var cameraPosition:Vector3D = node.camera.position;
			_camera.position = cameraPosition;
			var targetPosition:Point = node.camera.targetPosition.position;
			_targetPosition.setTo(targetPosition.x, targetPosition.y, 0)
			_camera.lookAt(_targetPosition);
		}
		
	}

}