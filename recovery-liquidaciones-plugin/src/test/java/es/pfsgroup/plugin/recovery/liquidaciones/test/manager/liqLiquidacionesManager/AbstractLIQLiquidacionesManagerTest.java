package es.pfsgroup.plugin.recovery.liquidaciones.test.manager.liqLiquidacionesManager;


import static org.mockito.Mockito.mock;

import java.util.List;

import org.junit.After;
import org.junit.Before;

import es.capgemini.devon.bo.Executor;
import es.pfsgroup.plugin.recovery.liquidaciones.LIQLiquidacionesManager;
import es.pfsgroup.plugin.recovery.liquidaciones.dao.LIQCobroPagoDao;
import es.pfsgroup.testfwk.TestData;
import es.pfsgroup.testfwk.TestDataCriteria;
public abstract class AbstractLIQLiquidacionesManagerTest {

	protected static final String TEST_DATA = "/dbunit-test-data/CobrosPagos_default.xml";
	protected LIQLiquidacionesManager manager = null;
	protected LIQCobroPagoDao dao = null;
	protected Executor executor;

	public AbstractLIQLiquidacionesManagerTest() {
		super();
	}

	@Before
	public void setup() {
		dao = mock(LIQCobroPagoDao.class);
		executor = mock(Executor.class);
		manager = new LIQLiquidacionesManager(dao, executor);
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