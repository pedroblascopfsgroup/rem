package es.pfsgroup.plugin.recovery.config.test.manager.ADMTipoDespachoExternoManager;

import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.mockito.Mockito;

import es.pfsgroup.plugin.recovery.config.despachoExterno.ADMTipoDespachoExternoManager;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMTipoDespachoExternoDao;
import es.pfsgroup.testfwk.TestData;
import es.pfsgroup.testfwk.TestDataCriteria;

public abstract class AbstractADMTipoDespachoExternoManagerTest {

	protected static final String TEST_DATA = "/dbunit-test-data/Gestores-Despachos_default.xml";
	protected ADMTipoDespachoExternoManager manager;
	protected ADMTipoDespachoExternoDao dao = null;

	public AbstractADMTipoDespachoExternoManagerTest() {
		super();
	}

	@Before
	public void setup() {
		this.dao = Mockito.mock(ADMTipoDespachoExternoDao.class);
		
		
		this.manager = new ADMTipoDespachoExternoManager(dao);
	}

	@After
	public void teardown() {
		this.manager = null;
		this.dao = null;
	}

	protected <T> List<T> getTestData(Class<T> clazz, TestDataCriteria... crit) throws Exception {
		TestData<T> td = TestData.create(clazz, TEST_DATA, crit);
		return td.getList();
	}

}