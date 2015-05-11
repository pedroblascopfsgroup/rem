package es.pfsgroup.plugin.recovery.config.test.dao.ADMFuncionPerfilDao;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import es.capgemini.pfs.users.domain.FuncionPerfil;
import es.pfsgroup.testfwk.templates.test.NullArgumentsTest;
import es.pfsgroup.testfwk.templates.test.TestTemplate;

public class BuscarFuncionPerfilTest extends AbstractADMFuncionPerfilDaoTest{

	
	@Test
	public void testBuscarFuncionPerfil() throws Exception {
		
		cargaDatos();
		
		List<FuncionPerfil> result = dao.find(2L, 3L);
		assertEquals(1, result.size());
		assertEquals((Long) 4L, (Long) result.get(0).getId());
	}
	
	@Test
	public void tetNullArguments_exceptio() throws Exception {
		TestTemplate template = new NullArgumentsTest(dao, "find", Long.class,Long.class);
		template.run();
	}
}
