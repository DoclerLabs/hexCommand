package hex.control.trigger.mock;

import hex.control.trigger.MacroCommand;
using tink.CoreApi;

/**
 * ...
 * @author Francis Bourre
 */
class GetUserVOMacro extends MacroCommand<MockUserVO>
{
	public function new() 
	{
		super();
	}
	
	override function _prepare():Void 
	{
		this.add( MockGetUsername ).withHandler( this._onUsername );
		this.add( MockGetUserAge ).withHandler( this._onAge );
		this._setResult( new MockUserVO() );
	}
	
	function _onUsername( outcome ) : Void
	{
		switch( outcome )
		{
			case Success( username ): this._result.username = username;
			case _:
		}
		
	}
	
	function _onAge( outcome ) : Void
	{
		switch( outcome )
		{
			case Success( age ):
				this._result.age = age;
				if ( age >= 18 ) this.add( MockGetUserPrivilege ).withHandler( this._onPrivilege );
			case _:
		}
	}
	
	function _onPrivilege( outcome ) : Void
	{
		switch( outcome )
		{
			case Success( isAdmin ): this._result.isAdmin = isAdmin;
			case _:
		}
	}
}