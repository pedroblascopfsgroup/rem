package es.pfsgroup.plugin.recovery.arquetipos.test.manager.arqDDTipoSaltoManager;

import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.mockito.Mockito;

import es.pfsgroup.plugin.recovery.arquetipos.ddTipoSalto.ARQDDTipoSaltoManager;
import es.pfsgroup.plugin.recovery.arquetipos.ddTipoSalto.dao.ARQDDTipoSaltoDao;
import es.pfsgroup.testfwk.TestData;
import es.pfsgroup.testfwk.TestDataCriteria;

public class AbstractARQDDTipoSaltoManagerTest {
	
	protected static final String TEST_DATA = "/dbunit-test-data/Arquetipos_default.xml";
	protected ARQDDTipoSaltoManager tipoSaltoManager = null;
	protected ARQDDTipoSaltoDao tipoSaltoDao = null;
	
	public AbstractARQDDTipoSaltoManagerTest(){
		super();
	}
	
	@Before
	public void setup(){
		this.tipoSaltoDao=Mockito.mock(ARQDDTipoSaltoDao.class);
		this.tipoSaltoManager = new ARQDDTipoSaltoManager(tipoSaltoDao);
	}
	
	@After
	public void teardown(){
		this.tipoSaltoDao = null;
		this.tipoSaltoManager = null;
	}
	
	protected <T> List<T> getTestData(Class<T> clazz, TestDataCriteria... crit) throws Exception {
		TestData<T> td = TestData.create(clazz, TEST_DATA, crit);
		return td.getList();
	}
	
}
