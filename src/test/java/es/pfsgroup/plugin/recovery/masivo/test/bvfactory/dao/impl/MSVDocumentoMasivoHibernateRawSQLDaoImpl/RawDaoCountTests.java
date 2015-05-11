package es.pfsgroup.plugin.recovery.masivo.test.bvfactory.dao.impl.MSVDocumentoMasivoHibernateRawSQLDaoImpl;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.util.Random;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;



@RunWith(MockitoJUnitRunner.class)
public class RawDaoCountTests extends GenericRawDaoTests{
	
	private static final String SAMPLE_QUERY = "SELECT * FROM ${master.schema}.GIRLS WHERE FREESEX = TRUE";

	private static final String EXPECTED_COUNT_QUERY = "select count(*) from (SELECT * FROM MASTER.GIRLS WHERE FREESEX = TRUE)";

	Random r = new Random();
	/**
	 * Comporobamos que siempre se realiza un count
	 */
	@Test
	public void testAlwaysCount(){
		
		int count = r.nextInt();
		when(mockQuery.uniqueResult()).thenReturn(count);
		int n = rawDao.getCount(SAMPLE_QUERY);
		verify(mockSession, times(1)).createSQLQuery(EXPECTED_COUNT_QUERY);
		verify(mockQuery, times(1)).uniqueResult();
		assertEquals("No se ha devuelto el resultado esperado", count, n);
	}
}
