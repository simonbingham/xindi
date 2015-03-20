/**
 * I am the global event handler component.
 */
component implements = "cfide.orm.IEventHandler" {

	/**
	 * I am called before injecting property values into a newly loaded entity instance
	 */
	void function preLoad(any entity) {}

	/**
	 * I am called after an entity is fully loaded
	 */
	void function postLoad(any entity) {}

	/**
	 * I am called before inserting the entity into the database
	 */
	void function preInsert(any entity) {
		local.timestamp = now();
		if (StructKeyExists(arguments.entity, "setCreated")) {
			arguments.entity.setCreated(local.timestamp);
		}
		if (StructKeyExists(arguments.entity, "setUpdated")) {
			arguments.entity.setUpdated(local.timestamp);
		}
	}

	/**
	 * I am called after the entity is inserted into the database
	 */
	void function postInsert(any entity) {}

	/**
	 * I am called before the entity is updated in the database
	 */
	void function preUpdate(any entity, struct oldData) {
		if (StructKeyExists(arguments.entity, "setUpdated")) {
			arguments.entity.setUpdated(Now());
		}
	}

	/**
	 * I am called after the entity is updated in the database
	 */
	void function postUpdate(any entity) {}

	/**
	 * I am called before the entity is deleted from the database
	 */
	void function preDelete(any entity) {}

	/**
	 * I am called after deleting an item from the datastore
	 */
	void function postDelete(any entity) {}

	/**
	 * I am called before the session is flushed.
	 */
	void function preFlush(any entities) {}

	/**
	 * I am called after the session is flushed.
	 */
	void function postFlush(any entities) {}

}
