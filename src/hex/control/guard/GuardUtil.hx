package hex.control.guard;

import hex.di.IBasicInjector;
import hex.error.PrivateConstructorException;

/**
 * ...
 * @author Francis Bourre
 */
class GuardUtil
{
	/** @private */
	function new() 
	{
		throw new PrivateConstructorException();
	}
	
	/**
	 * Approve guards
	 * @param	guards
	 * @param	injector
	 * @return
	 */
    static public function guardsApprove( ?guards : Array<Dynamic>, ?injector : IBasicInjector ) : Bool
    {
        if ( guards != null )
        {
			var b = true;
			
            for ( guard in guards )
            {
                if ( Std.is( guard, Class ) )
                {
                    var scope = injector != null ? cast( injector.instantiateUnmapped( guard ), IGuard ) : cast( Type.createInstance( guard, [] ), IGuard );
					b = scope.approve();
                }
				else if ( Reflect.hasField( guard, "approve" ) )
				{
                    guard = Reflect.field( guard, "approve" );
                }

                if ( Reflect.isFunction( guard ) )
                {
                    b = guard();
                }
				
				if ( !b )
				{
					return false;
				}
            }
        }

        return true;
    }
}