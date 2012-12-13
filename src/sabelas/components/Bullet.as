package sabelas.components
{
	/**
	 * Marker component for a bullet
	 * @author Abiyasa
	 */
	public class Bullet
	{
		public var lifeRemaining:Number;
		public var isEnemyBullet:Boolean;
		
		public function Bullet(isEnemyBullet:Boolean, lifeTime:Number)
		{
			lifeRemaining = lifeTime;
			this.isEnemyBullet = isEnemyBullet;
		}
		
	}

}
