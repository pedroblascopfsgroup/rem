package es.pfsgroup.plugin.recovery.config.test.dao.ADMFuncionDao;

import org.junit.Test;

import es.capgemini.pfs.users.domain.Funcion;
import es.pfsgroup.testfwk.templates.test.CreateEmptyObjectTest;
import es.pfsgroup.testfwk.templates.test.TestTemplate;

/**
 * Verifica la creación de un nuevo objeto Función
 * @author bruno
 *
 */
public class CrearNuevaFuncionTest extends AbstractADMFuncionDaoTest{

	
	@Test
	public void testCrearNuevaFuncion(){
		TestTemplate template = new CreateEmptyObjectTest<Funcion>(dao,"createNew");
		template.run();	
	}
}
