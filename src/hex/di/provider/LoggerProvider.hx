package hex.di.provider;

import hex.di.IDependencyInjector;
import hex.log.ILogger;
import hex.log.LogManager;

/**
 * ...
 * @author ...
 */
class LoggerProvider implements IDependencyProvider<ILogger> 
{
	var fallbackLogger:ILogger;

	public function new(fallbackLogger:ILogger) 
	{
		this.fallbackLogger = fallbackLogger;
	}
	
	public function destroy() : Void 
	{
	}
	
	public function getResult( injector : IDependencyInjector, target : Class<Dynamic> ) : ILogger 
	{
		return if ( target == null ) fallbackLogger
		else LogManager.getLoggerByClass( target );
	}
}