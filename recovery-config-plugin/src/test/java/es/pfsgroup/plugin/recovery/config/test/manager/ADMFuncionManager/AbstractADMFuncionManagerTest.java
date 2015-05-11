package es.pfsgroup.plugin.recovery.config.test.manager.ADMFuncionManager;

import static org.mockito.Mockito.mock;

import java.util.List;

import org.junit.After;
import org.junit.Before;

import es.pfsgroup.plugin.recovery.config.funciones.ADMFuncionManager;
import es.pfsgroup.plugin.recovery.config.funciones.dao.ADMFuncionDao;
import es.pfsgroup.testfwk.TestData;
import es.pfsgroup.testfwk.TestDataCriteria;
public abstract class AbstractADMFuncionManagerTest {

	protected static final String TEST_DATA = "/dbunit-test-data/Funciones_default.xml";
	protected ADMFuncionManager manager = null;
	protected ADMFuncionDao dao = null;

	public AbstractADMFuncionManagerTest() {
		super();
	}

	@Before
	public void setup() {
		dao = mock(ADMFuncionDao.class);
		manager = new ADMFuncionManager(dao);
	}

	@After
	public void teardown() {
		manager = null;
		dao = null;
	}

	protected <T> List<T> getTestData(Class<T> clazz, TestDataCriteria... crit) throws Exception {
		TestData<T> td = TestData.create(clazz, TEST_DATA, crit);
		return td.getList();
	}

}