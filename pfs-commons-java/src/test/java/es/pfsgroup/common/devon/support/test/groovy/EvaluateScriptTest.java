package es.pfsgroup.common.devon.support.test.groovy;

import static org.junit.Assert.*;

import org.junit.Test;

import es.capgemini.devon.scripting.groovy.GroovyEvaluator;

public class EvaluateScriptTest {
	@Test
	public void testEvaluateScript() throws Exception {
		GroovyEvaluator ge = new GroovyEvaluator();
		 Object o =ge.evaluate("5*24*60*60*1000L", null);
		 assertTrue(o instanceof Long);
		 assertEquals(5*24*60*60*1000L, o);
	}
}
