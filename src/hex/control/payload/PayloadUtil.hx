package hex.control.payload;

import hex.di.ClassName;
import hex.di.IBasicInjector;

using hex.error.Error;

/**
 * ...
 * @author Francis Bourre
 */
class PayloadUtil
{
	/** @private */ function new() throw new PrivateConstructorException();
	
	/**
	 * Map payloads
	 * @param	payload
	 */
    static public function mapPayload( payloads : Array<ExecutionPayload>, injector : IBasicInjector ) : Void
    {
        for ( payload in payloads ) 
		{
			var className : ClassName = payload;
			if ( className != null )
			{
				injector.mapClassNameToValue( className, payload.getData(), payload );
			}
			else
			{
				injector.mapToValue( payload, payload.getData(), payload );
			}
		}
    }

	/**
	 * Unmap payloads
	 * @param	payloads
	 */
    static public function unmapPayload( payloads : Array<ExecutionPayload>, injector : IBasicInjector ) : Void
    {
        for ( payload in payloads ) 
		{
			var className : ClassName = payload;
			if ( className != null )
			{
				injector.unmapClassName( className, payload );
			}
			else 
			{
				injector.unmap( payload, payload );
			}
		}
    }
}