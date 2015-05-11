package es.capgemini.pfs.batch.revisar.arquetipos.engine.test.extendedRuleExecutor;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.eq;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
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
import es.capgemini.pfs.batch.revisar.arquetipos.engine.SQLStatementBuilder;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.CannotCommitOrCloseConnectionException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.CannotExecuteInsertException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.CannotOpenConnectionException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.CannotParseRuleDefinitionException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.ExtendedRuleExecutorException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.RuleDefinitionTypeNotSupportedException;
import es.capgemini.pfs.ruleengine.RuleExecutorConfig;
import es.capgemini.pfs.ruleengine.RuleResult;
import es.capgemini.pfs.ruleengine.state.RuleEndState;

/**
 * Test del algoritmo de inserts.
 * 
 * @author bruno
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class RunInsertAlgorithmTest {

	@InjectMocks
	private ExtendedRuleExecutor executor;

	@Mock
	private ConnectionFacade mockConnectionFacade;

	@Mock
	private SQLStatementBuilder mockInsertBuilder;

	/*
	 * Argumentos de entrada
	 */
	private List<RuleEndState> myRuleList;

	private ExtendedRuleExecutorConfig myConfig;

	/*
	 * HashMap de inserts que se espera obtener para cada entrada.
	 */
	private HashMap<Integer, String> insertsMap;

	private String ddl4create;
	private String ddl4drop;
	private String sql4move;
	private Date currentDate;

	/*
	 * Objetos intermedios del test
	 */
	private Connection connection;

	@Before
	public void before() {
		myRuleList = populateRuleList();
		insertsMap = populateInsertsMap(myRuleList);
		myConfig = new ExtendedRuleExecutorConfig();
		connection = mock(Connection.class);

		ddl4create = "create" + RandomStringUtils.randomAlphabetic(100);
		ddl4drop = "drop" + RandomStringUtils.randomAlphabetic(100);
		sql4move = "move" + RandomStringUtils.randomAlphabetic(100);

		currentDate = new Date();

		setBehaviour(mockInsertBuilder, myRuleList, myConfig, insertsMap);
		setBehaviour(mockConnectionFacade, connection);
		setBehaviour(mockInsertBuilder, myConfig, ddl4create, ddl4drop,
				sql4move);
	}

	@After
	public void after() {
		resetMocks(mockConnectionFacade);

		myRuleList = null;
		insertsMap = null;
		currentDate = null;
	}

	/**
	 * Test genérico del algoritmo, sin refresco de vistas.
	 */
	@Test
	public void testAlgorithm_withoutRefreshViews() {
		myConfig.setRefreshViews(null);
		final List<RuleResult> results = runExecutor();

		runCommonVerification(results, myConfig);
	}

	/**
	 * Test genérico del algoritmo, con refresco de vistas
	 */
	@Test
	public void testAlgorith_withRefresViews() {
		myConfig.setRefreshViews(Arrays.asList("VIEW_1", "VIEW_2"));

		final List<RuleResult> results = runExecutor();

		runCommonVerification(results, myConfig);
	}

	/**
	 * Si el tipo de definición no es XML fallamos
	 */
	@Test(expected = RuleDefinitionTypeNotSupportedException.class)
	public void testNoXML() {
		myConfig.setRuleDefinitionType("_"
				+ RandomStringUtils.randomAlphabetic(5));
		final List<RuleResult> results = runExecutor();
		for (RuleResult r : results) {
			assertTrue(r.isFinishedOK());
		}
	}

	/**
	 * Si ocurre cualquier error en ele parseo de las reglas el método no falla,
	 * se marcará la regla como errónea.
	 */
	@Test
	public void testXMLParseError() {
		when(
				mockInsertBuilder.buildSQL4Insert((RuleEndState) any(),
						(ExtendedRuleExecutorConfig) any(), (Date) any()))
				.thenThrow(new CannotParseRuleDefinitionException());
		final List<RuleResult> results = runExecutor();
		for (RuleResult r : results) {
			assertFalse(r.isFinishedOK());
		}
	}

	/**
	 * Este método espera que la configuración sea de tipo
	 * {@link ExtendedRuleExecutorConfig}, si no es así fallamos.
	 */
	@Test(expected = IllegalStateException.class)
	public void testConfigurationNotExtended() {
		executor.setConfig(new RuleExecutorConfig());
		executor.runInsertAlgorithm(myRuleList, currentDate);

	}

	@Test(expected = ExtendedRuleExecutorException.class)
	public void testExceptionCannotOpenConnection() {
		try {
			when(mockConnectionFacade.openConnection()).thenThrow(
					new CannotOpenConnectionException(null));
		} catch (Exception e) {
			// No se esperan excepciones en este momento.
		}
		runExecutor();

	}

	@Test(expected = ExtendedRuleExecutorException.class)
	public void testExceptionCannotExecuteInsert() {
		try {
			doThrow(new CannotExecuteInsertException(null)).when(
					mockConnectionFacade).executeInsert((Connection) any(),
					(String) any(), any(Boolean.class));
		} catch (Exception e) {
			// No se esperan excepciones en este momento.
		}
		runExecutor();

	}

	@Test(expected = ExtendedRuleExecutorException.class)
	public void testExceptionCannotCommitOrCloseConnection() {
		try {
			doThrow(new CannotCommitOrCloseConnectionException(null)).when(
					mockConnectionFacade).commitAndClose((Connection) any());
		} catch (Exception e) {
			// No se esperan excepciones en este momento.
		}
		runExecutor();

	}

	private void resetMocks(final Object... mocks) {
		if (mocks != null) {
			for (Object mock : mocks) {
				reset(mock);
			}
		}

	}

	private List<RuleEndState> populateRuleList() {
		final List<RuleEndState> rules = new ArrayList<RuleEndState>();
		rules.add(createRuleEndState());
		rules.add(createRuleEndState());
		rules.add(createRuleEndState());
		rules.add(createRuleEndState());
		rules.add(createRuleEndState());
		rules.add(createRuleEndState());
		rules.add(createRuleEndState());
		rules.add(createRuleEndState());
		return rules;
	}

	private HashMap<Integer, String> populateInsertsMap(
			final List<RuleEndState> list) {
		HashMap<Integer, String> map = new HashMap<Integer, String>();
		if (list != null) {
			for (RuleEndState rule : list) {
				final String value = "INSERT"
						+ RandomStringUtils.randomAlphabetic(100);
				map.put(rule.hashCode(), value);
			}
		}
		return map;
	}

	private void setBehaviour(final SQLStatementBuilder insertBuilder,
			final List<RuleEndState> rules,
			final ExtendedRuleExecutorConfig config,
			final HashMap<Integer, String> inserts) {
		for (RuleEndState rule : rules) {
			when(insertBuilder.buildSQL4Insert(rule, config, currentDate))
					.thenReturn(inserts.get(rule.hashCode()));
		}

	}

	private void setBehaviour(final ConnectionFacade facade,
			final Connection connection) {
		try {
			when(facade.openConnection()).thenReturn(connection);
		} catch (Exception e) {
			// Ignoramos cualquier tipo de excepción
		}

	}

	private void setBehaviour(final SQLStatementBuilder mockInsertBuilder,
			final ExtendedRuleExecutorConfig config, final String ddl4create,
			final String ddl4drop, final String sql4move) {

		when(mockInsertBuilder.buildDDL4DropTemp(config, currentDate))
				.thenReturn(ddl4drop);
		when(mockInsertBuilder.buildDDL4CreateTemp(config, currentDate))
				.thenReturn(ddl4create);
		when(mockInsertBuilder.buildSQL4MoveData(config, currentDate))
				.thenReturn(sql4move);
	}

	private RuleEndState createRuleEndState() {
		return new RuleEndState() {

			@Override
			public String getValue() {
				return null;
			}

			@Override
			public String getRuleDefinition() {
				return RandomStringUtils.randomAlphabetic(100);
			}

			@Override
			public long getPriority() {
				return 0;
			}

			@Override
			public String getName() {
				return RandomStringUtils.randomAlphabetic(50);
			}
		};
	}

	private List<RuleResult> runExecutor() {
		executor.setConfig(myConfig);
		return executor.runInsertAlgorithm(myRuleList, currentDate);

	}

	private void runCommonVerification(final List<RuleResult> results,
			final ExtendedRuleExecutorConfig config) {
		try {
			// Se abre la conexión con la BBDD
			verify(mockConnectionFacade).openConnection();

			// Se borra la tabla temporal
			verify(mockConnectionFacade, times(2)).executeDDL(eq(connection), eq(ddl4drop),
					any(Boolean.class));

			// Se crea la tabla temporal
			verify(mockConnectionFacade).executeDDL(eq(connection), eq(ddl4create),
					any(Boolean.class));

			// Se refrescan las vistas materializadas si hay vistas que
			// refrescar
			for (String v : config.getRefreshViews()) {
				verify(mockConnectionFacade).refreshView(v);
			}

			// Se realizan los inserts en la tabla temporal
			for (RuleEndState rule : myRuleList) {
				final String expected = insertsMap.get(rule.hashCode());
				verify(mockConnectionFacade).executeInsert(eq(connection),
						eq(expected), any(Boolean.class));
			}

			// Se mueven los registros de la temporal a la tabla definitiva,
			// quitando duplicados
			verify(mockConnectionFacade).executeInsert(eq(connection), eq(sql4move),
					any(Boolean.class));

			// Se borra la tabla temporal
			verify(mockConnectionFacade, times(2)).executeDDL(eq(connection),
					eq(ddl4drop), any(Boolean.class));

			// Se comitea y se cierra la conexión.
			verify(mockConnectionFacade).commitAndClose(connection);
			assertFalse(results == null);
			assertFalse(results.isEmpty());
		} catch (Exception e) {
			// No se espera que se lancen excepciones en este test
		}
	}
}
