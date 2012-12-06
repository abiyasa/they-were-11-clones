package sabelas.utils
{
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import flash.display.Stage;
	import flash.display.Stage3D;
	
	/**
	 * Util class for Stage3D related thingy
	 * @author Abiyasa
	 */
	public class Stage3DUtils
	{
		public static const DEBUG_TAG:String = 'Stage3DUtils';
		
		// singleton
		private static var _instance:Stage3DUtils;
		public static function getInstance():Stage3DUtils
		{
			if (Stage3DUtils._instance == null)
			{
				Stage3DUtils._instance = new Stage3DUtils();
			}
			return Stage3DUtils._instance;
		}
		
		// store current active Away3D's view3D
		public var currentView3D:View3D;
		
		// store current active stage3Dproxy
		public var currentStage3DProxy:Stage3DProxy;
	}

}
