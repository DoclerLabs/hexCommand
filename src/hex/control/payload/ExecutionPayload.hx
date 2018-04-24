package hex.control.payload;

import hex.di.ClassName;
import hex.di.ClassRef;
import hex.di.MappingName;
import hex.error.NullPointerException;

/**
 * ...
 * @author Francis Bourre
 */

typedef ExecutionPayload = Payload<Dynamic>;
 
class Payload<T>
{
    var _data 		: T;
    var _type 		: ClassRef<T>;
    var _className 	: ClassName;
    var _name 		: MappingName;
	
    public function new( data : T, type : ClassRef<T> = null, ?name : MappingName )
    {
        if ( data == null )
        {
            throw new NullPointerException( "ExecutionPayload data can't be null" );
        }

        this._data 	= data;
		
		if ( type != null )
		{
			this._type 	= type;
		}
		else
		{
			this._type 	= Type.getClass( this._data );
		}
        
        this._name = '' + name;
    }

    public function getData() : T
    {
        return this._data;
    }

    public function getType() : ClassRef<T>
    {
        return this._type;
    }
	
	/**
	 * 
	 * @return 	null when withClassName was not called
	 */
	public function getClassName() : ClassName
    {
        return this._className;
    }

    public function getName() : MappingName
    {
        return this._name;
    }

    public function withName( name : MappingName ) : Payload<T>
    {
        this._name = name;
        return this;
    }
	
	public function withClassName( className : ClassName ) : Payload<T>
    {
        this._className = ('' + className).split( " " ).join( '' );
        return this;
    }
}