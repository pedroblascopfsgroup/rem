package es.capgemini.pfs.batch.revisar.arquetipos.engine.test.extendedRuleExecutor;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.eq;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.batch.revisar.arquetipos.ExtendedRuleExecutorConfig;
import es.capgemini.pfs.batch.revisar.arquetipos.database.ConnectionFacade;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.ExtendedRuleExecutor;
import es.capgemini.pfs.ruleengine.RuleExecutor;
import es.capgemini.pfs.ruleengine.RuleExecutorConfig;
import es.capgemini.pfs.ruleengine.RuleResult;
import es.capgemini.pfs.ruleengine.rule.dd.DDRuleManager;
import es.capgemini.pfs.ruleengine.state.RuleEndState;

@RunWith(MockitoJUnitRunner.class)
public class ExecRulesTest {

	private static final String INSERT_POLICY_KEYWORD = "INSERT";

	private static final String UPDATE_POLICY_KEYWORD = "UPDATE";

	@InjectMocks
	private ExtendedRuleExecutor executor;

	@Mock
	private RuleExecutor parentRuleExecutor;
	
	@Mock
	private ConnectionFacade mockConnectionFacade;
	
	@Mock
	private DDRuleManager mockRuleManager;

	@SuppressWarnings("unused")
	private ExtendedRuleExecutorConfig myConfig;

	private List<RuleEndState> myRuleList;

	private List<RuleResult> expectedResultList;

	@SuppressWarnings("unchecked")
	@Before
	public void before() {
		myRuleList = new ArrayList<RuleEndState>();
		expectedResultList = new ArrayList<RuleResult>();

		when(parentRuleExecutor.execRules((List<RuleEndState>) any()))
				.thenReturn(expectedResultList);
	}

	@After
	public void after() {
		reset(parentRuleExecutor, mockConnectionFacade,mockRuleManager);
	}

	/**
	 * Si la configuración que se le pasa al executor no es la extendida se
	 * delega al método original.
	 */
	@Test
	public void testConfigruacionOriginal() {
		final RuleExecutorConfig myLocalConfig = new RuleExecutorConfig();
		executor.setConfig(myLocalConfig);
		executor.execRules(myRuleList);

		verifyDelegation(myLocalConfig);
	}

	/**
	 * Si el campo policy de la configuración es distinto a INSERT o UPDATE se
	 * debe lanzar una excepción
	 */
	@Test(expected = IllegalArgumentException.class)
	public void testPoliticaInvalida() {
		final ExtendedRuleExecutorConfig myLocalConfig = createExtendedConfig("_"
				+ RandomStringUtils.random(10));

		executor.setConfig(myLocalConfig);
		executor.execRules(myRuleList);

	}


	/**
	 * Si la política es update delegamos al método original y por lo tanto
	 * usamos el algoritmo clásico.
	 */
	@Test
	public void testPoliticaUpdate() {
		final ExtendedRuleExecutorConfig myLocalConfig = createExtendedConfig(UPDATE_POLICY_KEYWORD);

		executor.setConfig(myLocalConfig);
		List<RuleResult> result = executor.execRules(myRuleList);
		
		verifyDelegation(myLocalConfig);
		assertEquals(expectedResultList, result);
	}
	
	/**
	 * Si la política es update usamos el nuevo algoritmo
	 */
	@SuppressWarnings("unchecked")
	@Test
	public void testPoliticaInsert(){
		final ExtendedRuleExecutorConfig myLocalConfig = createExtendedConfig(INSERT_POLICY_KEYWORD);
		executor.setConfig(myLocalConfig);
		
		
		final ExtendedRuleExecutor myLocalSpy = spy(executor);
		doReturn(expectedResultList).when(myLocalSpy).runInsertAlgorithm((List<RuleEndState>) any(), (Date) any());
		final List<RuleResult> result = myLocalSpy.execRules(myRuleList);
		
		
		verify(myLocalSpy).runInsertAlgorithm(eq(myRuleList), (Date) any());
		assertEquals(expectedResultList, result);
		
	}
	
	private ExtendedRuleExecutorConfig createExtendedConfig(
			final String myPolicy) {
		final ExtendedRuleExecutorConfig myLocalConfig = new ExtendedRuleExecutorConfig();
		myLocalConfig.setPolicy(myPolicy);
		return myLocalConfig;
	}
	
	private void verifyDelegation(final RuleExecutorConfig myLocalConfig) {
		verify(mockRuleManager).regenerateData(myLocalConfig);
		verify(parentRuleExecutor).setConfig(myLocalConfig);
		verify(parentRuleExecutor).execRules(myRuleList);
	}
}
