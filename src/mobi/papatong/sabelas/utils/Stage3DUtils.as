package mobi.papatong.sabelas.utils
{
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
		
		/**
		 * Get the currently active stage3d proxy
		 * @param	nativeStage The current stage
		 * @param	activeStage3D The current stage3D being used by Starling
		 * @return The active stage3dproxy if available. Might return null
		 */
		public static function getActiveStage3DProxy(nativeStage:Stage, activeStage3D:Stage3D):Stage3DProxy
		{
			var tempValue:Stage3DProxy = null;
			
			// check stage3D
			var i:int = 0;
			var len:int = nativeStage.stage3Ds.length;
			var found:Boolean = false;
			while ((i < len) && (!found))
			{
				if (nativeStage.stage3Ds[i] === activeStage3D)
				{
					found = true;
				}
				else
				{
					i++;
				}
			}
			
			// get the stage3d proxy
			if (found)
			{
				trace(DEBUG_TAG, 'has found stage3d index at ' + i);
				
				var stage3DManager:Stage3DManager = Stage3DManager.getInstance(nativeStage);
				if (stage3DManager != null)
				{
					tempValue = stage3DManager.getStage3DProxy(i);
				}
			}
			
			return tempValue;
		}
		
	}

}
