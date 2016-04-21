package es.pfsgroup.plugin.recovery.arquetipos.test.manager.arqModeloManager;

import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.mockito.Mockito;

import es.pfsgroup.plugin.recovery.arquetipos.estadoModelo.dao.ARQDDEstadoModeloDao;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.ARQModeloManager;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.dao.ARQModeloDao;
import es.pfsgroup.testfwk.DInjector;
import es.pfsgroup.testfwk.TestData;
import es.pfsgroup.testfwk.TestDataCriteria;

public class AbstractARQModeloManagerTest {
	
	protected static final String TEST_DATA = "/dbunit-test-data/Arquetipos_default.xml";
	protected ARQModeloManager arqModeloManager = null;
	protected ARQModeloDao modeloDao = null;
	protected ARQDDEstadoModeloDao estadoDao = null;
	
	public AbstractARQModeloManagerTest(){
		super();
	}
	
	@Before
	public void setup() {
		this.modeloDao = Mockito.mock(ARQModeloDao.class);
		this.estadoDao = Mockito.mock(ARQDDEstadoModeloDao.class);
		
		this.arqModeloManager = new ARQModeloManager(modeloDao);
		DInjector di = new DInjector(arqModeloManager);
		di.inject("estadoModeloDao", estadoDao);
	}
	
	@After
	public void teardown(){
		this.arqModeloManager = null;
		this.modeloDao = null;
	}
	
	protected <T> List<T> getTestData(Class<T> clazz, TestDataCriteria... crit) throws Exception {
		TestData<T> td = TestData.create(clazz, TEST_DATA, crit);
		return td.getList();
	}
	
}
