package es.capgemini.pfs.batch.revisar.arquetipos.engine.test.sqlStatementBuilder;

import static org.mockito.Mockito.reset;
import static org.junit.Assert.*;

import java.io.IOException;
import java.util.Date;
import java.util.Properties;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Spy;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.batch.revisar.arquetipos.ExtendedRuleExecutorConfig;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.SQLStatementBuilder;

/**
 * Prueba la generación de sentencias DDL
 * 
 * @author bruno
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class BuildSQL4MoveTests extends AbstractInsertStatementBuilderTests {

	@InjectMocks
	private SQLStatementBuilder builder;

	@Spy
	private Properties appProperties = new Properties();

	@Before
	public void before() throws IOException {
		appProperties.load(SQLStatementBuilder.class.getClassLoader()
				.getResourceAsStream("app.properties"));
	}

	@After
	public void after() {
		appProperties.clear();
	}

	@Test
	public void testDDL4MoveData() {
		final ExtendedRuleExecutorConfig myConfig = createConfig();
		final String ddl = builder.buildSQL4MoveData(myConfig, new Date());

		assertEquals("El DD para DROP TABLE, no es el esperado", "INSERT INTO "
				+ TABLE_NAME_TO_INSERT + " SELECT D.* FROM T_"
				+ TABLE_NAME_TO_INSERT + " D JOIN (SELECT " + COLUMN_NAME_REF
				+ ", MIN(" + COLUM_NAME_ARQ_PRIORITY + ") "
				+ COLUM_NAME_ARQ_PRIORITY + " FROM T_" + TABLE_NAME_TO_INSERT
				+ " GROUP BY " + COLUMN_NAME_REF + ") M ON D."
				+ COLUMN_NAME_REF + " = M." + COLUMN_NAME_REF + " AND D."
				+ COLUM_NAME_ARQ_PRIORITY + " = M." + COLUM_NAME_ARQ_PRIORITY,
				ddl.trim());
	}

}
