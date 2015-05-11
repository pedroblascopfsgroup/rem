package es.capgemini.pfs.batch.revisar.arquetipos.engine.test.sqlStatementBuilder;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.batch.revisar.arquetipos.ExtendedRuleExecutorConfig;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.SQLStatementBuilder;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.CannotParseRuleDefinitionException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.RuleDefinitionTypeNotSupportedException;
import es.capgemini.pfs.ruleengine.RuleConverterUtil;
import es.capgemini.pfs.ruleengine.rule.Rule;
import es.capgemini.pfs.ruleengine.state.RuleEndState;

@RunWith(MockitoJUnitRunner.class)
public class BuildSQL4InsertTest extends AbstractInsertStatementBuilderTests {

	private static final String RULE_DEFINITION_XML = "esto no es un xml real pero da igual";
	@InjectMocks
	private SQLStatementBuilder builder;

	@Mock
	private RuleConverterUtil mockRuleConv;

	@Mock
	private Rule mockHelper;

	@Spy
	private Properties appProperties = new Properties();
	
	private Date currentDate;

	@Before
	public void before() throws IOException {
		appProperties.load(SQLStatementBuilder.class.getClassLoader()
				.getResourceAsStream("app.properties"));
		
		currentDate = new Date();
	}

	@After
	public void after() {
		reset(mockRuleConv);
		reset(mockHelper);
		appProperties = new Properties();
		currentDate = null;
	}

	/**
	 * Comprueba que se genera el insert que esperamos
	 */
	@Test
	public void testBuildSQL() {
		// Creamos una configuración de partida
		final ExtendedRuleExecutorConfig myConfig = createConfig();
		runAndAssertTest(myConfig, null);
	}

	private abstract class CheckIllegalStateException {
		public abstract void config(final ExtendedRuleExecutorConfig o);

		public void test() {
			try {
				ExtendedRuleExecutorConfig myConfig = createConfig();
				config(myConfig);
				runAndAssertTest(myConfig, null);
				fail("Se debería haber lanzado una excepción");
			} catch (IllegalStateException e) {
				// Si se lanza la excepción todo bien
			} catch (Exception e) {
				fail(e.getClass().getName() + " no es la excecpión esperada");
			}
		}

	}

	/**
	 * Prueba el caso en el que le falte algún parámetro de configuración
	 */
	@Test
	public void testBuildSQL_noConfig() {

		new CheckIllegalStateException() {
			@Override
			public void config(ExtendedRuleExecutorConfig o) {
				o.setPolicy(null);

			}
		}.test();

		new CheckIllegalStateException() {
			@Override
			public void config(ExtendedRuleExecutorConfig o) {
				o.setRuleDefinitionType(null);
			}
		}.test();

		new CheckIllegalStateException() {
			@Override
			public void config(ExtendedRuleExecutorConfig o) {
				o.setTableFrom(null);

			}
		}.test();

		new CheckIllegalStateException() {
			@Override
			public void config(ExtendedRuleExecutorConfig o) {
				o.setColumnFromRef(null);

			}
		}.test();

		new CheckIllegalStateException() {
			@Override
			public void config(ExtendedRuleExecutorConfig o) {
				o.setTableToInsert(null);

			}
		}.test();

		new CheckIllegalStateException() {
			@Override
			public void config(ExtendedRuleExecutorConfig o) {
				o.setColumnToRef(null);

			}
		}.test();

		new CheckIllegalStateException() {
			@Override
			public void config(ExtendedRuleExecutorConfig o) {
				o.setColumnArqId(null);

			}
		}.test();

		new CheckIllegalStateException() {
			@Override
			public void config(ExtendedRuleExecutorConfig o) {
				o.setColumnArqName(null);

			}
		}.test();

		new CheckIllegalStateException() {
			@Override
			public void config(ExtendedRuleExecutorConfig o) {
				o.setColumnArqPriority(null);

			}
		}.test();

		new CheckIllegalStateException() {
			@Override
			public void config(ExtendedRuleExecutorConfig o) {
				o.setColumnArqDate(null);

			}
		}.test();
	}

	/**
	 * Sólo se soporta el parseado de reglas XML, si el tipo de regla es
	 * distinto fallaremos.
	 */
	@Test(expected = RuleDefinitionTypeNotSupportedException.class)
	public void testTryToBuildFromNoXML() {
		// Creamos una configuración de partida
		final ExtendedRuleExecutorConfig myConfig = createConfig();
		myConfig.setRuleDefinitionType("_"
				+ RandomStringUtils.randomAlphabetic(5));

		// Creamos la regla de ejemplo
		final RuleEndState myRule = createRule(101, "my name", 102,
				RULE_DEFINITION_XML);

		// Lanzamos la llamda
		final String sql = builder.buildSQL4Insert(myRule, myConfig, new Date());

	}

	@Test(expected = CannotParseRuleDefinitionException.class)
	public void testErrorParsingXML() {
		ExtendedRuleExecutorConfig myConfig = createConfig();
		runAndAssertTest(myConfig, new ValidationException());
	}

	private void runAndAssertTest(final ExtendedRuleExecutorConfig myConfig,
			final ValidationException exception) {
		// Creamos la regla de ejemplo
		final RuleEndState myRule = createRule(101, "my name", 102,
				RULE_DEFINITION_XML);

		// Construimos la SQL que esperamos
		final String expectedWhere = RandomStringUtils.randomAlphabetic(100);
		final String expectedSQL4Insert = "INSERT INTO T_" + TABLE_NAME_TO_INSERT +" (tmp_id, " + COLUMN_NAME_REF +", " + COLUMN_NAME_ARQ_ID + ", arq_name, " + COLUM_NAME_ARQ_PRIORITY + ", arq_date, "
				+ SQLStatementBuilder.AUDITORIA_CAMPOS
				+ ")"
				+ " SELECT s_tmp_bruno_dev_arq.nextval, D.* FROM ("
				+ "SELECT DISTINCT " + COLUMN_NAME_REF +", 101 AS VAL, 'my name' AS NAME, 102 AS PRI, to_timestamp('"+ new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(currentDate) +"','rrrr/mm/dd hh24:mi:ss') AS DAT, "
				+ SQLStatementBuilder.AUDITORIA_VALORES
				+ " FROM data_rule_engine" + " WHERE " + expectedWhere + ") D";

		// Configuramos el rule converter para que nos parsee el XML según
		// queremos
		when(mockRuleConv.XMLToRule(RULE_DEFINITION_XML, myConfig)).thenReturn(
				mockHelper);
		if (exception == null) {
			when(mockHelper.generateSQL()).thenReturn(expectedWhere);
		} else {
			when(mockHelper.generateSQL()).thenThrow(exception);
		}

		// Lanzamos la llamda
		final String sqlInsert = builder.buildSQL4Insert(myRule, myConfig, currentDate);

		// Comprobamos
		assertEquals(expectedSQL4Insert, sqlInsert);
	}

	private RuleEndState createRule(final int ruleId, final String ruleName,
			final int rulePriority, final String ruleDefinition) {
		return new RuleEndState() {

			@Override
			public String getValue() {
				return ruleId + "";
			}

			@Override
			public String getRuleDefinition() {
				return ruleDefinition;
			}

			@Override
			public long getPriority() {
				return rulePriority;
			}

			@Override
			public String getName() {
				return ruleName;
			}
		};
	}

}
