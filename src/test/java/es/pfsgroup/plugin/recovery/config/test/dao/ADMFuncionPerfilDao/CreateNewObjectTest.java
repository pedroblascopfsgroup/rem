package es.pfsgroup.plugin.recovery.config.test.dao.ADMFuncionPerfilDao;

import static org.junit.Assert.*;

import org.junit.Test;

import es.capgemini.pfs.users.domain.FuncionPerfil;
import es.pfsgroup.testfwk.templates.test.CreateEmptyObjectTest;
import es.pfsgroup.testfwk.templates.test.TestTemplate;

public class CreateNewObjectTest extends AbstractADMFuncionPerfilDaoTest{

	
	@Test
	public void testCreateNewObject() throws Exception {
		TestTemplate template = new CreateEmptyObjectTest<FuncionPerfil>(dao, "createNewObject");
		template.run();
	}
}
