package es.pfsgroup.framework.paradise.action.utils;

import java.beans.PropertyDescriptor;

public class TargetDescriptors {
	
	private PropertyDescriptor descriptor;
	private Class<?> type;
	
	
	
	public TargetDescriptors(PropertyDescriptor descriptor, Class<?> type) {
		this.descriptor = descriptor;
		this.type = type;
	}


	public PropertyDescriptor getDescriptor() {
		return descriptor;
	}


	public void setProp(PropertyDescriptor descriptor) {
		this.descriptor = descriptor;
	}


	public Class<?> getType() {
		return type;
	}


	public void setType(Class<?> type) {
		this.type = type;
	}
	
	
}
