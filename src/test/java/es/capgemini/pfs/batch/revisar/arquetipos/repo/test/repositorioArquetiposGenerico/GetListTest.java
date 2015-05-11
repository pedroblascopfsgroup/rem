package es.capgemini.pfs.batch.revisar.arquetipos.repo.test.repositorioArquetiposGenerico;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.sql.DataSource;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.batch.revisar.arquetipos.repo.RepositorioArquetiposGenerico;
import es.capgemini.pfs.batch.revisar.arquetipos.repo.RepositorioConfig;
import es.capgemini.pfs.batch.revisar.arquetipos.repo.dao.ArquetiposBatchDao;
import es.capgemini.pfs.ruleengine.state.RuleEndState;

/**
 * Tests de la operación getList de {@link RepositorioArquetiposGenerico}
 * 
 * @author bruno
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class GetListTest {
	
	private static final String COLUMN_FOR_VALUE = "_VAL_";
	private static final String COLUMN_FOR_PRIORITY = "_PRI_";
	private static final String COLUMN_FOR_NAME = "_NAM_";
	private static final String COLUMN_FOR_RULE_DEFINITION = "_RD_";

	@InjectMocks
	private RepositorioArquetiposGenerico repo;

	@Mock
	private ArquetiposBatchDao dao;

	/*
	 * Configuración del repositorio
	 */
	private String select;
	private RepositorioConfig config;
	private DataSource mockDataSource;
	
	/*
	 * Variables intermedias del test
	 */
	private int numResults;
	
	private Random random;
	

	@Before
	public void before() {
		random = new Random();
		config = new RepositorioConfig();
		select = "SELECT " + RandomStringUtils.randomAlphabetic(100);
		config.setQuery(select);
		config.setColumnForValue(COLUMN_FOR_VALUE);
		config.setColumnForPriority(COLUMN_FOR_PRIORITY);
		config.setColumnForName(COLUMN_FOR_NAME);
		config.setColumnForRuleDefinition(COLUMN_FOR_RULE_DEFINITION);
		mockDataSource = mock(DataSource.class);
		numResults = 1 + Math.abs(random.nextInt(50));
	}
	
	@After
	public void after(){
		select = null;
		config = null;
		numResults = 0;
		random = null;
	}

	/**
	 * Testea el caso general.
	 */
	@Test
	public void testGetList() {
		
		final ArrayList<RuleEndState> expected = populateExpectedList();
		final List<Map<String, Object>> resultSet = populateResultSet(expected);
		
		when(dao.executeSelect(select)).thenReturn(resultSet);
		
		repo.setDataSource(mockDataSource);
		repo.setRepoConfig(config);
		List<RuleEndState> result = repo.getList();

		assertFalse("El resultado no puede ser nulo", result == null);
		assertEquals(expected.size(), result.size());

	}

	private ArrayList<Map<String, Object>> populateResultSet(final List<RuleEndState> rules) {
		final ArrayList<Map<String, Object>> result =new  ArrayList<Map<String,Object>>();
		for (RuleEndState rend : rules) {
			final HashMap<String, Object> record = new HashMap<String, Object>();
			record.put(COLUMN_FOR_NAME, rend.getName());
			record.put(COLUMN_FOR_PRIORITY, rend.getPriority());
			record.put(COLUMN_FOR_RULE_DEFINITION, rend.getRuleDefinition());
			record.put(COLUMN_FOR_VALUE, rend.getValue());
			result.add(record);
		}
		return result;
	}

	private ArrayList<RuleEndState> populateExpectedList() {
		final ArrayList<RuleEndState> list = new ArrayList<RuleEndState>();
		for (int i =0; i<numResults; i++){
			list.add(new RuleEndState() {
				
				@Override
				public String getValue() {
					return "" + random.nextLong();
				}
				
				@Override
				public String getRuleDefinition() {
					return RandomStringUtils.randomAlphabetic(100);
				}
				
				@Override
				public long getPriority() {
					return random.nextLong();
				}
				
				@Override
				public String getName() {
					return RandomStringUtils.randomAlphabetic(50);
				}
			});
		}
		return list;
	}

}
