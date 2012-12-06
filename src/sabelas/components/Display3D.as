package sabelas.components
{
	import away3d.containers.ObjectContainer3D;
	
	/**
	 * Component for displayable 3D object
	 *
	 * @author Abiyasa
	 */
	public class Display3D
	{
		public var object3D:ObjectContainer3D = null;
		
		public function Display3D(object3D:ObjectContainer3D)
		{
			this.object3D = object3D;
		}
	}
}
