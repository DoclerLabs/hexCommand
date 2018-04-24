package hex.control.payload;

import hex.control.payload.ExecutionPayload;
import hex.di.ClassName;
import hex.di.ClassRef;
import hex.di.MappingName;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class ExecutionPayloadTest
{
	var _data 				: MockData;
	var _executionPayload 	: ExecutionPayload;

    @Before
    public function setUp() : Void
    {
        this._data 				= new MockData();
        this._executionPayload 	= { data: this._data, type: IMockData, name: "name", className: null };
    }

    @After
    public function tearDown() : Void
    {
        this._data 				= null;
        this._executionPayload 	= null;
    }
	
	@Test( "Test constructor" )
    public function testConstructor() : Void
    {
        Assert.equals( this._data, this._executionPayload.getData(), "data should be the same" );
		
		var classRef : ClassRef<IMockData>= this._executionPayload;
		var className : ClassName = this._executionPayload;
		var mappingName : MappingName = this._executionPayload;
		
        Assert.equals( IMockData, classRef, "type should be the same" );
        Assert.equals( "name", mappingName, "name should be the same" );
		Assert.isNull( className, "class name should be null when it's not setted through accessor" );
	}

	/*@Test( "Test overwriting name property" )
    public function testOverwritingName() : Void
    {
		this._executionPayload.withName( "anotherName" );
		var mappingName : MappingName = this._executionPayload;
		
        Assert.notEquals( "name", mappingName, "name should not be the same" );
        Assert.equals( "anotherName", mappingName, "name should be the same" );
    }*/
	
	@Test( "Test passing no name parameter to constructor" )
    public function testNoNameParameterToConstructor() : Void
    {
		var executionPayload : ExecutionPayload = { data: this._data, type: IMockData, name: null, className: null };
		var mappingName : MappingName = executionPayload;
        Assert.equals( "", mappingName, "name should be empty String" );
    }
	
	@Test( "Test constructor without type" )
    public function testConstructorWithoutType() : Void
    {
		this._executionPayload 	= { data: 'test', type: null, name: null, className: null };
		var classRef : ClassRef<String> = this._executionPayload;
		var mappingName : MappingName = this._executionPayload;
		
        Assert.equals( "test", this._executionPayload.getData(), "data should be the same" );
        Assert.equals( String, classRef, "type should be the same" );
    }
	
	@Test( "Test constructor without type with name" )
    public function testConstructorWithoutTypeWithName() : Void
    {
		this._executionPayload 	= { data: this._data, type: null, name: 'name', className: null };
		var classRef : ClassRef<String> = this._executionPayload;
		var mappingName : MappingName = this._executionPayload;
		
        Assert.equals( this._data, this._executionPayload.getData(), "data should be the same" );
        Assert.equals( MockData, classRef, "type should be the same" );
        Assert.equals( "name", mappingName, "name should be the same" );
    }
	
	@Test( "Test setting class name" )
    public function testSettingClassName() : Void
    {
		var data = new MockDataWithGeneric<String>();
		this._executionPayload 	= { data: data, type: null, name: 'name', className: "hex.control.payload.MockDataWithGeneric<String>" };
		var classRef : ClassRef<MockDataWithGeneric<String>> = this._executionPayload;
		var className : ClassName = this._executionPayload;
		var mappingName : MappingName = this._executionPayload;
		
        Assert.equals( data, this._executionPayload.getData(), "data should be the same" );
        Assert.equals( MockDataWithGeneric, classRef, "type should be the same" );
        Assert.equals( "hex.control.payload.MockDataWithGeneric<String>", className, "class name should be the same" );
        Assert.equals( "name", mappingName, "name should be the same" );
    }
}

private class MockData implements IMockData
{
	public function new()
	{
		
	}
}