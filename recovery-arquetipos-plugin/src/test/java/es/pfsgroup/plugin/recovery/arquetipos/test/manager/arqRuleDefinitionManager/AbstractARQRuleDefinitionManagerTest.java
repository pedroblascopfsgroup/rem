package es.pfsgroup.plugin.recovery.arquetipos.test.manager.arqRuleDefinitionManager;

import java.util.List;

import org.junit.After;
import org.junit.Before;
import static org.mockito.Mockito.mock;

import es.pfsgroup.plugin.recovery.arquetipos.rules.ARQRuleDefinitionManager;
import es.pfsgroup.plugin.recovery.arquetipos.rules.dao.ARQRuleDefinitionDao;
import es.pfsgroup.testfwk.TestData;
import es.pfsgroup.testfwk.TestDataCriteria;

public class AbstractARQRuleDefinitionManagerTest {
	
	protected static final String TEST_DATA = "/dbunit-test-data/Arquetipos_default.xml";
	protected ARQRuleDefinitionManager ruleManager = null;
	protected ARQRuleDefinitionDao ruleDao = null;
	
	public AbstractARQRuleDefinitionManagerTest(){
		super();
	}
	
	@Before
	public void sutup(){
		ruleDao = mock(ARQRuleDefinitionDao.class);
		ruleManager = new ARQRuleDefinitionManager(ruleDao);
	}
	
	@After
	public void tardown(){
		ruleManager = null;
		ruleDao = null;
	}
	
	protected <T> List<T> getTestData(Class<T> clazz, TestDataCriteria... crit) throws Exception {
		TestData<T> td = TestData.create(clazz, TEST_DATA, crit);
		return td.getList();
	}
}
