package mobi.papatong.sabelas.graphics
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.WireframeSphere;
	
	/**
	 * Dummy sphere
	 * @author Abiyasa
	 */
	public class DummySphere extends ObjectContainer3D
	{
		
		public function DummySphere(size:int = 0, color:uint = 0xFFFFFF, wireframe:Boolean = true)
		{
			super();
			
			// default size
			if (size <= 0)
			{
				size = 10;
			}
			
			if (wireframe)
			{
				this.addChild(new WireframeSphere(size, 16, 12, color));
			}
			else
			{
				var material:ColorMaterial = new ColorMaterial(color);
				this.addChild(new Mesh(new SphereGeometry(size), material));
			}
		}
		
	}

}
