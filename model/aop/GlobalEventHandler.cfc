/*
	Copyright (c) 2012, Simon Bingham (http://www.simonbingham.me.uk/)
	
	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
	modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
	is furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

component implements="cfide.orm.IEventHandler"{

	/**
	 * I am called before injecting property values into a newly loaded entity instance
	 */
	void function preLoad( any entity ){}
	
	/**
	 * I am called after an entity is fully loaded
	 */
	void function postLoad( any entity ){}

	/**
	 * I am called before inserting the entity into the database
	 */
	void function preInsert( any entity ){
		var timestamp = now();
		if( StructKeyExists( arguments.entity, "setCreated" ) ) arguments.entity.setCreated( timestamp );
		if( StructKeyExists( arguments.entity, "setUpdated" ) ) arguments.entity.setUpdated( timestamp );
	}   
	
	/**
	 * I am called after the entity is inserted into the database 
	 */
	void function postInsert( any entity ){}
    
	/**
	 * I am called before the entity is updated in the database
	 */
	void function preUpdate( any entity, struct oldData ){
		if( StructKeyExists( arguments.entity, "setUpdated" ) ) arguments.entity.setUpdated( now() );
	}    
	
	/**
	 * I am called after the entity is updated in the database 
	 */
    void function postUpdate( any entity ){}
	
	/**
	 * I am called before the entity is deleted from the database 
	 */
    void function preDelete( any entity ){}
	
	/**
	 * I am called after deleting an item from the datastore
	 */
    void function postDelete( any entity ){}
		
}