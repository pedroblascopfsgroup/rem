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
 * @author bruno
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class DDLSQLTests extends AbstractInsertStatementBuilderTests{
	
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
	public void testDDL4DropTempTable(){
		final ExtendedRuleExecutorConfig myConfig = createConfig();
		final String ddl = builder.buildDDL4DropTemp(myConfig, new Date());
		
		assertEquals("El DD para DROP TABLE, no es el esperado", "DROP TABLE T_" + TABLE_NAME_TO_INSERT,ddl);
	}
	
	@Test
	public void testDDL4CreateTempTable(){
		final ExtendedRuleExecutorConfig myConfig = createConfig();
		final String ddl = builder.buildDDL4CreateTemp(myConfig, new Date());
		
		assertEquals("El DD para CREATE TABLE, no es el esperado", "CREATE TABLE T_" + TABLE_NAME_TO_INSERT + " AS SELECT * FROM " + TABLE_NAME_TO_INSERT + " WHERE ROWNUM < 0", ddl);
	}

}
