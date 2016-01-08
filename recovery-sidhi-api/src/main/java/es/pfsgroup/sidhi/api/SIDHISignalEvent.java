package es.pfsgroup.sidhi.api;

public class SIDHISignalEvent {
	
	private Object managedObject;
	
	private SIDHIAction[] action;

	public SIDHISignalEvent(Object managedObject, SIDHIAction[] action) {
		super();
		this.managedObject = managedObject;
		this.action = action;
	}

	public Object getManagedObject() {
		return managedObject;
	}

	public SIDHIAction[] getAction() {
		return action;
	}
}
