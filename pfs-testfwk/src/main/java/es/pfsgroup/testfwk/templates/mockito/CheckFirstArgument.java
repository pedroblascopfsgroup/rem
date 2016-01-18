package es.pfsgroup.testfwk.templates.mockito;

import java.lang.reflect.Field;

import junit.framework.Assert;

import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;

import es.pfsgroup.testfwk.FieldCriteria;

public class CheckFirstArgument implements Answer{
	private FieldCriteria [] checks;
	
	public CheckFirstArgument(FieldCriteria ... crit){
		if (crit == null){
			throw new IllegalArgumentException("crit no puede ser null");
		}
		checks = crit;
	}

	public Object answer(InvocationOnMock invocation) throws Throwable {
		for (int i = 0; i < checks.length; i++) {
			FieldCriteria c = checks[i];
			Assert.assertEquals(c.getValue(),getProperty(c.getName(),invocation.getArguments()[0]));
		}
		return  null;
	}

	private Object getProperty(String name, Object object) throws Exception{
		Class clazz = object.getClass();
		Field f = clazz.getDeclaredField(name);
		f.setAccessible(true);
		return f.get(object);
	}

}
