package hex.control.payload;

import hex.control.payload.ExecutionPayload;
import hex.control.payload.PayloadUtil;
import hex.di.ClassName;
import hex.di.ClassRef;
import hex.di.IDependencyInjector;
import hex.di.IInjectorAcceptor;
import hex.di.IInjectorListener;
import hex.di.MappingName;
import hex.di.provider.IDependencyProvider;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class PayloadUtilTest
{
	@Test( "test constructor is private" ) 
	public function testPrivateConstructor() : Void
	{
		Assert.constructorIsPrivate( PayloadUtil );
	}
	
	@Test( "Test mapping" )
    public function testMapping() : Void
    {
		var injector 					= new MockDependencyInjectorForMapping();
		
		var mockImplementation 			= new MockImplementation( "mockImplementation" );
		var anotherMockImplementation 	= new MockImplementation( "anotherMockImplementation" );
		
		var mockPayload 				= { data: mockImplementation, type: IMockType, name: "mockPayload", className: null };
		var stringPayload 				= { data: "test", type: String, name: "stringPayload", className: null };
		var anotherMockPayload 			= { data: anotherMockImplementation, type: IMockType, name: "anotherMockPayload", className: null };
		
		var payloads 					: Array<ExecutionPayload> 	= [ mockPayload, stringPayload, anotherMockPayload ];
		PayloadUtil.mapPayload( payloads, injector );
		
        Assert.deepEquals( 	[[mockImplementation, IMockType, "mockPayload"], ["test", String, "stringPayload"], [anotherMockImplementation, IMockType, "anotherMockPayload"] ], 
									injector.mappedPayloads,
									"'CommandExecutor.mapPayload' should map right values" );
    }
	
	@Test( "Test unmapping" )
    public function testUnmapping() : Void
    {
		var injector 					= new MockDependencyInjectorForMapping();
		
		var mockImplementation 			= new MockImplementation( "mockImplementation" );
		var anotherMockImplementation 	= new MockImplementation( "anotherMockImplementation" );
		
		var mockPayload 				= { data: mockImplementation, type: IMockType, name: "mockPayload", className: null };
		var stringPayload 				= { data: "test", type: String, name: "stringPayload", className: null };
		var anotherMockPayload 			= { data: anotherMockImplementation, type: IMockType, name: "anotherMockPayload", className: null };
		
		var payloads 					: Array<ExecutionPayload> 	= [ mockPayload, stringPayload, anotherMockPayload ];
		PayloadUtil.unmapPayload( payloads, injector );
		
        Assert.deepEquals( 	[[IMockType, "mockPayload"], [String, "stringPayload"], [IMockType, "anotherMockPayload"] ], 
									injector.unmappedPayloads,
									"'CommandExecutor.mapPayload' should unmap right values" );
    }
	
	@Test( "Test mapping with class name" )
    public function testMappingWithClassName() : Void
    {
		var injector 					= new MockDependencyInjectorForMapping();
		
		var mockImplementation 			= new MockImplementation( "mockImplementation" );
		var anotherMockImplementation 	= new MockImplementation( "anotherMockImplementation" );
		
		var mockPayload 				= { data: mockImplementation, type: IMockType, name: "mockPayload", className: 'MockImplementation' };
		var stringPayload 				= { data: "test", type: String, name: "stringPayload", className: null };
		var anotherMockPayload 			= { data: anotherMockImplementation, type: IMockType, name: "anotherMockPayload", className: 'MockImplementation' };
		
		var payloads 					: Array<ExecutionPayload> 	= [ mockPayload, stringPayload, anotherMockPayload ];
		PayloadUtil.mapPayload( payloads, injector );
		
        Assert.deepEquals( 	[[mockImplementation, 'MockImplementation', "mockPayload"], ["test", String, "stringPayload"], [anotherMockImplementation, 'MockImplementation', "anotherMockPayload"] ], 
									injector.mappedPayloads,
									"'CommandExecutor.mapPayload' should map right values" );
    }
	
	@Test( "Test unmapping with class name" )
    public function testUnmappingWithClassName() : Void
    {
		var injector 					= new MockDependencyInjectorForMapping();
		
		var mockImplementation 			= new MockImplementation( "mockImplementation" );
		var anotherMockImplementation 	= new MockImplementation( "anotherMockImplementation" );
		
		var mockPayload 				= { data: mockImplementation, type: IMockType, name: "mockPayload", className: 'MockImplementation' };
		var stringPayload 				= { data: "test", type: String, name: "stringPayload", className: null };
		var anotherMockPayload 			= { data: anotherMockImplementation, type: IMockType, name: "anotherMockPayload", className: 'MockImplementation' };
		
		var payloads 					: Array<ExecutionPayload> 	= [ mockPayload, stringPayload, anotherMockPayload ];
		PayloadUtil.unmapPayload( payloads, injector );
		
        Assert.deepEquals( 	[['MockImplementation', "mockPayload"], [String, "stringPayload"], ['MockImplementation', "anotherMockPayload"] ], 
									injector.unmappedPayloads,
									"'CommandExecutor.mapPayload' should unmap right values" );
    }
}

