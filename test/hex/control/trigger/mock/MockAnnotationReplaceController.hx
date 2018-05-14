package hex.control.trigger.mock;

import hex.annotation.IAnnotationReplace;
import hex.control.async.Nothing;
import hex.control.trigger.ICommandTrigger;
import hex.control.trigger.MockCommandClassWithoutParameters;

using tink.CoreApi;

/**
 * ...
 * @author 
 */
class MockAnnotationReplaceController implements ICommandTrigger implements IAnnotationReplace
{

	static var NAME = "name";
	
	public function new() 
	{
	}
	
	@Inject(NAME)
	public var mockInjection:MockInjectee;
	
	@Map( hex.control.trigger.MockCommandClassWithoutParameters )
	public function printFQCN() : Promise<Nothing>;
	
	@Map( MockCommandClassWithoutParameters )
	public function print() : Promise<Nothing>;
	
}

class MockInjectee
{
	public function new(){}
}