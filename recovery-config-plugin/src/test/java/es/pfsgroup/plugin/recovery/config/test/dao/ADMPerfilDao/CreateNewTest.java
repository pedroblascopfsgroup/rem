package es.pfsgroup.plugin.recovery.config.test.dao.ADMPerfilDao;

import es.capgemini.pfs.users.domain.Perfil;
import es.pfsgroup.testfwk.templates.test.CreateEmptyObjectTest;
import es.pfsgroup.testfwk.templates.test.TestTemplate;

public class CreateNewTest extends AbstractADMPerfilDaoTest{

	public void testCreateNew(){
		TestTemplate template = new CreateEmptyObjectTest<Perfil>(dao, "createNew");
		template.run();
	}
}
