package es.pfsgroup.plugin.recovery.config.test.dao.ADMUsuarioDao;

import static org.junit.Assert.*;

import org.junit.Test;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.testfwk.templates.test.NullArgumentsTest;
import es.pfsgroup.testfwk.templates.test.TestTemplate;

public class ObtenerUsuarioPorEntidad  extends AbstractADMUsuarioDaoTest{
	
	@Test
	public void testObtenerPorentidad() throws Exception {
		
		cargaDatos();
		Usuario result = dao.getByEntidad(1L, 1L);
		
		assertNotNull(result);
		assertEquals("TEST1", result.getUsername());
	}
	
	@Test
	public void testNullArguments_exception() throws Exception {
		TestTemplate template = new NullArgumentsTest(dao, "getByEntidad", Long.class,Long.class);
		template.run();
	}

	
	@Test
	public void testEntidadNoCoincide_devuelveNull() throws Exception {
		cargaDatos();
		Usuario result = dao.getByEntidad(1L, 2L);
		
		assertNull(result);
	}
}
