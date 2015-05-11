package es.pfsgroup.common.utils.test.api;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import es.capgemini.devon.bo.Executor;
import es.pfsgroup.commons.utils.api.ApiProxy;
import static org.junit.Assert.*;
import static org.mockito.Mockito.*;


public class ExampleApiTest {

	
	private Executor executor;
	
	@Before
	public void before(){
		executor = mock(Executor.class); 
	}
	
	@After
	public void after(){
		executor = null;
	}
	
	@Test
	public void testApi1() throws Exception {
		when(executor.execute(ExampleApi.EXAMPLE_BO1,5,100)).thenReturn(500);
		int r1 = ApiProxy.newInstance(executor, ExampleApi.class).exammpleBusinessOperation(5, 100);
		verify(executor).execute(ExampleApi.EXAMPLE_BO1,5,100);
		assertEquals(500, r1);
	}
	
	@Test
	public void testApi2() throws Exception {
		String s = "aaaaa";
	
		ApiProxy.newInstance(executor, ExampleApi.class).exammpleBusinessOperation2(s);
		verify(executor).execute(ExampleApi.EXAMPLE_BO2,s);
	}
}
