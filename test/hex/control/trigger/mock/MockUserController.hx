package hex.control.trigger.mock;

import hex.control.trigger.mock.MockUserVO;

using tink.CoreApi;

/**
 * ...
 * @author Francis Bourre
 */
class MockUserController implements ICommandTrigger
{
	@Map( GetUserVOMacro )
	public function getUserVO( ageProvider : Void->UInt ) : Promise<MockUserVO>;
	
	public function getTemperature( cityName : String ) : Promise<Int>
	{
		@Inject
		var temperatureService : TemperatureService;
		return temperatureService( cityName );
	}

	public function new()
	{

	}
}