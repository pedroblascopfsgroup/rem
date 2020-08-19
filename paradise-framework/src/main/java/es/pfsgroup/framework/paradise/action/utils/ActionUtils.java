package es.pfsgroup.framework.paradise.action.utils;

import java.beans.BeanInfo;
import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Component;

@Component
public class ActionUtils {
	
	public Map<String, TargetDescriptors> getTypeDescriptors(Object dest) throws IntrospectionException {
		Map<String, TargetDescriptors> types = new HashMap<String, TargetDescriptors>();
		BeanInfo beanInfoDest = Introspector.getBeanInfo(dest.getClass());
		PropertyDescriptor[] descriptorsDest = beanInfoDest.getPropertyDescriptors();
		for (PropertyDescriptor descriptor : descriptorsDest) {
			types.put(descriptor.getName(), new TargetDescriptors(descriptor, descriptor.getPropertyType()));
		}
		return types;
	}
}
