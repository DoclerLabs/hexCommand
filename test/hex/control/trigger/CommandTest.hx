package hex.control.trigger;

import hex.unittest.assertion.Assert;
import hex.unittest.runner.MethodRunner;
using tink.CoreApi;

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
	public function testCompleteCommandWithParameters() : Void
	{
		MockCommandClassWithParameters.callCount = 0;
		var command = new MockCommandClassWithParameters();
		command.textArg = "hola mundo";
		
		Assert.isTrue( command.isWaiting );
		Assert.isFalse( command.isCompleted );
		Assert.isFalse( command.isFailed );
		Assert.isFalse( command.isCancelled );
		
		var f = function ( message : String )
		{
			Assert.isTrue( command.isCompleted );
			Assert.isFalse( command.isWaiting );
			Assert.isFalse( command.isFailed );
			Assert.isFalse( command.isCancelled );
		
			Assert.equals( 1, MockCommandClassWithParameters.callCount );
			Assert.equals( "hola mundo", message );
			Assert.equals( message, MockCommandClassWithParameters.message );
			Assert.isNull( MockCommandClassWithParameters.ignored, 'Last parameter should be ignored' );
		}
		
		command.handle( 
			function( outcome : Outcome<String, Error> ) 
			{
				switch ( outcome ) 
				{
					case Success( data ): 
						MethodRunner.asyncHandler( f.bind( data ) );
						
					case Failure( failure ): 
					  switch Error.asError( failure ) 
					  {
						case null: throw failure;
						case e: e.throwSelf();
					  }
				}
			} 
		);
		
		command.execute();
	}
}