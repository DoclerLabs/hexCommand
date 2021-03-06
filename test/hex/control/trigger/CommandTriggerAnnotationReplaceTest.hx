package hex.control.trigger;

import hex.control.trigger.mock.MockAnnotationReplaceController;
import hex.di.IDependencyInjector;
import hex.di.Injector;
import hex.module.ContextModule;
import hex.module.IContextModule;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author 
 */
class CommandTriggerAnnotationReplaceTest 
{
	@Test("Test command trigger and annotation replace in one class")
	public function commandTriggerAnnotationReplaceTest()
	{
		var injector = new Injector();
		var module = new ContextModule();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapToValue( IContextModule, module );
		
		var injectee = new MockInjectee();
		injector.mapToValue(MockInjectee, injectee, "name");
		
		var controller = injector.instantiateUnmapped(MockAnnotationReplaceController);
		
		Assert.isNotNull(controller.mockInjection);
		Assert.equals(injectee, controller.mockInjection);
		
		MockCommandClassWithoutParameters.callCount = 0;
		controller.print();
		Assert.equals( 1, MockCommandClassWithoutParameters.callCount);
		
		controller.printFQCN();
		Assert.equals( 2, MockCommandClassWithoutParameters.callCount);
		
	}
	
}