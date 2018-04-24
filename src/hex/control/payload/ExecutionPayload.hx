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

abstract Payload<T>( {data: T, type: ClassRef<T>, name: MappingName, className: ClassName} ) 
{
	public function new( data: T, type: ClassRef<T> = null, ?name: MappingName )
		this = { data: data, type: type, name: '' + name, className: null };
		
	public function getData() return this.data;

    public function getType() return this.type == null ? Type.getClass( this.data ) : this.type;

	/**
	 * @return 	null when withClassName was not called
	 */
	public function getClassName() return this.className;

    public function getName() return this.name;

    public function withName( name : MappingName ) : Payload<T>
    {
        this.name = name;
        return cast this;
    }
	
	public function withClassName( className : ClassName ) : Payload<T>
    {
        this.className = ('' + className).split( " " ).join( '' );
        return cast this;
    }
}