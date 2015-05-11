package es.pfsgroup.plugin.recovery.masivo.test.bvfactory.dao.impl.MSVDocumentoMasivoHibernateRawSQLDaoImpl;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Random;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

/**
 * Suite de pruebas del método que ejecuta una SQL talcual
 * @author bruno
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class RawDaoExecuteSQLTests extends GenericRawDaoTests{

	
	private static final String SAMPLE_QUERY = "select * form cli_clientes";
	
	Random r = new Random();

	/**
	 * Comporobamos que siempre se realiza un count
	 */
	@Test
	public void testExeuteAnySQL(){
		int count = r.nextInt();
		when(mockQuery.uniqueResult()).thenReturn(count);
		int n = rawDao.getExecuteSQL(SAMPLE_QUERY);
		verify(mockSession, times(1)).createSQLQuery(SAMPLE_QUERY);
		verify(mockQuery, times(1)).uniqueResult();
		assertEquals("No se ha devuelto el resultado esperado", count, n);
	}
}
