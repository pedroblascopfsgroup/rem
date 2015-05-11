package es.pfsgroup.plugin.recovery.config.test.dao.ADMUsuarioDao;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.testfwk.templates.test.NullArgumentsTest;
import es.pfsgroup.testfwk.templates.test.TestTemplate;

public class ObtenUsuariosNoExternosTest extends AbstractADMUsuarioDaoTest{

	@Test
	public void testNullArguments_exception() throws Exception {
		TestTemplate template = new NullArgumentsTest(dao, "getUsuariosNoExternos", Long.class);
		template.run();
	}
	
	@Test
	public void testObtenerUsuarios() throws Exception {
		cargaDatos();
		List<Usuario> result = dao.getUsuariosNoExternos(1L);
		assertEquals(1, result.size());
	}
}
