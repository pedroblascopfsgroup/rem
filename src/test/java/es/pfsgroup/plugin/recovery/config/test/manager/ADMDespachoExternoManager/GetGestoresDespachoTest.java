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

public class GetGestoresDespachoTest extends AbstractADMDespachoExternoManagerTest{

	@Test
	public void testListarGestoresDespacho () throws Exception{
		List<GestorDespacho> expected = getTestData(GestorDespacho.class,new ColumnCriteria("DES_ID", 1L),new ColumnCriteria("USD_SUPERVISOR", false));
		Mockito.when(despachoExternoDao.buscarGestoresDespacho(1L)).thenReturn(expected);
		Mockito.when(despachoExternoDao.get(1L)).thenReturn(new DespachoExterno());
		
		List<GestorDespacho> result = admDespachoExternoManager.getGestoresDespacho(1L);
		
		Assert.assertEquals(expected, result);
	}
	
	@Test
	public void testIdDespachoNullLanzaExcepcion () throws Exception {
		try {
			admDespachoExternoManager.getGestoresDespacho(null);
			fail("Se debería haber lanzado una excepcion");
		} catch (IllegalArgumentException e) {
		}
		verify(despachoExternoDao,never()).buscarGestoresDespacho(null);
	}

	@Test
	public void testIdDespachoNoExisteLanzaExcepcion () throws Exception {
		try {
			admDespachoExternoManager.getGestoresDespacho(5L);
			fail("Se debería haber lanzado una excepcion");
		} catch (BusinessOperationException e) {
		}
		verify(despachoExternoDao,never()).buscarGestoresDespacho(5L);
	}
}
