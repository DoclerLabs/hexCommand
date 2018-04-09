package hex.control.trigger;

import hex.unittest.assertion.Assert;
import hex.unittest.runner.MethodRunner;

/**
 * ...
 * @author Francis Bourre
 */
class CommandTest 
{
	@Test
	public function testCommandWithoutParameters() : Void
	{
		MockCommandClassWithoutParameters.callCount = 0;
		var command = new MockCommandClassWithoutParameters();
		command.execute();
		Assert.equals( 1, MockCommandClassWithoutParameters.callCount );
	}
	
	@Async
	public function testCommandWithParameters() : Void
	{
		MockCommandClassWithParameters.callCount = 0;
		var command = new MockCommandClassWithParameters();
		command.textArg = "hola mundo";
		
		var f = function ( message : String )
		{
			Assert.equals( 1, MockCommandClassWithParameters.callCount );
			Assert.equals( "hola mundo", message );
			Assert.equals( message, MockCommandClassWithParameters.message );
			Assert.isNull( MockCommandClassWithParameters.ignored, 'Last parameter should be ignored' );
		}
		
		command.onComplete( 
			function( message : String ) 
			{
				MethodRunner.asyncHandler( f.bind( message ) );
			} 
		);
		
		command.execute();
	}
}