private class MockDependencyInjectorForMapping extends MockDependencyInjector
{
	public var mappedPayloads 						: Array<Array<Dynamic>> = [];
	public var unmappedPayloads 					: Array<Array<Dynamic>> = [];
	
	override public function mapToValue<T>( clazz : ClassRef<T>, value : T, ?name : MappingName ) : Void
	{
		this.mappedPayloads.push( [ value, clazz, name ] );
	}
	
	override public function unmap<T>( type : ClassRef<T>, ?name : MappingName ) : Void 
	{
		this.unmappedPayloads.push( [ type, name ] );
	}
	
	override public function mapClassNameToValue<T>( className : ClassName, value : T, ?name : MappingName ) : Void
	{
		this.mappedPayloads.push( [ value, className, name ] );
	}
	
	override public function unmapClassName( className : ClassName, ?name : MappingName ) : Void
	{
		this.unmappedPayloads.push( [ className, name ] );
	}
}

private class MockDependencyInjector implements IDependencyInjector
{
	public function new() { }
	
	public function hasMapping<T>( type : ClassRef<T>, ?name : MappingName ) : Bool
	{
		return false;
	}
	
	public function hasDirectMapping<T>( type : ClassRef<T>, ?name : MappingName ) : Bool
	{
		return false;
	}
	
	public function satisfies<T>( type : ClassRef<T>, ?name : MappingName ) : Bool
	{
		return false;
	}
	
	public function injectInto( target : IInjectorAcceptor ) : Void
	{
		
	}
	
	public function getInstance<T>( type : ClassRef<T>, ?name : MappingName, targetType : Class<Dynamic> = null ) : T
	{
		return null;
	}
	
	public function getInstanceWithClassName<T>( className : ClassName, ?name : MappingName, targetType : Class<Dynamic> = null, shouldThrowAnError : Bool = true ) : T
	{
		return null;
	}
	
	public function getOrCreateNewInstance<T>( type : Class<T> ) : T
	{
		return null;
	}
	
	public function instantiateUnmapped<T>( type : Class<T> ) : T
	{
		return null;
	}
	
	public function destroyInstance<T>( instance : T ) : Void
	{
		
	}
	
	public function mapToValue<T>( clazz : ClassRef<T>, value : T, ?name : MappingName ) : Void
	{
		
	}
	
	public function mapToType<T>( clazz : ClassRef<T>, type : Class<T>, ?name : MappingName ) : Void
	{
		
	}
	
	public function mapToSingleton<T>( clazz : ClassRef<T>, type : Class<T>, ?name : MappingName ) : Void
	{
		
	}
	
	public function unmap<T>( type : ClassRef<T>, ?name : MappingName ) : Void 
	{
		
	}

	public function addListener( listener: IInjectorListener ) : Bool
	{
		return false;
	}

	public function removeListener( listener: IInjectorListener ) : Bool
	{
		return false;
	}
	
	public function getProvider<T>( className : ClassName, ?name : MappingName ) : IDependencyProvider<T>
	{
		return null;
	}
	
	public function mapClassNameToValue<T>( className : ClassName, value : T, ?name : MappingName ) : Void
	{
		
	}

    public function mapClassNameToType<T>( className : ClassName, type : Class<T>, ?name : MappingName ) : Void
	{
		
	}

    public function mapClassNameToSingleton<T>( className : ClassName, type : Class<T>, ?name : MappingName ) : Void
	{
		
	}
	
	public function unmapClassName( className : ClassName, ?name : MappingName ) : Void
	{
		
	}
}