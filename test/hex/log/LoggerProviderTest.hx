package hex.log;

import hex.di.Injector;
import hex.di.provider.LoggerProvider;
import hex.log.mock.MockLoggerInjectee;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author ...
 */
class LoggerProviderTest 
{
	public function new() {}
	
	@Test("Test dependency provider")
	public function testDependencyProvider()
	{
		var provider = new LoggerProvider( null );
		var resultLogger = provider.getResult( null, MockLoggerInjectee );
		
		Assert.equals( "hex.log.mock.MockLoggerInjectee", resultLogger.getName(), "Logger name must be same as the injectee class name" );
	}
	
	@Test("Test dependency provider in injector")
	public function testDependencyProviderInInjector()
	{
		var injector = new Injector();
		injector.map( ILogger ).toProvider( new LoggerProvider( null ) );
		var injectee = injector.instantiateUnmapped( MockLoggerInjectee );
		
		Assert.equals( "hex.log.mock.MockLoggerInjectee", injectee.logger.getName(), "Logger name must be same as the injectee class name" );
	}
	
	@Test("Test dependency provider fallback")
	public function testFallbackLogger()
	{
		var logger 			= LogManager.getLogger( "fallback" );
		var provider 		= new LoggerProvider( logger );
		var resultLogger 	= provider.getResult( null, null );
		
		Assert.equals( logger, resultLogger, "Loggers must be the same" );
	}
	
	@Test("Test dependency provider fallback in injector")
	public function testFallbackLoggerInInjector()
	{
		var injector = new Injector();
		var logger = LogManager.getLogger("fallback");
		injector.map( ILogger ).toProvider( new LoggerProvider( logger ) );

		Assert.equals( logger, injector.getInstance( ILogger ), "Loggers must be the same" );
	}
}