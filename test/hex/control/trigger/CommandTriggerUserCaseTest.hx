package hex.control.trigger;

import haxe.Timer;
import hex.control.trigger.mock.*;
import hex.di.Dependency;
import hex.di.IDependencyInjector;
import hex.di.Injector;
import hex.module.ContextModule;
import hex.module.IContextModule;
import hex.unittest.assertion.Assert;
import hex.unittest.runner.MethodRunner;

using hex.di.util.InjectorUtil;
using tink.CoreApi;

/**
 * ...
 * @author Francis Bourre
 */
class CommandTriggerUserCaseTest 
{
	var _injector   		: Injector;
	var _controller 		: MockUserController;

    @Before
    public function setUp() : Void
    {
		this._injector = new Injector();
		this._injector.mapToValue( IDependencyInjector, this._injector );
		this._injector.mapToValue( IContextModule, new ContextModule() );
		
        this._controller = this._injector.instantiateUnmapped( MockUserController );
    }

    @After
    public function tearDown() : Void
    {
		this._injector 			= null;
        this._controller 		= null;
    }
	
	@Async( "test MacroCommand with mapping" )
	public function testMacroCommandWithMapping() : Void
	{
		var ageProvider = function() return 46;
		
		this._controller.getUserVO( ageProvider ).handle( 
		
			function( outcome )
			{
				switch( outcome )
				{
					case Success( userVO ): MethodRunner.asyncHandler( this._onGetUser.bind( userVO ) );
					case Failure( error ): trace( error );
				}
			}
		);
	}
	
	function _onGetUser( userVO : MockUserVO ) : Void
	{
		Assert.equals( 'John Doe', userVO.username );
		Assert.equals( 46, userVO.age );
		Assert.equals( true, userVO.isAdmin );
	}
	
	@Async( "test MacroCommand without mapping" )
	public function testMacroCommandWithoutMapping() : Void
	{
		var service = function( cityName ) 
			return Future.async( 
				function( set ) Timer.delay( function() set( Success(cityName == 'Luxembourg'?20:0) ), 50 ) 
		);

		this._injector.mapDependencyToValue( new Dependency<TemperatureService>(), service );
		
		this._controller.getTemperature( 'Luxembourg' ).handle( 

			function( outcome )
			{
				switch( outcome )
				{
					case Success( temperature ): MethodRunner.asyncHandler( this._onGetTemperature.bind( temperature ) );
					case Failure( error ): trace( error );
				}
			}
		);	
	}
	
	function _onGetTemperature( temperature : Int ) : Void
	{
		Assert.equals( 20, temperature );
	}
}