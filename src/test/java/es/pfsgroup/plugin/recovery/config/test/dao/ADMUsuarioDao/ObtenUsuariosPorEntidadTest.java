package es.pfsgroup.plugin.recovery.config.test.dao.ADMUsuarioDao;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.testfwk.templates.test.NullArgumentsTest;
import es.pfsgroup.testfwk.templates.test.TestTemplate;

public class ObtenUsuariosPorEntidadTest extends AbstractADMUsuarioDaoTest{

	@Test
	public void testNullArguments_exception() throws Exception {
		TestTemplate template = new NullArgumentsTest(dao, "getListByEntidad", Long.class);
		template.run();
	}
	
	@Test
	public void testObtenerUsuarios() throws Exception {
		cargaDatos();
		List<Usuario> result1 = dao.getListByEntidad(1L);
		List<Usuario> result2 = dao.getListByEntidad(2L);
		assertEquals(5, result1.size());
		assertEquals(2, result2.size());
	}
}
