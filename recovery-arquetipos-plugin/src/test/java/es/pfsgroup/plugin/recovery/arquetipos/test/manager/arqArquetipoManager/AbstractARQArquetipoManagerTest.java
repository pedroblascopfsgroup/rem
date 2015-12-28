package es.pfsgroup.plugin.recovery.arquetipos.test.manager.arqArquetipoManager;

import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.mockito.Mockito;

import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.ARQArquetipoManager;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dao.ARQArquetipoDao;
import es.pfsgroup.testfwk.TestData;
import es.pfsgroup.testfwk.TestDataCriteria;

public class AbstractARQArquetipoManagerTest {
	
	protected static final String TEST_DATA = "/dbunit-test-data/Arquetipos_default.xml";
	protected ARQArquetipoManager arqArquetipoManager = null;
	protected ARQArquetipoDao arquetipoDao = null;
	

	public AbstractARQArquetipoManagerTest() {
		super();
	}

	@Before
	public void setup() {
		this.arquetipoDao = Mockito.mock(ARQArquetipoDao.class);
		
		this.arqArquetipoManager = new ARQArquetipoManager(arquetipoDao);
	}

	@After
	public void teardown() {
		this.arqArquetipoManager = null;
		this.arquetipoDao = null;
	}

	protected <T> List<T> getTestData(Class<T> clazz, TestDataCriteria... crit) throws Exception {
		TestData<T> td = TestData.create(clazz, TEST_DATA, crit);
		return td.getList();
	}


}
