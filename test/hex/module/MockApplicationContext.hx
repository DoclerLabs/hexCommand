package hex.module;

import hex.core.IApplicationContext;
import hex.core.ICoreFactory;
import hex.di.IDependencyInjector;
import hex.domain.Domain;
import hex.log.ILogger;

/**
 * ...
 * @author Francis Bourre
 */
class MockApplicationContext implements IApplicationContext
{
	public function new() 
	{
		
	}
	
	public function getName() : String 
	{
		return null;
	}
	
	public function getDomain() : Domain 
	{
		return null;
	}
	
	public function getCoreFactory() : ICoreFactory 
	{
		return null;
	}
	
	public function getInjector() : IDependencyInjector 
	{
		return null;
	}
	
	public var isInitialized( get, null ) : Bool;
	function get_isInitialized() : Bool 
	{
		return isInitialized;
	}
	
	public var isReleased( get, null ) : Bool;
	function get_isReleased() : Bool 
	{
		return isReleased;
	}
	
	public function initialize( context : IApplicationContext ) : Void 
	{
		
	}
	
	public function release():Void 
	{
		
	}
	
	public function getLogger() : ILogger 
	{
		return null;
	}
}