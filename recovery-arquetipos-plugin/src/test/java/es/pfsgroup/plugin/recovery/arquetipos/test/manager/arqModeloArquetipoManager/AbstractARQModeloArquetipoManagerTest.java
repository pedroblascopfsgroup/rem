package es.pfsgroup.plugin.recovery.arquetipos.test.manager.arqModeloArquetipoManager;

import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.mockito.Mockito;

import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dao.ARQArquetipoDao;
import es.pfsgroup.plugin.recovery.arquetipos.itinerario.dao.ARQItinerarioDao;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.dao.ARQModeloDao;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.ARQModeloArquetipoManager;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.dao.ARQModeloArquetipoDao;
import es.pfsgroup.testfwk.TestData;
import es.pfsgroup.testfwk.TestDataCriteria;

public class AbstractARQModeloArquetipoManagerTest {

	protected static final String TEST_DATA = "/dbunit-test-data/Arquetipos_default.xml";
	
	protected ARQModeloArquetipoManager arqModeloArquetipoManager = null;
	protected ARQModeloArquetipoDao modeloArquetipoDao = null;
	
	public AbstractARQModeloArquetipoManagerTest(){
		super();
	}
	
	@Before
	public void setup(){
		this.modeloArquetipoDao = Mockito.mock(ARQModeloArquetipoDao.class);
		
		this.arqModeloArquetipoManager = new ARQModeloArquetipoManager(modeloArquetipoDao);
	}
	
	@After
	public void teardown(){
		this.arqModeloArquetipoManager= null;
		this.modeloArquetipoDao= null;
		
	}
	
	protected <T> List<T> getTestData(Class<T> clazz, TestDataCriteria... crit) throws Exception {
		TestData<T> td = TestData.create(clazz, TEST_DATA, crit);
		return td.getList();
	}
}
