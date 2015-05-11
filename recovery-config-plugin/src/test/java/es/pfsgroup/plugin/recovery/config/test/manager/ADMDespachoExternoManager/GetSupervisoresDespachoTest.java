package es.pfsgroup.plugin.recovery.config.test.manager.ADMDespachoExternoManager;

import static org.junit.Assert.fail;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

import java.util.List;

import org.junit.Assert;
import org.junit.Test;
import org.mockito.Mockito;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.testfwk.ColumnCriteria;

public class GetSupervisoresDespachoTest extends AbstractADMDespachoExternoManagerTest{
	
	@Test
	public void testListarSupervisoresDespacho () throws Exception{
		List<GestorDespacho> expected = getTestData(GestorDespacho.class,new ColumnCriteria("DES_ID", 1L),new ColumnCriteria("USD_SUPERVISOR", true));
		Mockito.when(despachoExternoDao.buscarSupervisoresDespacho(1L)).thenReturn(expected);
		Mockito.when(despachoExternoDao.get(1L)).thenReturn(new DespachoExterno());
		
		List<GestorDespacho> result = admDespachoExternoManager.getSupervisoresDespacho(1L);
		
		Assert.assertEquals(expected, result);
	}
	
	@Test
	public void testIdDespachoNullLanzaExcepcion () throws Exception {
		try {
			admDespachoExternoManager.getSupervisoresDespacho(null);
			fail("Se debería haber lanzado una excepcion");
		} catch (IllegalArgumentException e) {
		}
		verify(despachoExternoDao,never()).buscarSupervisoresDespacho(null);
	}

	@Test
	public void testIdDespachoNoExisteLanzaExcepcion () throws Exception {
		try {
			admDespachoExternoManager.getSupervisoresDespacho(5L);
			fail("Se debería haber lanzado una excepcion");
		} catch (BusinessOperationException e) {
		}
		verify(despachoExternoDao,never()).buscarSupervisoresDespacho(5L);
	}
	
}
