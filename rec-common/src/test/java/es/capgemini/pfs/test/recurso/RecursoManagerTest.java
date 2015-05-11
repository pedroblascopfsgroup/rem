package es.capgemini.pfs.test.recurso;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.recurso.RecursoManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class RecursoManagerTest extends CommonTestAbstract{
	
	@Autowired
	RecursoManager recursoManager;

	@Test
	public final void testGetRecursosPorProcedimiento() {
		recursoManager.getRecursosPorProcedimiento(1L);
	}

	@Test
	public final void testGet() {
		recursoManager.get(1L);
	}

	@Test
	public final void testGetInstance() {
		recursoManager.getInstance(1L);
	}

}
