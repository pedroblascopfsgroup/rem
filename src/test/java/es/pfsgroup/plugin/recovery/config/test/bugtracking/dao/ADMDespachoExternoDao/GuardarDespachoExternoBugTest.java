package es.pfsgroup.plugin.recovery.config.test.bugtracking.dao.ADMDespachoExternoDao;

import org.junit.Test;

import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.plugin.recovery.config.test.dao.ADMDespachoExternoDao.AbstractADMDespachoExternoDaoTest;
import es.pfsgroup.testfwk.FieldCriteria;
import es.pfsgroup.testfwk.TestData;

public class GuardarDespachoExternoBugTest extends
		AbstractADMDespachoExternoDaoTest {

	@Test
	public void testCrearDespachoExterno() throws Exception {
		DespachoExterno d = TestData.newTestObject(DespachoExterno.class, new FieldCriteria("id", null),
		          new FieldCriteria("auditoria", null), new FieldCriteria("borrado", null));;

		dao.save(d);
	}

}
