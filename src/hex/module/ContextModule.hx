package hex.module;

import hex.config.stateful.IStatefulConfig;
import hex.config.stateless.IStatelessConfig;
import hex.core.IApplicationContext;
import hex.di.ClassRef;
import hex.di.Dependency;
import hex.di.IBasicInjector;
import hex.di.IDependencyInjector;
import hex.di.Injector;
import hex.di.MappingName;
import hex.di.provider.LoggerProvider;
import hex.di.util.InjectorUtil;
import hex.log.ILogger;
import hex.log.LogManager;
import hex.module.IContextModule;

using hex.error.Error;

/**
 * ...
 * @author Francis Bourre
 */
class ContextModule implements IContextModule
{
	var _injector 				: Injector;
	var _logger 				: ILogger;

	public function new()
	{
		this._injector = new Injector();
		this._injector.mapToValue( IBasicInjector, this._injector );
		this._injector.mapToValue( IDependencyInjector, this._injector );

		this._injector.mapToValue( IContextModule, this );
		
		this._logger = LogManager.getLoggerByInstance( this );
		this._injector.map( ILogger ).toProvider( new LoggerProvider( this._logger ) );
	}
			
	/**
	 * Initialize the module
	 */
	@:final 
	public function initialize( context : IApplicationContext ) : Void
	{
		if ( !this.isInitialized )
		{
			this._onInitialisation();
			this.isInitialized = true;
		}
		else
		{
			throw new IllegalStateException( "initialize can't be called more than once. Check your code." );
		}
	}

	/**
	 * Accessor for module initialisation state
	 * @return <code>true</code> if the module is initialized
	 */
	@:isVar public var isInitialized( get, null ) : Bool;
	@:final 
	function get_isInitialized() : Bool
	{
		return this.isInitialized;
	}

	/**
	 * Accessor for module release state
	 * @return <code>true</code> if the module is released
	 */
	@:isVar public var isReleased( get, null ) : Bool;
	@:final 
	public function get_isReleased() : Bool
	{
		return this.isReleased;
	}

	/**
	 * Release this module
	 */
	@:final 
	public function release() : Void
	{
		if ( !this.isReleased )
		{
			this.isReleased = true;
			this._onRelease();
			
			this._injector.destroyInstance( this );
			this._injector.teardown();
			
			this._logger = null;
		}
		else
		{
			throw new IllegalStateException( this + ".release can't be called more than once. Check your code." );
		}
	}
	
	public function getInjector() : IDependencyInjector
	{
		return this._injector;
	}
	
	public function getLogger() : ILogger
	{
		return this._logger;
	}
	
	/**
	 * Override and implement
	 */
	function _onInitialisation() : Void
	{

	}

	/**
	 * Override and implement
	 */
	function _onRelease() : Void
	{

	}
	
	/**
	 * Accessor for dependecy injector
	 * @return <code>IDependencyInjector</code> used by this module
	 */
	function _getDependencyInjector() : IDependencyInjector
	{
		return this._injector;
	}
	
	/**
	 * Add collection of module configuration classes that 
	 * need to be executed before initialisation's end
	 * @param	configurations
	 */
	function _addStatelessConfigClasses( configurations : Array<Class<IStatelessConfig>> ) : Void
	{
		for ( configurationClass in configurations )
		{
			var config : IStatelessConfig = this._injector.instantiateUnmapped( configurationClass );
			config.configure();
		}
	}
	
	/**
	 * Add collection of runtime configurations that 
	 * need to be executed before initialisation's end
	 * @param	configurations
	 */
	function _addStatefulConfigs( configurations : Array<IStatefulConfig> ) : Void
	{
		for ( configuration in configurations )
		{
			configuration.configure( this._injector, this );
		}
	}
	
	/**
	 * 
	 */
	function _get<T>( type : ClassRef<T>, ?name : MappingName ) : T
	{
		return this._injector.getInstance( type, name );
	}
	
	/**
	 * 
	 */
	function _map<T>( tInterface : ClassRef<T>, ?tClass : Class<T>,  ?name : MappingName, asSingleton : Bool = false ) : Void
	{
		if ( asSingleton )
		{
			this._injector.mapToSingleton( tInterface, tClass != null ? tClass : tInterface, name );
		}
		else
		{
			this._injector.mapToType( tInterface, tClass != null ? tClass : tInterface, name );
		}
	}
	
	/**
	 * 
	 */
	macro public function _getDependency<T>( ethis, clazz : ExprOf<Dependency<T>>, ?id : ExprOf<String> ) : ExprOf<T>
	{
		var classRepresentation = InjectorUtil._getStringClassRepresentation( clazz );
		var classReference = InjectorUtil._getClassReference( clazz );
		var ct = InjectorUtil._getComplexType( clazz );
		
		var e = macro @:pos( ethis.pos ) $ethis._injector.getInstanceWithClassName( $v { classRepresentation }, $id );
		return 
		{
			expr: ECheckType
			( 
				e,
				ct
			),
			pos:ethis.pos
		};
	}
}