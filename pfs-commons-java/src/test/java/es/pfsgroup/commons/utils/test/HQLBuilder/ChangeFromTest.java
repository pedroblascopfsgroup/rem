package es.pfsgroup.commons.utils.test.HQLBuilder;

import static org.junit.Assert.*;

import org.junit.Test;

import es.pfsgroup.commons.utils.HQLBuilder;

public class ChangeFromTest {
	
	private HQLBuilder builder;
	
	@Test
	public void changeFromTest(){
		builder = new HQLBuilder("select ob.id, ob.codigo, obj.desc from MyClass obj where 1=1");
		
		builder.changeFrom("MyClass", "MyNewClass");
		
		assertEquals("select ob.id, ob.codigo, obj.desc from MyNewClass obj where 1=1", builder.toString());
	}

}
