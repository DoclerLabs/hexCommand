package hex.control.guard;

import hex.control.guard.GuardUtil;
import hex.control.guard.IGuard;
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
class GuardUtilTest
{
	@Test( "Test guard class approval without injector" )
    public function testGuardClassApprovalWithoutInjector() : Void
    {
        Assert.isTrue( GuardUtil.guardsApprove( [ MockApproveGuard ] ), "'GuardUtil.guardsApprove' property should return true" );
        Assert.isFalse( GuardUtil.guardsApprove( [ MockRefuseGuard ] ), "'GuardUtil.guardsApprove' property should return false" );
    }
	
	@Test( "Test mutiple guard classes approval without injector" )
    public function testMultipleGuardClassesApprovalWithoutInjector() : Void
    {
        Assert.isFalse( GuardUtil.guardsApprove( [ MockApproveGuard, MockRefuseGuard ] ), "'GuardUtil.guardsApprove' property should return false" );
    }
	
	@Test( "Test mixed guards approval without injector" )
    public function testMixedGuardsApprovalWithoutInjector() : Void
    {
		var fFalse = function() : Bool { return false; };
		var fTrue = function() : Bool { return true; };
        Assert.isFalse( GuardUtil.guardsApprove( [ MockApproveGuard, fFalse ] ), "'GuardUtil.guardsApprove' property should return false" );
        Assert.isFalse( GuardUtil.guardsApprove( [ fTrue, MockRefuseGuard ] ), "'GuardUtil.guardsApprove' property should return false" );
    }
	
	@Test( "Test guard-class approval with injector" )
    public function testGuardClassApprovalWithInjector() : Void
    {
		var injector = new MockDependencyInjectorForTestingGuard();
        Assert.isTrue( GuardUtil.guardsApprove( [ MockApproveGuard ], injector ), "'GuardUtil.guardsApprove' property should return true" );
        Assert.isFalse( GuardUtil.guardsApprove( [ MockRefuseGuard ], injector ), "'GuardUtil.guardsApprove' property should return false" );
    }
}

private class MockApproveGuard implements IGuard
{
	public function new()
	{
		
	}
	
	public function approve() : Bool
	{
		return true;
	}
}

private class MockRefuseGuard implements IGuard
{
	public function new()
	{
		
	}
	
	public function approve() : Bool
	{
		return false;
	}
}

private class MockDependencyInjectorForTestingGuard extends MockDependencyInjector
{
	public function new()
	{
		
	}
	
	override public function instantiateUnmapped<T>( type : Class<Dynamic> ) : T 
	{
		return Type.createInstance( type, [] );
	}
}

private class MockDependencyInjector implements IDependencyInjector
{
	//
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