package mobi.papatong.sabelas.components
{
	/**
	 * Component for marking that an entity belongs to hero clones group
	 *
	 * @author Abiyasa
	 */
	public class HeroClone
	{
		public var isLeader:Boolean = false;
		
		// Total repulsive & attraction force, calculated by HeroClonePositioningSystem
		// TODO should separate to a component
		protected var _cloneForceX:Number;
		public function get cloneForceX():Number
		{
			return _cloneForceX;
		}
		public function set cloneForceX(value:Number):void
		{
			_cloneForceX = value;
			if (!_cloneForceChanged)
			{
				_cloneForceChanged = true;
			}
		}
		
		// Total repulsive & attraction force, calculated by HeroClonePositioningSystem
		protected var _cloneForceY:Number;
		public function get cloneForceY():Number
		{
			return _cloneForceY;
		}
		public function set cloneForceY(value:Number):void
		{
			_cloneForceY = value;
			if (!_cloneForceChanged)
			{
				_cloneForceChanged = true;
			}
		}
		
		private var _cloneForceChanged:Boolean;
		public function get cloneForceChanged():Boolean
		{
			return _cloneForceChanged;
		}
		public function set cloneForceChanged(value:Boolean):void
		{
			_cloneForceChanged = value;
		}
		
		
		public function HeroClone(isLeader:Boolean = false)
		{
			this.isLeader = isLeader;
			resetCloneForce();
		}
		
		// Resets the clone attract & repulse force
		public function resetCloneForce():void
		{
			_cloneForceX = 0.0;
			_cloneForceY = 0.0;
			_cloneForceChanged = false;
		}
		
		/**
		 * Adds clone force value to the current
		 *
		 * @param	forceX
		 * @param	forceY
		 */
		public function addForce(forceX:Number, forceY:Number):void
		{
			_cloneForceX += forceX;
			_cloneForceY += forceY;
			if (!_cloneForceChanged)
			{
				_cloneForceChanged = true;
			}
		}
		
	}

}
